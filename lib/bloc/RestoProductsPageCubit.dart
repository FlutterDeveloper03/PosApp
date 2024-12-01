// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/helpers/CustomException.dart';
import 'package:pos_app/helpers/IsolateManager.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_resource.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
class RestoPosProductsPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestoPosProductsPageInitialState extends RestoPosProductsPageState {}

class LoadingRestoPosProductsPageState extends RestoPosProductsPageState {}

class RestoPosProductsPageLoadedState extends RestoPosProductsPageState {
  RestoPosProductsPageLoadedState();

  @override
  List<Object?> get props => [];
}

class RestoPosProductsPageLoadErrorState extends RestoPosProductsPageState {
  final String errorMsg;

  RestoPosProductsPageLoadErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class RPPCCantConnectToServerState extends RestoPosProductsPageState {}
//endregion states

//region Cubit
class RestoPosProductsPageCubit extends Cubit<RestoPosProductsPageState> {
  int dbConnectionMode = 1;
  int resPriceGroupId = 1;
  DbService? dbService;
  final GlobalVarsProvider globalProvider;

  RestoPosProductsPageCubit(this.globalProvider) : super(RestoPosProductsPageInitialState());

  void loadRestoPosProductsPage() async {
    try {
      emit(LoadingRestoPosProductsPageState());
      PermissionStatus pStatus = await Permission.storage.request();
      if (pStatus.isPermanentlyDenied) {
        openAppSettings();
        pStatus = await Permission.storage.request();
      }
      emit(RestoPosProductsPageLoadedState());
    } on Exception catch (e) {
      emit(RestoPosProductsPageLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }

  void reloadData({int? loadMode}) async {
    emit(LoadingRestoPosProductsPageState());
    try {
      dbService = DbService(
          globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (loadMode != null) {
        prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
      }
      dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
      resPriceGroupId = prefs.getInt(SharedPrefKeys.resPriceGroupId) ?? 1;

      List<VDkResource> resources = [];
      List<TblDkResource> tblResources = [];
      List<TblDkResCategory> resCategories = [];

      if (dbConnectionMode == 2) {
        //offlineMode
        try {
          await DbHelper.queryAllRows("tbl_dk_res_category",where: "CatTypeGuid='225FCB11-4721-4C08-98FC-1448D6E1183F'").then((v) async {
            if (v.isNotEmpty) {
              resCategories = v.map((e) => TblDkResCategory.fromMap(e)).toList();
              resCategories.sort((a, b) => a.ResCatName.compareTo(b.ResCatName));
              globalProvider.setResCategories = resCategories;
              debugPrint("Print getting resCategories done");
            } else {
              debugPrint("Print resCategories empty");
            }
          });

          await DbHelper.queryAllRows('tbl_dk_resources').then((v) async {
            resources = v.map((e) => VDkResource.fromMap(e)).toList();
            resources.sort((a, b) => b.ResName.compareTo(a.ResName));
          });
          emit(RestoPosProductsPageLoadedState());
        } catch (e) {
          emit(RestoPosProductsPageLoadErrorState(e.toString()));
          debugPrint("Print error getting Resources (${e.toString()})");
        }
      } else {
        //OnlineMode
        try {
          resCategories = await dbService!.getResCategories();
          resCategories.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
          globalProvider.setResCategories = resCategories;
          await dbService!.getVResources(resPriceGroupId).then((value) {
            resources = value;
            resources.sort((a, b) => b.ResName.compareTo(a.ResName));
            //TODO Isolate gornushde harytlary lokalnyy baza atmaly.
          });
          await dbService!.getResources().then((value) {
            tblResources = value;
            _saveResourcesToDb(tblResources);
            //TODO Isolate gornushde harytlary lokalnyy baza atmaly.
          });
        } on CantConnectToServerException catch (_) {
          emit(RPPCCantConnectToServerState());
        } catch (e) {
          emit(RestoPosProductsPageLoadErrorState(e.toString()));
          debugPrint("Print error getting resourcesOnline: (${e.toString()})");
        }
        globalProvider.setResources = resources;
        emit(RestoPosProductsPageLoadedState());
      }
      emit(RestoPosProductsPageLoadedState());
    } catch (e) {
      emit(RestoPosProductsPageLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }
  final isolateManager = IsolateManager();
  void _saveResourcesToDb(List<TblDkResource> resources) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertResourceList('tbl_dk_resources', resources);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint('Inserting resources to database completed successfully in RestoProductsPageCubit');
      } else {
        debugPrint('Inserting resources to database failed in RestoProductsPageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveResourcesToDb: ${e.toString()}');
      rethrow;
    }
  }
}
//endregion Cubit
