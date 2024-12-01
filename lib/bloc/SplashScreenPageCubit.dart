// ignore_for_file: file_names
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kronos/flutter_kronos.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/helpers/CustomException.dart';
import 'package:pos_app/helpers/IsolateManager.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/helpers/enums.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_resource.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
class SplashScreenPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashScreenPageInitial extends SplashScreenPageState {}

class LoadingSplashScreenPageData extends SplashScreenPageState {
  final Status dbConnection;
  final Status licenceStatus;
  final Status settings;
  final Status loadingData;
  final int dbConnectionMode;

  LoadingSplashScreenPageData(this.dbConnection, this.licenceStatus, this.settings, this.loadingData, this.dbConnectionMode);

  @override
  List<Object> get props => [dbConnection, licenceStatus, settings, loadingData, dbConnectionMode];
}

class SplashScreenPageLoadedState extends SplashScreenPageState {
  final int posType;
  final int dbConnectionMode;

  SplashScreenPageLoadedState(this.posType, this.dbConnectionMode);

  @override
  List<Object> get props => [posType, dbConnectionMode];
}

class ServerSettingsEmptyState extends SplashScreenPageState {}

class CantConnectToServerState extends SplashScreenPageState {}

class UnregisteredState extends SplashScreenPageState {
  final LicenseStatus licenseStatus;

  UnregisteredState(this.licenseStatus);

  @override
  List<Object> get props => [licenseStatus];
}

class SplashScreenPageErrorState extends SplashScreenPageState {
  final String _errorString;

  SplashScreenPageErrorState(this._errorString);

  String get getErrorString => _errorString;

  @override
  List<Object> get props => [_errorString];
}

//endregion States

class SplashScreenPageCubit extends Cubit<SplashScreenPageState> {
  DbService? dbService;
  final GlobalVarsProvider globalProvider;
  String host = '';
  int port = 1433;
  String dbName = '';
  String dbUName = '';
  String dbUPass = '';
  LicenseStatus licenseStatus2 = LicenseStatus.initial;

  SplashScreenPageCubit(this.globalProvider) : super(SplashScreenPageInitial());

