// ignore_for_file: file_names

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/helpers/IsolateManager.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/models/tbl_dk_image.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';


//region Events

class ImageLoaderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadImageEvent extends ImageLoaderEvent {
  final int resId;
  final int? loadMode;

  LoadImageEvent(this.resId,{this.loadMode});

  @override
  List<Object> get props => [resId,loadMode ?? 1];
}

//endregion Events


//region States
class ImageLoaderState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImageLoaderInitialState extends ImageLoaderState {}

class LoadingImageState extends ImageLoaderState {}

class ImageEmptyState extends ImageLoaderState {}

class ImageLoadedState extends ImageLoaderState {
  final Uint8List? imageBytes;

  ImageLoadedState(this.imageBytes);


  @override
  List<Object> get props => [imageBytes ?? Uint8List(0)];

  @override
  String toString() {
    return "ImageLoadedState";
  }
}

class ImageLoadErrorState extends ImageLoaderState {}

//endregion States

//region Bloc

// class ImageLoaderBloc extends Bloc<ImageLoaderEvent, ImageLoaderState> {
//   int dbConnectionMode = 1;
//   DbService? dbService;
//   final GlobalVarsProvider globalProvider;
//   ImageLoaderBloc(this.globalProvider) : super(ImageLoaderInitialState()){
//     on<LoadImageEvent>(onLoadImageEvent);
//   }
//
//
//   void onLoadImageEvent(LoadImageEvent event, Emitter<ImageLoaderState> emit)async{
//     final prefs = await SharedPreferences.getInstance();
//     dbConnectionMode = prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1;
//     emit(LoadingImageState());
//     if (dbConnectionMode==2){
//       //region offline mode
//       try {
//         Map<String, dynamic> imageMap = await DbHelper.queryFirstRow(
//             "tbl_dk_image",
//             where: "ResId=${event.resId}");
//         if (imageMap.isNotEmpty) {
//           TblDkImage image = TblDkImage.fromMap(imageMap);
//           emit(ImageLoadedState(image.Image));
//         } else {
//           emit(ImageEmptyState());
//         }
//       } catch (e) {
//         debugPrint('Print error load image: ${e.toString()}');
//         emit(ImageLoadErrorState());
//       }
//       //endregion offline mode
//     } else {
//       //region online mode
//       try {
//         dbService = DbService(
//             globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
//         Map<String, dynamic> imageMap = await DbHelper.queryFirstRow(
//             "tbl_dk_image",
//             where: "ResId=${event.resId}");
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         int imageTimeoutSec = prefs.getInt(SharedPrefKeys.imgTimeout) ?? 60;
//         PermissionStatus pStatus;
//         final deviceInfo =await DeviceInfoPlugin().androidInfo;
//         if(deviceInfo.version.sdkInt>32){
//           pStatus = await Permission.photos.status;
//         }else{
//           pStatus = await Permission.storage.status;
//         }
//         if (imageMap.isNotEmpty) {
//           TblDkImage image = TblDkImage.fromMap(imageMap);
//           if (image.SyncDateTime?.isBefore(DateTime.now().subtract(Duration(seconds: imageTimeoutSec))) ?? true){
//             TblDkImage? img =(await dbService?.getImageByHash(event.resId,imgHash: image.FileHash))?.first;
//             emit(ImageLoadedState(img?.Image ?? image.Image));
//             if (img!=null) {
//
//               if (pStatus.isGranted) {
//                 // compute<TblDkImage, void>(_saveImgToDb, img);
//                 _saveImgToDb(img);
//               }
//             }
//           } else {
//             emit(ImageLoadedState(image.Image));
//           }
//         } else {
//           List<TblDkImage>? images =(await dbService?.getImageByHash(event.resId));
//           if (images!=null && images.isNotEmpty){
//             emit(ImageLoadedState(images.first.Image));
//               if (pStatus.isGranted) {
//                 // compute<TblDkImage, void>(_saveImgToDb, images.first);
//                 _saveImgToDb(images.first);
//               }
//           } else {
//             emit(ImageEmptyState());
//           }
//         }
//       } catch (e) {
//         debugPrint('Print error load image: ${e.toString()}');
//         emit(ImageLoadErrorState());
//       }
//       //endregion online mode
//     }
//   }
//
//   // static void _saveImgToDb(TblDkImage image,) async {
//   //   try {
//   //     await DbHelper.init();
//   //     await DbHelper.delete('tbl_dk_image', where: "ImgId=${image.ImgId}");
//   //     await DbHelper.insert('tbl_dk_image', image);
//   //   } catch(e) {
//   //     debugPrint('Print error _saveImgToDb: ${e.toString()}');
//   //     rethrow;
//   //   }
//   // }
// }

class ImageLoaderBloc extends Bloc<ImageLoaderEvent, ImageLoaderState> {
  int dbConnectionMode = 1;
  DbService? dbService;
  final GlobalVarsProvider globalProvider;

  final CacheManager _cacheManager = DefaultCacheManager();

  ImageLoaderBloc(this.globalProvider) : super(ImageLoaderInitialState()) {
    on<LoadImageEvent>(onLoadImageEvent);
  }

