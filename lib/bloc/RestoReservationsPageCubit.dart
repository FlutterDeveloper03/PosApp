// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/helpers/CustomException.dart';
import 'package:pos_app/helpers/IsolateManager.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/services/DbService.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region States
class RestoReservationPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestoReservationPageInitialState extends RestoReservationPageState {}

class LoadingRestoReservationPageState extends RestoReservationPageState {}

class RestoReservationPageLoadedState extends RestoReservationPageState {
  final List<TblDkEvent> events;

  RestoReservationPageLoadedState(this.events);

  @override
  List<Object?> get props => [events];
}
class EventModifiedState extends RestoReservationPageState {}

class ReservedState extends RestoReservationPageState {
  final TblDkEvent event;

  ReservedState(this.event);

  @override
  List<Object?> get props => [event];
}

class CantReserveState extends RestoReservationPageState {
  final String errorMsg;

  CantReserveState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class CantModifyEventState extends RestoReservationPageState {
  final String errorMsg;

  CantModifyEventState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class RRPCantConnectToServerState extends RestoReservationPageState {}

class PageLoadingFailedState extends RestoReservationPageState {
  final String errorMsg;

  PageLoadingFailedState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

//endregion states

//region Cubit
class RestoReservationPageCubit extends Cubit<RestoReservationPageState> {
  int dbConnectionMode = 1;
  DbService? dbService;
  final GlobalVarsProvider globalProvider;

  RestoReservationPageCubit(this.globalProvider) : super(RestoReservationPageInitialState());

  void loadRestoReservationPage({int? loadMode, int? tableId, DateTime? startDate, DateTime? endDate}) async {
    emit(LoadingRestoReservationPageState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (loadMode != null) {
        prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
      }
      dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
      List<TblDkEvent> events = [];

      if (dbConnectionMode == 2) {
        //offlineMode
        try {
          String where1 = (tableId!=null) ? "TableId=$tableId" : "1=1";
          String where2 = (startDate!=null && endDate!=null) ? "EventStartDate >= $startDate and EventStartDate <= ${endDate.add(const Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 99))}": "1=1";
          await DbHelper.queryAllRows('tbl_dk_event',where:"$where1 and $where2").then((v) async {
            events = v.map((e) => TblDkEvent.fromMap(e)).toList();
            events.sort((a, b) {
              int idComp = b.TableId.compareTo(a.TableId);
              if (idComp==0 && b.EventStartDate!=null){
                return -b.EventStartDate!.compareTo(a.EventStartDate!);
              }
              return idComp;
            });
          });
        } catch (e) {
          emit(PageLoadingFailedState(e.toString()));
          debugPrint("Print error LoadingReservationPage (${e.toString()})");
        }
      } else {
        //OnlineMode
          dbService = DbService(
              globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
          try {
            events = await dbService!.getEvents(tableId: tableId,
                startDate: startDate,
                endDate: endDate?.add(const Duration(
                    hours: 23, minutes: 59, seconds: 59, milliseconds: 99)));
          }
        on CantConnectToServerException catch (_) {
          emit(RRPCantConnectToServerState());
          return;
        } catch (e) {
          emit(PageLoadingFailedState(e.toString()));
          debugPrint("Print error Loading ReservationPage (${e.toString()})");
          return;
        }
          events.sort((a, b) {
            int idComp = b.TableId.compareTo(a.TableId);
            if (idComp==0 && b.EventStartDate!=null){
              return -b.EventStartDate!.compareTo(a.EventStartDate!);
            }
            return idComp;
          });
          //TODO Isolate gornushde eventleri lokalnyy baza atmaly.
          _saveEventsToDb(events);
      }
      if (tableId==null && startDate==null){
        globalProvider.setReservations = events;
      }
      debugPrint("Events length in RestoReservationsPageCubit: ${events.length}");
      emit(RestoReservationPageLoadedState(events));
    } catch (e) {
      debugPrint("Error on loadRestoReservationPageCubit: $e");
      emit(PageLoadingFailedState("Error on loadRestoReservationPageCubit: $e"));
    }
  }

  void addNewReservation(TblDkEvent reserveEvent, {int? loadMode}) async {
    emit(LoadingRestoReservationPageState());
    List<TblDkEvent> events = globalProvider.getReservations;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loadMode != null) {
      prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
    }
    dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
    bool? reserveState = false;
    if (dbConnectionMode == 2) {
      //offlineMode
      try {
        reserveState = (await DbHelper.insert('tbl_dk_event', reserveEvent))==1 ? true : false;
      } catch (e) {
        emit(CantReserveState("PrintError from AddNewReservation().online: ${e.toString()}"));
      }
    } else {
      //OnlineMode
      try {
        dbService = DbService(
            globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
        reserveState = await dbService?.addEvent(reserveEvent
        );
      } on CantConnectToServerException catch (_) {
        emit(RRPCantConnectToServerState());
      } on CantFindEventsTableException catch (_) {
        try {
          reserveState = await dbService?.addEvent(reserveEvent);
        } catch (e) {
          emit(CantReserveState("PrintError from AddNewReservation().online: ${e.toString()}"));
        }
      }
      catch (e) {
        debugPrint("PrintError from AddNewReservation().online: ${e.toString()}");
        emit(CantReserveState(e.toString()));
      }
    }
    if (reserveState ?? false) {
      events.add(reserveEvent);
      events.sort((a, b) => b.TableId.compareTo(a.TableId));
      globalProvider.setReservations=events;
      emit(ReservedState(reserveEvent));
    } else {
      emit(CantReserveState('Näbelli ýalňyşlyk'));
    }
    emit(RestoReservationPageLoadedState(events));
  }

  void modifyReservation(TblDkEvent reservedEvent, {bool? delete,int? loadMode}) async {
    emit(LoadingRestoReservationPageState());
    List<TblDkEvent> events = globalProvider.getReservations;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loadMode != null) {
      prefs.setInt(SharedPrefKeys.dbConnectionMode, loadMode);
    }
    dbConnectionMode = loadMode ?? (prefs.getInt(SharedPrefKeys.dbConnectionMode) ?? 1); //1=online, 2=offline
    bool? modifiedState = false;
    if (dbConnectionMode == 2) {
      //offlineMode
      try {
        if (delete == true) {
          modifiedState = (await DbHelper.delete('tbl_dk_event', where: 'EventId= ?',whereArgs: [reservedEvent.EventId.toString()]))==1 ? true : false;
        } else {
          modifiedState = (await DbHelper.update('tbl_dk_event','EventId',reservedEvent))==1 ? true : false;
        }
      } catch (e) {
        emit(CantModifyEventState("PrintError from modifyReservation().offline: ${e.toString()}"));
      }
    } else {
      //OnlineMode
      try {
        dbService = DbService(
            globalProvider.getHost, globalProvider.getPort, globalProvider.getDbName, globalProvider.getDbUName, globalProvider.getDbUPass);
        modifiedState = await dbService?.modifyEvent(reservedEvent,delete: delete);
      } on CantConnectToServerException catch (_) {
        emit(RRPCantConnectToServerState());
      }  catch (e) {
        debugPrint("PrintError from modifyReservation().online: ${e.toString()}");
        emit(CantModifyEventState(e.toString()));
      }
    }
    if (modifiedState ?? false) {
      if (delete ?? false){
        events.removeWhere((element) => element.EventGuid==reservedEvent.EventGuid);
      } else {
        events[events.indexWhere((element) => element.EventGuid==reservedEvent.EventGuid)]=reservedEvent;
      }
      globalProvider.setReservations=events;
      emit(EventModifiedState());
    }
    emit(RestoReservationPageLoadedState(events));
  }

  final isolateManager = IsolateManager();
  void _saveEventsToDb(List<TblDkEvent> events) async {
    try {
      final result = await isolateManager.addTask(() async {
        await DbHelper.init();
        final rowsInserted = await DbHelper.insertEventsList('tbl_dk_event', events);
        return rowsInserted > 0; // Return success status
      });

      if (result) {
        debugPrint('Inserting events to database completed successfully in RestoReservationsPageCubit');
      } else {
        debugPrint('Inserting events to database failed in RestoReservationsPageCubit');
      }
    } catch (e) {
      debugPrint('Print error _saveEventsToDb: ${e.toString()}');
      rethrow;
    }
  }
}
//endregion Cubit