  void loadSplashScreenPage({int? loadMode}) async {
    emit(LoadingSplashScreenPageData(Status.onProgress, Status.onProgress, Status.onProgress, Status.onProgress, 0));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    host = prefs.getString(SharedPrefKeys.serverAddress) ?? "";
    port = prefs.getInt(SharedPrefKeys.serverPort) ?? 1433;
    dbName = prefs.getString(SharedPrefKeys.dbName) ?? "";
    dbUName = prefs.getString(SharedPrefKeys.dbUName) ?? "";
    dbUPass = prefs.getString(SharedPrefKeys.dbUPass) ?? "";
    Status dbConnection = Status.onProgress;
    Status licenseStatus = Status.onProgress;
    Status settings = Status.onProgress;
    Status loadingData = Status.onProgress;

    int posType = 2;
    int dbConnectionMode = 1;
    if (host.isEmpty || dbUName.isEmpty || dbName.isEmpty || dbUPass.isEmpty) {
      emit(ServerSettingsEmptyState());
    } else {
      globalProvider.setHost = host;
      globalProvider.setPort = port;
      globalProvider.setDbName = dbName;
      globalProvider.setDbUName = dbUName;
      globalProvider.setDbUPass = dbUPass;
      dbService = DbService(host, port, dbName, dbUName, dbUPass);
      //region LoadSettings
      try {
        PermissionStatus pStatus;
        final deviceInfo =await DeviceInfoPlugin().androidInfo;
        if(deviceInfo.version.sdkInt>32){
          pStatus = await Permission.photos.request();
        }else{
          pStatus = await Permission.storage.request();
        }
        if (pStatus.isPermanentlyDenied) {
          openAppSettings();
          if(deviceInfo.version.sdkInt>32){
            pStatus = await Permission.photos.request();
          }else{
            pStatus = await Permission.storage.request();
          }
        }
        posType = prefs.getInt(SharedPrefKeys.posType) ?? 2; //1=market, 2=Resto
        if (loadMode != null) {
          prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
        }
        dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
        settings = Status.completed;
        emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
      } catch (e) {
        settings = Status.failed;
        emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        debugPrint("PrintError - SplashScreenPageCubit loadingSplashScreenPage loadSettings: $e");
      }
      //endregion LoadSettings

      //region ConnectingToDb
      try {
        await DbHelper.init();
        if (dbConnectionMode == 1) {
          //online
          if (await dbService?.connect() == 1) {
            dbConnection = Status.completed;
          }
          emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        }
        else{
          dbConnection = Status.completed;
          emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        }
      } on CantConnectToServerException catch (_) {
        dbConnection = Status.failed;
        emit(CantConnectToServerState());
      } catch (e) {
        dbConnection = Status.failed;
        emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        debugPrint("PrintError - SplashScreenPageCubit loadingSplashScreenPage ConnectingToDb: $e");
      }
      //endregion ConnectingToDb

      //region CheckingLicense
      //TODO Doly ishe bashladylanda ashakdaky 3 setiri ayyrsak license barlanya
      licenseStatus2 = LicenseStatus.registered;
      licenseStatus = Status.completed;
      emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
      if (licenseStatus2 == LicenseStatus.initial) {
        try {
          int lastOfflineCheckedDate = prefs.getInt(SharedPrefKeys.lastActivationCheckedOfflineDate) ?? 0;
          int lastOnlineCheckedDate = prefs.getInt(SharedPrefKeys.lastActivationCheckedDate) ?? 0;
          int datetime = await FlutterKronos.getCurrentTimeMs ?? DateTime.now().millisecondsSinceEpoch;
          if (lastOnlineCheckedDate == 0) {
            licenseStatus2 = LicenseStatus.unregisteredOnline;
            emit(UnregisteredState(licenseStatus2));
          } else if (lastOfflineCheckedDate == 0) {
            licenseStatus2 = LicenseStatus.unregisteredOffline;
            emit(UnregisteredState(licenseStatus2));
          } else if (DateTime.fromMillisecondsSinceEpoch(lastOnlineCheckedDate)
              .isBefore(DateTime.fromMillisecondsSinceEpoch(datetime).subtract(const Duration(days: 180)))) {
            licenseStatus2 = LicenseStatus.unregisteredOnline;
            emit(UnregisteredState(licenseStatus2));
          } else if (DateTime.fromMillisecondsSinceEpoch(lastOnlineCheckedDate)
                  .isBefore(DateTime.fromMillisecondsSinceEpoch(datetime).subtract(const Duration(days: 30))) &&
              DateTime.fromMillisecondsSinceEpoch(lastOfflineCheckedDate)
                  .isBefore(DateTime.fromMillisecondsSinceEpoch(datetime).subtract(const Duration(days: 30)))) {
            licenseStatus2 = LicenseStatus.unregisteredOffline;
            emit(UnregisteredState(licenseStatus2));
          } else {
            licenseStatus2 = LicenseStatus.registered;
          }
          licenseStatus = Status.completed;
          emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        } catch (e) {
          licenseStatus = Status.failed;
          emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
          debugPrint("PrintError - SplashScreen.LoadingData: $e");
        }
      }
      //endregion CheckingLicence

      //region LoadResources
      List<VDkResource> listVDkResource = [];
      List<TblDkResource> resources = [];
      List<TblDkResCategory> resCategoriesList = [];
      List<TblDkTable> tables = [];
      List<TblDkCartItem> cartItems = [];
      List<TblDkResCategory> tableCategories = [];
      List<TblDkEvent> events = [];
      try {
        int resPriceGroupId = 1;
        try {
          resPriceGroupId = prefs.getInt(SharedPrefKeys.resPriceGroupId) ?? 1;
        } catch (e) {
          debugPrint("PrintError SplashScreenPage.loadingData: ${e.toString()}");
        }

        if (posType == 2) {
          //restoPos
          if (dbConnectionMode == 2) {
            //offlineMode
            try {
              //region LoadTables

              await DbHelper.queryAllRows("tbl_dk_table").then((v) async {
                if (v.isNotEmpty) {
                  tables = v.map((e) => TblDkTable.fromMap(e)).toList();
                  tables.sort((a, b) => a.TableName.compareTo(b.TableName));
                  globalProvider.setTables = tables;
                } else {
                  debugPrint("Print Tables empty");
                }
              });
              //endregion LoadTables
              await DbHelper.queryVResource(resPriceGroupId).then((v) async {
                if (v.isNotEmpty) {
                  globalProvider.setResources = v;
                  listVDkResource = v;
                  debugPrint("VDkResource list length in SplashScreenpageCubit: ${listVDkResource.length}");
                } else {
                  debugPrint("Print Resources empty");
                }

                //region Load Categories
                await DbHelper.queryAllRows("tbl_dk_res_category").then((v) async {
                  if (v.isNotEmpty) {
                    resCategoriesList = v
                        .where((e) => listVDkResource
                            .where((element) =>
                                TblDkResCategory.fromMap(e).CatTypeGuid == '225fcb11-4721-4c08-98fc-1448d6e1183f' &&
                                element.ResCatId == TblDkResCategory.fromMap(e).ResCatId)
                            .isNotEmpty)
                        .map((e) => TblDkResCategory.fromMap(e))
                        .toList();
                    resCategoriesList.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
                    globalProvider.setResCategories = resCategoriesList;

                    //TableCategories
                    tableCategories = v
                        .where((e) => TblDkResCategory.fromMap(e).CatTypeGuid == '566af293-e1d4-4ea3-a95c-794e2ff3796d')
                        .map((e) => TblDkResCategory.fromMap(e))
                        .toList();
                    tableCategories.sort((a, b) => a.ResCatName.compareTo(b.ResCatName));
                    globalProvider.setTableCategories = tableCategories;
                    debugPrint("Resource cateogries length in SplashScreenpageCubit: ${(resCategoriesList+tableCategories).length}");
                    debugPrint("Print getting ResCategories done");
                  } else {
                    debugPrint("Print ResCategories empty");
                  }
                });

                //CartItems
                await DbHelper.queryAllRows("tbl_dk_cart_item").then((v) async {
                  if (v.isNotEmpty) {
                    cartItems = v.map((e) => TblDkCartItem.fromMap(e)).toList();
                    cartItems.sort((a, b) => a.ResId.compareTo(b.ResId));
                    globalProvider.setCartItems = cartItems;
                    debugPrint("CartItems length in SplashScreenpageCubit: ${cartItems.length}");
                  } else {
                    debugPrint("Print CartItems empty");
                  }
                });

                //Events
                await DbHelper.queryAllRows("tbl_dk_event").then((v) async {
                  if (v.isNotEmpty) {
                    events = v.map((e) => TblDkEvent.fromMap(e)).toList();
                    events.sort((a, b) => a.EventId.compareTo(b.EventId));
                    globalProvider.setReservations = events;
                    debugPrint("Reservations length in SplashScreenPageCubit: ${events.length}");
                  } else {
                    debugPrint("Print Reservations empty");
                  }
                });
                //endregion
              });
              loadingData = Status.completed;
              emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
            } catch (e) {
              loadingData = Status.failed;
              emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
              debugPrint("Print error getting ResCategories (${e.toString()})");
            }
          } else {
            //OnlineMode
            try {
              tables = await dbService!.getTables();
              tableCategories = await dbService!.getTableCategories();
              listVDkResource = await dbService!.getVResources(resPriceGroupId);
              resources = await dbService!.getResources();
              resCategoriesList = await dbService!.getResCategories();
              tables.sort((a, b) => a.TableName.compareTo(b.TableName));
              tableCategories.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
              globalProvider.setTables = tables;
              globalProvider.setTableCategories = tableCategories;
              globalProvider.setResources = listVDkResource;
              globalProvider.setResCategories = resCategoriesList;
              loadingData = Status.completed;
              resCategoriesList.addAll(tableCategories);
              //TODO Isolate gornushde harytlary bazadan alyp lokalnyy baza atmaly.
              _saveTablesToDb(tables);
              _saveResCategoriesToDb(resCategoriesList);
              _saveResourcesToDb(resources);
              emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
            } on CantConnectToServerException catch (_) {
              loadingData = Status.failed;
              emit(CantConnectToServerState());
            } catch (e) {
              loadingData = Status.failed;
              emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
              debugPrint("Print error getting ResCategories (${e.toString()})");
            }
          }
        } else {
          //MarketPOS
        }
      } catch (e) {
        loadingData = Status.failed;
        emit(LoadingSplashScreenPageData(dbConnection, licenseStatus, settings, loadingData, dbConnectionMode));
        debugPrint("Print error getting Resources (${e.toString()})");
      }
      //endregion LoadResources

      if (dbConnection == Status.completed &&
          licenseStatus == Status.completed &&
          settings == Status.completed &&
          loadingData == Status.completed) {
        emit(SplashScreenPageLoadedState(posType, dbConnectionMode));
      }
    }
  }

  final isolateManager = IsolateManager();
  void _saveTablesToDb(List<TblDkTable> tables) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertTablesList(
            'tbl_dk_table', tables);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint(
            'Inserting tables to database completed successfully in SplashScreenPageCubit');
      } else {
        debugPrint(
            'Inserting tables to database failed in SplashScreenPageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveTablesToDb: ${e.toString()}');
      rethrow;
    }
  }

  void _saveResourcesToDb(List<TblDkResource> resources) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertResourceList('tbl_dk_resources', resources);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint('Inserting resources to database completed successfully in SplashScreenPageCubit');
      } else {
        debugPrint('Inserting resources to database failed in SplashScreenPageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveResourcesToDb: ${e.toString()}');
      rethrow;
    }
  }

  void _saveResCategoriesToDb(List<TblDkResCategory> resCategories) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertCategoryList('tbl_dk_res_category', resCategories);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint('Inserting resource categories to database completed successfully in SplashScreenPageCubit');
      } else {
        debugPrint('Inserting resource categories to database failed in SplashScreenPageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveResCategoriesToDb: ${e.toString()}');
      rethrow;
    }
  }
}