  void onLoadImageEvent(LoadImageEvent event, Emitter<ImageLoaderState> emit) async {
    debugPrint('LoadImageEvent triggered for resId=${event.resId}');

    FileInfo? cachedImage = await _cacheManager.getFileFromCache(event.resId.toString());

    if (cachedImage != null) {
      debugPrint('Image found in cache for resId=${event.resId}');
      emit(ImageLoadedState(await cachedImage.file.readAsBytes()));
      return;
    }

    debugPrint('Image not in cache for resId=${event.resId}, loading from source');

    final prefs = await SharedPreferences.getInstance();
    dbConnectionMode = prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1;
    emit(LoadingImageState());

    try {
      Uint8List? imageBytes;

      if (dbConnectionMode == 2) {
        // Offline mode
        debugPrint('Loading image from database for resId=${event.resId}');
        imageBytes = await _loadImageFromDatabase(event.resId);
      } else {
        // Online mode
        debugPrint('Loading image from server for resId=${event.resId}');
        imageBytes = await _loadImageFromServer(event);
      }

      if (imageBytes != null) {
        debugPrint('Image loaded successfully for resId=${event.resId}, caching it');
        _cacheImage(event.resId, imageBytes);
        emit(ImageLoadedState(imageBytes));
      } else {
        debugPrint('Image not found for resId=${event.resId}');
        emit(ImageEmptyState());
      }
    } catch (e) {
      debugPrint('Print error loading image for resId=${event.resId}: ${e.toString()}');
      emit(ImageLoadErrorState());
    }
  }


  Future<Uint8List?> _loadImageFromDatabase(int resId) async {
    try {
      Map<String, dynamic> imageMap = await DbHelper.queryFirstRow(
        "tbl_dk_image",
        where: "ResId=$resId",
      );
      if (imageMap.isNotEmpty) {
        TblDkImage image = TblDkImage.fromMap(imageMap);
        return image.Image;
      }
    } catch (e) {
      debugPrint('Print error load image from database for resId=$resId: ${e.toString()}');
    }
    return null;
  }

  // Future<Uint8List?> _loadImageFromServer(LoadImageEvent event) async {
  //   try {
  //     dbService = DbService(
  //       globalProvider.getHost,
  //       globalProvider.getPort,
  //       globalProvider.getDbName,
  //       globalProvider.getDbUName,
  //       globalProvider.getDbUPass,
  //     );
  //
  //     Map<String, dynamic> imageMap = await DbHelper.queryFirstRow(
  //       "tbl_dk_image",
  //       where: "ResId=${event.resId}",
  //     );
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     int imageTimeoutSec = prefs.getInt(SharedPrefKeys.imgTimeout) ?? 60;
  //     PermissionStatus pStatus;
  //     final deviceInfo = await DeviceInfoPlugin().androidInfo;
  //
  //     if (deviceInfo.version.sdkInt > 32) {
  //       pStatus = await Permission.photos.status;
  //     } else {
  //       pStatus = await Permission.storage.status;
  //     }
  //
  //     if (imageMap.isNotEmpty) {
  //       TblDkImage image = TblDkImage.fromMap(imageMap);
  //       if (image.SyncDateTime?.isBefore(DateTime.now().subtract(Duration(seconds: imageTimeoutSec))) ?? true) {
  //         TblDkImage? img = (await dbService?.getImageByHash(event.resId, imgHash: image.FileHash))?.first;
  //         if (img != null && pStatus.isGranted) {
  //           debugPrint('Image has changed, saving new image to database for resId=${event.resId}');
  //           _saveImgToDb(img);
  //         }
  //         return img?.Image ?? image.Image;
  //       } else {
  //         return image.Image;
  //       }
  //     } else {
  //       List<TblDkImage>? images = (await dbService?.getImageByHash(event.resId));
  //       if (images != null && images.isNotEmpty) {
  //         if (pStatus.isGranted) {
  //           debugPrint('Saving new image to database for resId=${event.resId}');
  //           _saveImgToDb(images.first);
  //         }
  //         return images.first.Image;
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Print error load image from server for resId=${event.resId}: ${e.toString()}');
  //   }
  //   return null;
  // }

