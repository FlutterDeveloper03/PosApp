// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/helpers/CustomException.dart';
import 'package:pos_app/helpers/IsolateManager.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tbl_dk_cart_item.dart';

//region States
class RestoPosHomePageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestoPosHomePageInitialState extends RestoPosHomePageState {}

class LoadingRestoPosHomePageState extends RestoPosHomePageState {}

class MergingFailedState extends RestoPosHomePageState {
  final String errorMsg;

  MergingFailedState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class DividingFailedState extends RestoPosHomePageState {
  final String errorMsg;

  DividingFailedState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class RPHPCantConnectToServerState extends RestoPosHomePageState {}

// class CantReserveState extends RestoPosHomePageState {
//   final String errorMsg;
//
//   CantReserveState(this.errorMsg);
//
//   @override
//   List<Object?> get props => [errorMsg];
// }
//
// class TableReservedState extends RestoPosHomePageState {
//   final TblDkEvent event;
//
//   TableReservedState(this.event);
//
//   @override
//   List<Object?> get props => [event];
// }
//
// class CantModifyEventState extends RestoPosHomePageState {
//   final String errorMsg;
//
//   CantModifyEventState(this.errorMsg);
//
//   @override
//   List<Object?> get props => [errorMsg];
// }
//
// class EventModifiedState extends RestoPosHomePageState{}

class RestoHomePageLoadedState extends RestoPosHomePageState {
  RestoHomePageLoadedState();

  @override
  List<Object?> get props => [];
}

class RestoPosHomePageLoadErrorState extends RestoPosHomePageState {
  final String errorMsg;

  RestoPosHomePageLoadErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
//endregion states

//region Cubit
class RestoPosHomePageCubit extends Cubit<RestoPosHomePageState> {
  int dbConnectionMode = 1;
  DbService? dbService;
  final GlobalVarsProvider globalProvider;

  RestoPosHomePageCubit(this.globalProvider) : super(RestoPosHomePageInitialState());

  void loadRestoPosHomePage() => emit(RestoHomePageLoadedState());

  void reloadData({int? loadMode}) async {
    emit(LoadingRestoPosHomePageState());
    try {
      dbService = DbService(
          globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (loadMode != null) {
        prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
      }
      dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline

      List<TblDkTable> tables = [];
      List<TblDkResCategory> tableCategories = [];
      List<TblDkCartItem> cartItems = [];
      if (dbConnectionMode == 2) {
        //offlineMode
        try {
          await DbHelper.queryAllRows("tbl_dk_res_category",where: "CatTypeGuid='566af293-e1d4-4ea3-a95c-794e2ff3796d'").then((v) async {
            if (v.isNotEmpty) {
              tableCategories = v.map((e) => TblDkResCategory.fromMap(e)).toList();
                  // .where((e) => TblDkResCategory.fromMap(e).CatTypeGuid == '566af293-e1d4-4ea3-a95c-794e2ff3796d')
                  // .map((e) => TblDkResCategory.fromMap(e))
                  // .toList();
              tableCategories.sort((a, b) => a.ResCatName.compareTo(b.ResCatName));
              globalProvider.setTableCategories = tableCategories;
              debugPrint("Print getting ResCategories done");
            } else {
              debugPrint("Print ResCategories empty");
            }
          });

          await DbHelper.queryAllRows('tbl_dk_table').then((v) async {
            tables = v.map((e) => TblDkTable.fromMap(e)).toList();
            tables.sort((a, b) => b.TableName.compareTo(a.TableName));
            globalProvider.setTables = tables;
          });

          //CartItems
          await DbHelper.queryAllRows("tbl_dk_cart_item").then((v) async {
            if (v.isNotEmpty) {
              cartItems = v.map((e) => TblDkCartItem.fromMap(e)).toList();
              cartItems.sort((a, b) => a.ResId.compareTo(b.ResId));
              globalProvider.setCartItems = cartItems;
              debugPrint("CartItems length in RestoPosHomePageCubit: ${cartItems.length}");
            } else {
              debugPrint("Print CartItems empty");
            }
          });
          emit(RestoHomePageLoadedState());
        } catch (e) {
          emit(RestoPosHomePageLoadErrorState(e.toString()));
          debugPrint("Print error getting ResCategories (${e.toString()})");
        }
      } else {
        //OnlineMode
        try {
          tableCategories = await dbService!.getTableCategories();
          tableCategories.sort((a, b) => a.ResCatId.compareTo(b.ResCatId));
          globalProvider.setTableCategories = tableCategories;
          await dbService!.getTables().then((value) {
            tables = value;
            tables.sort((a, b) => b.TableName.compareTo(a.TableName));
            //TODO Isolate gornushde stollary lokalnyy baza atmaly.
            _saveTablesToDb(tables);
          });
        } on CantConnectToServerException catch (_) {
          emit(RPHPCantConnectToServerState());
        } catch (e) {
          emit(RestoPosHomePageLoadErrorState(e.toString()));
          debugPrint("Print error getting ResCategories (${e.toString()})");
        }
        globalProvider.setTables = tables;
        emit(RestoHomePageLoadedState());
      }
      emit(RestoHomePageLoadedState());
    } catch (e) {
      emit(RestoPosHomePageLoadErrorState("Error on LoadCategoriesEvent: $e"));
    }
  }

  void mergeTables(List<String> tableGuids, TblDkTable newMergedTable) async {
    emit(LoadingRestoPosHomePageState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dbConnectionMode = prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1; //1=online, 2=offline
    if (dbConnectionMode == 2) {
      //offlineMode
      try {
        DbHelper.mergeTables(tableGuids, newMergedTable);
        List<TblDkTable> tables = globalProvider.getTables;
        int? firstIndex;
        for (var element in globalProvider.getTables) {
          if (tableGuids.contains(element.TableGuid)) {
            firstIndex ??= tables.indexOf(element);
            tables.remove(element);
          }
        }
        tables.insert(firstIndex!, newMergedTable);
        tables.sort((a, b) => b.TableName.compareTo(a.TableName));
        globalProvider.setTables = tables;
        emit(RestoHomePageLoadedState());
      } catch (e) {
        emit(MergingFailedState(e.toString()));
      }
    } else {
      //OnlineMode
      try {
        dbService = DbService(
            globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
        bool? mergeState = await dbService?.mergeTables(tableGuids, newMergedTable);
        if (mergeState == true) {
          List<TblDkTable> tables =List.from(globalProvider.getTables);
          int? firstIndex;
          for (var element in globalProvider.getTables) {
            if (tableGuids.contains(element.TableGuid)) {
              firstIndex ??= tables.indexOf(element);
              tables.remove(element);
            }
          }
          tables.insert(firstIndex!, newMergedTable);
          tables.sort((a, b) => b.TableName.compareTo(a.TableName));
          globalProvider.setTables = tables;
          emit(RestoHomePageLoadedState());
          //TODO Isolate gornushde stollary lokalnyy baza atmaly.
          _saveTablesToDb(tables);
        } else {
          emit(MergingFailedState("Merging Failed"));
        }
      } on CantConnectToServerException catch (_) {
        emit(RPHPCantConnectToServerState());
      } catch (e) {
        debugPrint("PrintError from mergeTables().online: ${e.toString()}");
        emit(MergingFailedState(e.toString()));
      }
    }
  }

  void divideTables(List<TblDkTable> tables) async {
    emit(LoadingRestoPosHomePageState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dbConnectionMode = prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1; //1=online, 2=offline
    List<TblDkTable> mergedTables = tables
        .where(
          (element) => element.TableTypeId == 3,
        )
        .toList();
    List<String> groupGuids = [];
    for (var table in mergedTables) {
      groupGuids.add(table.TableGroupGuid ?? '');
    }
    if (dbConnectionMode == 2) {
      //offlineMode
      try {
        DbHelper.divideTables(groupGuids);
        List<TblDkTable> tables2 = globalProvider.getTables;
        tables2.removeWhere((element) => mergedTables.contains(element));
        tables2.sort((a, b) => b.TableName.compareTo(a.TableName));
        globalProvider.setTables = tables2;
        emit(RestoHomePageLoadedState());
      } catch (e) {
        emit(DividingFailedState(e.toString()));
      }
    } else {
      //OnlineMode
      try {
        dbService = DbService(
            globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);

        bool? divideState = await dbService?.divideTables(groupGuids);
        if (divideState == true) {
          List<TblDkTable> tables2 = globalProvider.getTables;
          tables2.removeWhere((element) => mergedTables.contains(element));
          tables2.sort((a, b) => b.TableName.compareTo(a.TableName));
          globalProvider.setTables = tables2;
          emit(RestoHomePageLoadedState());
          //TODO Isolate gornushde stollary lokalnyy baza atmaly.
          _saveTablesToDb(tables2);
        } else {
          emit(DividingFailedState("Merging Failed"));
        }
      } on CantConnectToServerException catch (_) {
        emit(RPHPCantConnectToServerState());
      } catch (e) {
        debugPrint("PrintError from divideTables().online: ${e.toString()}");
        emit(DividingFailedState(e.toString()));
      }
    }
  }


  final isolateManager = IsolateManager();
  void _saveTablesToDb(List<TblDkTable> tables) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertTablesList('tbl_dk_table', tables);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint('Inserting tables to database completed successfully in RestoHomePageCubit');
      } else {
        debugPrint('Inserting tables to database failed in RestoHomePageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveTablesToDb: ${e.toString()}');
      rethrow;
    }
  }

  //region Deprecated
  //
  // void reserveTable(TblDkEvent reserveEvent, {int? loadMode}) async {
  //   emit(LoadingRestoPosHomePageState());
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (loadMode != null) {
  //     prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
  //   }
  //   dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
  //   bool? reserveState = false;
  //   if (dbConnectionMode == 2) {
  //     //offlineMode
  //     try {
  //       reserveState = (await DbHelper.insert('tbl_dk_event', reserveEvent))==1 ? true : false;
  //     } catch (e) {
  //       emit(CantReserveState("PrintError from reserveTable().online: ${e.toString()}"));
  //     }
  //   } else {
  //     //OnlineMode
  //     try {
  //       dbService = DbService(
  //           globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
  //       reserveState = await dbService?.addEvent(reserveEvent
  //       );
  //     } on CantConnectToServerException catch (_) {
  //       emit(CantConnectToServerState());
  //     } on CantFindEventsTableException catch (_) {
  //       try {
  //         reserveState = await dbService?.addEvent(reserveEvent);
  //       } catch (e) {
  //         emit(CantReserveState("PrintError from reserveTable().online: ${e.toString()}"));
  //       }
  //     }
  //     catch (e) {
  //       debugPrint("PrintError from reserveTable().online: ${e.toString()}");
  //       emit(CantReserveState(e.toString()));
  //     }
  //   }
  //   if (reserveState ?? false) {
  //     emit(TableReservedState(reserveEvent));
  //   } else {
  //     emit(CantReserveState('Näbelli ýalňyşlyk'));
  //   }
  //   emit(RestoHomePageLoadedState());
  // }
  //
  // void modifyReservation(TblDkEvent reservedEvent, {bool? delete,int? loadMode}) async {
  //   emit(LoadingRestoPosHomePageState());
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (loadMode != null) {
  //     prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
  //   }
  //   dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
  //   bool? modifiedState = false;
  //   if (dbConnectionMode == 2) {
  //     //offlineMode
  //     try {
  //       if (delete == true) {
  //         modifiedState = (await DbHelper.delete('tbl_dk_event', where: 'EventId= ?',whereArgs: [reservedEvent.EventId.toString()]))==1 ? true : false;
  //       } else {
  //         modifiedState = (await DbHelper.update('tbl_dk_event','EventId',reservedEvent))==1 ? true : false;
  //       }
  //     } catch (e) {
  //       emit(CantModifyEventState("PrintError from modifyReservation().offline: ${e.toString()}"));
  //     }
  //   } else {
  //     //OnlineMode
  //     try {
  //       dbService = DbService(
  //           globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
  //       modifiedState = await dbService?.modifyEvent(reservedEvent,delete: delete);
  //     } on CantConnectToServerException catch (_) {
  //       emit(CantConnectToServerState());
  //     }  catch (e) {
  //       debugPrint("PrintError from modifyReservation().online: ${e.toString()}");
  //       emit(CantModifyEventState(e.toString()));
  //     }
  //   }
  //   if (modifiedState ?? false) {
  //     emit(EventModifiedState());
  //   }
  //   emit(RestoHomePageLoadedState());
  // }
  //endregion Deprecated
}
//endregion Cubit
