// ignore_for_file: file_names

import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/models/printerModel.dart';
import 'package:pos_app/models/tbl_dk_res_price_group.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region Events

class PrinterSettingsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPrinterSettings extends PrinterSettingsPageEvent {
  final GlobalVarsProvider providerModel;

  LoadPrinterSettings(this.providerModel);

  @override
  List<Object> get props => [providerModel];
}

class ScanBluetoothDevices extends PrinterSettingsPageEvent {}

class SavePrinterSettings extends PrinterSettingsPageEvent {
  final int printerConnectionMode;
  final BluetoothDevice? blDevice;
  final PrinterModel? printerModel;
  final int printCnt;

  SavePrinterSettings(this.printerConnectionMode,this.blDevice,this.printerModel,this.printCnt);

  @override
  List<Object> get props => [printerConnectionMode,blDevice ?? BluetoothDevice() ,printCnt];
}

//endregion Events

//region States
class PrinterSettingsPageState extends Equatable {
  @override
  List<Object> get props => [];
}
class PrinterSettingsInitialState extends PrinterSettingsPageState {}
class LoadingPrinterSettingsState extends PrinterSettingsPageState {}
class SavingPrinterSettingsState extends PrinterSettingsPageState {}
class PrinterSettingsSavedState extends PrinterSettingsPageState {}
class PrinterSettingsLoadedState extends PrinterSettingsPageState {
  final int printerConnectionMode; //1=Bluetooth, 2=IpAddress
  final BluetoothDevice? blDevice;
  final PrinterModel printerModel;
  final int printCnt;

  PrinterSettingsLoadedState(this.printerConnectionMode, this.blDevice, this.printCnt, this.printerModel);

  @override
  List<Object> get props => [printerConnectionMode, blDevice ?? BluetoothDevice(), printCnt, printerModel];
}
class ErrorOnPrinterSettingsPage extends PrinterSettingsPageState {
  final String errorText;

  ErrorOnPrinterSettingsPage(this.errorText);

  String get getErrorStr => errorText;

  @override
  List<Object> get props => [errorText];
}
//endregion States

class PrinterSettingsPageBloc extends Bloc<PrinterSettingsPageEvent, PrinterSettingsPageState> {
  List<TblDkResPriceGroup> priceGroups = [];
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  PrinterSettingsPageBloc() : super(PrinterSettingsInitialState()) {
    on<LoadPrinterSettings>(onLoadPrinterSettingsEvent);
    on<SavePrinterSettings>(onSavePrinterSettings);
  }

  @override
  void onTransition(Transition<PrinterSettingsPageEvent, PrinterSettingsPageState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  void onLoadPrinterSettingsEvent(LoadPrinterSettings event, Emitter<PrinterSettingsPageState> emit) async {
    emit(LoadingPrinterSettingsState());
    try {
      final sharedPref = await SharedPreferences.getInstance();
      int printerConnectionMode = sharedPref.getInt(SharedPrefKeys.DefaultPrintConMode) ?? 0;
      String? str = sharedPref.getString(SharedPrefKeys.LastConnectedBluetoothDevice);
      BluetoothDevice? blDevice = (str!=null && str.isNotEmpty) ? BluetoothDevice.fromJson(jsonDecode(str)) : null;
      PrinterModel printerModel = PrinterModel.fromJson(jsonDecode(sharedPref.getString(SharedPrefKeys.PrinterModel) ?? '{}'));
      int printCnt = sharedPref.getInt(SharedPrefKeys.PrintCount) ?? 1;
      emit(PrinterSettingsLoadedState(printerConnectionMode, blDevice, printCnt, printerModel));
    } catch (e) {
      debugPrint("PrintError onLoadPrinterSettingsEvent(): ${e.toString()}");
      emit(ErrorOnPrinterSettingsPage(e.toString()));
    }
  }

  void onSavePrinterSettings(SavePrinterSettings event, Emitter<PrinterSettingsPageState> emit) async {
    emit(SavingPrinterSettingsState());
    try {
      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setInt(SharedPrefKeys.DefaultPrintConMode, event.printerConnectionMode);
      Map<String,dynamic> map = event.blDevice?.toJson() ?? {};
      sharedPref.setString(SharedPrefKeys.LastConnectedBluetoothDevice,jsonEncode(map));
      sharedPref.setString(SharedPrefKeys.PrinterModel,jsonEncode(event.printerModel?.toJson() ?? "{}"));
      sharedPref.setInt(SharedPrefKeys.PrintCount,event.printCnt);
      emit(PrinterSettingsSavedState());
    } catch (e) {
      debugPrint("PrintError onSavePrinterSettings(): ${e.toString()}");
      emit(ErrorOnPrinterSettingsPage(e.toString()));
    }
  }
}