  Future<Uint8List?> _loadImageFromServer(LoadImageEvent event) async {
    try {
      dbService = DbService(
        globalProvider.getHost,
        globalProvider.getPort,
        globalProvider.getDbName,
        globalProvider.getDbUName,
        globalProvider.getDbUPass,
      );

      Map<String, dynamic> imageMap = await DbHelper.queryFirstRow(
        "tbl_dk_image",
        where: "ResId=${event.resId}",
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int imageTimeoutSec = prefs.getInt(SharedPrefKeys.imgTimeout) ?? 60;

      PermissionStatus pStatus;
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt > 32) {
        pStatus = await Permission.photos.status;
      } else {
        pStatus = await Permission.storage.status;
      }

      if (imageMap.isNotEmpty) {
        TblDkImage image = TblDkImage.fromMap(imageMap);

        // Check if image is outdated
        if (image.SyncDateTime?.isBefore(DateTime.now().subtract(Duration(seconds: imageTimeoutSec))) ?? true) {
          List<TblDkImage>? updatedImages = await dbService?.getImageByHash(event.resId, imgHash: image.FileHash);
          TblDkImage? updatedImage = updatedImages?.first;

          if (updatedImage != null && pStatus.isGranted) {
            if (image.FileHash != updatedImage.FileHash) {
              debugPrint('Image has changed, saving new image to database for resId=${event.resId}');
              _saveImgToDb(updatedImage);
            }
            return updatedImage.Image;
          }
          else {
            return image.Image;
          }
        } else {
          return image.Image;
        }
      } else {
        List<TblDkImage>? images = await dbService?.getImageByHash(event.resId);

        if (images != null && images.isNotEmpty && pStatus.isGranted) {
          debugPrint('Saving new image to database for resId=${event.resId}');
          _saveImgToDb(images.first);
          return images.first.Image;
        }
        else{
          return null;
        }
      }
    } catch (e) {
      debugPrint('Print error loading image from server for resId=${event.resId}: ${e.toString()}');
    }
    return null;
  }



  Future<void> _cacheImage(int resId, Uint8List imageBytes) async {
    await _cacheManager.putFile(
      resId.toString(),
      imageBytes
    );
    debugPrint('Image cached for resId=$resId');
  }

  void dispose() {
    isolateManager.dispose();
    _cacheManager.emptyCache();
  }
}


final isolateManager = IsolateManager();


void _saveImgToDb(TblDkImage image) async {
  try {
    final result = await isolateManager.addTask(() async {
      await DbHelper.init();
      await DbHelper.delete('tbl_dk_image', where: "ImgId=${image.ImgId}");
      final rowsInserted = await DbHelper.insert('tbl_dk_image', image);
      return rowsInserted > 0;
      // // Check if the image already exists in the database
      // Map<String, dynamic>? existingImageMap = await DbHelper.queryFirstRow(
      //   'tbl_dk_image',
      //   where: "ImgId=${image.ImgId}",
      // );
      //
      // if (existingImageMap.isNotEmpty) {
      //   TblDkImage existingImage = TblDkImage.fromMap(existingImageMap);
      //
      //   // Compare the file hash to determine if the image is different
      //   if (existingImage.FileHash == image.FileHash) {
      //     debugPrint('Image with ImgId=${image.ImgId} and the same hash already exists. Skipping save.');
      //     return false;
      //   }
      //
      //   // If the image exists but has a different hash, update it
      //   debugPrint('Image with ImgId=${image.ImgId} exists but has a different hash. Updating image.');
      //   await DbHelper.update(
      //     'tbl_dk_image',
      //     'ImgId',
      //     image,
      //   );
      //   return true;
      // }
    });

    if (result) {
      debugPrint('Inserting image to database completed successfully in ImageLoaderBloc');
    } else {
      debugPrint('Inserting image to database was skipped in ImageLoaderBloc');
    }
  } catch (e) {
    debugPrint('Print error _saveImgToDb: ${e.toString()}');
    rethrow;
  }
}


// void _saveImgToDb(TblDkImage image) async {
//   try {
//     final result = await isolateManager.addTask(() async {
//       await DbHelper.init();
//
//       Map<String, dynamic>? existingImageMap = await DbHelper.queryFirstRow(
//         'tbl_dk_image',
//         where: "ImgId=${image.ImgId}",
//       );
//
//       if (existingImageMap.isNotEmpty) {
//         TblDkImage existingImage = TblDkImage.fromMap(existingImageMap);
//
//         if (existingImage.FileHash == image.FileHash) {
//           debugPrint('Image with ImgId=${image.ImgId} and the same hash already exists. Skipping save.');
//           return false;
//         }
//       }
//
//       await DbHelper.delete('tbl_dk_image', where: "ImgId=${image.ImgId}");
//       final rowsInserted = await DbHelper.insert('tbl_dk_image', image);
//       return rowsInserted > 0;
//     });
//
//     if (result) {
//       debugPrint('Inserting image to database completed successfully in ImageLoaderBloc');
//     } else {
//       debugPrint('Inserting image to database was skipped in ImageLoaderBloc');
//     }
//   } catch (e) {
//     debugPrint('Print error _saveImgToDb: ${e.toString()}');
//     rethrow;
//   }
// }




//-----old version of saving image-----------------//
// void _saveImgToDb(TblDkImage image) async {
//   try {
//     final result = await isolateManager.addTask(() async {
//       await DbHelper.init();
//       await DbHelper.delete('tbl_dk_image', where: "ImgId=${image.ImgId}");
//       final rowsInserted = await DbHelper.insert('tbl_dk_image', image);
//       return rowsInserted > 0; // Return success status
//     });
//
//     if (result) {
//       debugPrint('Inserting images to database completed successfully in ImageLoaderBloc');
//     } else {
//       debugPrint('Inserting images to database failed in ImageLoaderBloc');
//     }
//   } catch (e) {
//     debugPrint('Print error _saveImgToDb: ${e.toString()}');
//     rethrow;
//   }
// }


//endregion Bloc