// ignore_for_file: file_names

import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/helpers/SharedPrefKeys.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region Events

class BluetoothPrintersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ScanBluetoothDevicesEvent extends BluetoothPrintersEvent {
  final GlobalVarsProvider providerModel;

  ScanBluetoothDevicesEvent(this.providerModel);

  @override
  List<Object> get props => [providerModel];
}

class ConnectToBlDeviceEvent extends BluetoothPrintersEvent {
  final BluetoothDevice? blDevice;
  final List<LineText>? design;
  final int printCnt;
  final bool isTest;

  ConnectToBlDeviceEvent({this.blDevice, this.design, this.printCnt = 0, this.isTest = false});

  @override
  List<Object> get props => [blDevice ?? BluetoothDevice(), printCnt, isTest];
}

class BlPrintDocumentEvent extends BluetoothPrintersEvent {
  final bool isTest;
  final BluetoothDevice blDevice;
  final List<LineText>? design;
  final int printCnt;

  BlPrintDocumentEvent(this.blDevice, {this.design, this.printCnt = 1, this.isTest = false});

  @override
  List<Object> get props => [blDevice, isTest];
}

class DisconnectFromBlDeviceEvent extends BluetoothPrintersEvent {}

//endregion Events

//region States
class BluetoothPrinterState extends Equatable {
  @override
  List<Object> get props => [];
}

class BluetoothPrintersInitialState extends BluetoothPrinterState {}

class ScanningBlDevicesState extends BluetoothPrinterState {}

class BlDevicesScannedState extends BluetoothPrinterState {
  final List<BluetoothDevice> devices;

  BlDevicesScannedState(this.devices);

  @override
  List<Object> get props => [devices];
}

class ConnectingToBlDeviceState extends BluetoothPrinterState {
  final BluetoothDevice? device;

  ConnectingToBlDeviceState({this.device});

  @override
  List<Object> get props => [device ?? BluetoothDevice()];
}

class ConnectedToBlDeviceState extends BluetoothPrinterState {
  final BluetoothDevice device;
  final int? printCnt;
  final bool isTest;
  final List<LineText>? design;

  ConnectedToBlDeviceState(this.device, {this.design, this.printCnt, this.isTest = false});

  @override
  List<Object> get props => [device, printCnt ?? 0, isTest];
}

class DisconnectingFromBlDeviceState extends BluetoothPrinterState {}

class DisconnectedFromBlDeviceState extends BluetoothPrinterState {
  final bool? isManual;

  DisconnectedFromBlDeviceState({this.isManual});
}

class PrintingDocumentState extends BluetoothPrinterState {}

class DocumentPrintedState extends BluetoothPrinterState {
  final BluetoothDevice device;

  DocumentPrintedState(this.device);

  @override
  List<Object> get props => [device];
}

class ErrorOnBluetoothPrintersState extends BluetoothPrinterState {
  final String errorText;

  ErrorOnBluetoothPrintersState(this.errorText);

  @override
  List<Object> get props => [errorText];
}
//endregion States

class BluetoothPrinterBloc extends Bloc<BluetoothPrintersEvent, BluetoothPrinterState> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  BluetoothDevice? connectedDevice;
  bool waitBeforePrint = false;

  BluetoothPrinterBloc() : super(BluetoothPrintersInitialState()) {
    on<ScanBluetoothDevicesEvent>(onScanBluetoothDevices);
    on<ConnectToBlDeviceEvent>(onConnectToBlDevice);
    on<DisconnectFromBlDeviceEvent>(onDisconnectFromBlDevice);
    on<BlPrintDocumentEvent>(onBlPrintDocumentEvent);
  }

  @override
  void onTransition(Transition<BluetoothPrintersEvent, BluetoothPrinterState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  void onScanBluetoothDevices(ScanBluetoothDevicesEvent event, Emitter<BluetoothPrinterState> emit) async {
    emit(ScanningBlDevicesState());
    try {
      List<BluetoothDevice> blDevices = await bluetoothPrint.startScan(timeout: const Duration(seconds: 5));
      event.providerModel.setBluetoothDevices = blDevices;
      emit(BlDevicesScannedState(blDevices));
    } catch (e) {
      debugPrint("PrintError onScanBluetoothDevices(): ${e.toString()}");
      emit(ErrorOnBluetoothPrintersState(e.toString()));
    }
  }

  void onConnectToBlDevice(ConnectToBlDeviceEvent event, Emitter<BluetoothPrinterState> emit) async {
    emit(ConnectingToBlDeviceState(device: event.blDevice));
    try {
      if (!(await bluetoothPrint.isConnected ?? false) || connectedDevice != event.blDevice) {
        waitBeforePrint = true;
        if (event.blDevice != null) {
          connectedDevice = event.blDevice;
          await bluetoothPrint.connect(event.blDevice!);
          emit(ConnectedToBlDeviceState(event.blDevice!, design: event.design, printCnt: event.printCnt, isTest: event.isTest));
        } else {
          final sharedPref = await SharedPreferences.getInstance();
          String lastConnected = sharedPref.getString(SharedPrefKeys.LastConnectedBluetoothDevice) ?? '';
          BluetoothDevice blDevice = (lastConnected.isNotEmpty)
              ? BluetoothDevice.fromJson(jsonDecode(sharedPref.getString(SharedPrefKeys.LastConnectedBluetoothDevice)!))
              : BluetoothDevice();
          if (blDevice.address != null && blDevice.address!.isNotEmpty) {
            connectedDevice = blDevice;
            await bluetoothPrint.connect(blDevice);
            emit(ConnectedToBlDeviceState(blDevice, design: event.design, printCnt: event.printCnt, isTest: event.isTest));
          } else {
            emit(ErrorOnBluetoothPrintersState("Set printer settings before print"));
          }
        }
      } else {
        final sharedPref0 = await SharedPreferences.getInstance();
        String lastConnected = sharedPref0.getString(SharedPrefKeys.LastConnectedBluetoothDevice) ?? '';
        BluetoothDevice blDevice = (lastConnected.isNotEmpty)
            ? BluetoothDevice.fromJson(jsonDecode(sharedPref0.getString(SharedPrefKeys.LastConnectedBluetoothDevice)!))
            : BluetoothDevice();
        if (connectedDevice != null) {
          emit(ConnectedToBlDeviceState(connectedDevice!, design: event.design, printCnt: event.printCnt, isTest: event.isTest));
        } else if (blDevice.address != null && blDevice.address!.isNotEmpty) {
          await bluetoothPrint.connect(blDevice);
          emit(ConnectedToBlDeviceState(blDevice, design: event.design, printCnt: event.printCnt, isTest: event.isTest));
        } else {
          emit(ErrorOnBluetoothPrintersState("Set printer settings before print"));
        }
      }
    } catch (e) {
      debugPrint("PrintError onConnectToBlDevice(): ${e.toString()}");
      emit(DisconnectedFromBlDeviceState());
      emit(ErrorOnBluetoothPrintersState(e.toString()));
    }
  }

  void onDisconnectFromBlDevice(DisconnectFromBlDeviceEvent event, Emitter<BluetoothPrinterState> emit) async {
    emit(DisconnectingFromBlDeviceState());
    try {
      final sharedPref = await SharedPreferences.getInstance();
      await bluetoothPrint.disconnect();
      sharedPref.setString(SharedPrefKeys.LastConnectedBluetoothDevice, '');
      emit(DisconnectedFromBlDeviceState(isManual: true));
    } catch (e) {
      debugPrint("PrintError onDisconnectFromBlDevice(): ${e.toString()}");
      emit(ErrorOnBluetoothPrintersState(e.toString()));
    }
  }

  void onBlPrintDocumentEvent(BlPrintDocumentEvent event, Emitter<BluetoothPrinterState> emit) async {
    emit(PrintingDocumentState());
    try {
      Map<String, dynamic> config = {};
      List<LineText> list = [];
      list.add(LineText(type: LineText.TYPE_TEXT, content: 'TEST PRINT', weight: 20, size: 40, width: 15, align: LineText.ALIGN_CENTER, linefeed: 1));
      list.add(LineText(type: LineText.TYPE_TEXT, content: '', weight: 20, size: 40, width: 5, align: LineText.ALIGN_CENTER, linefeed: 1));
      list.add(LineText(type: LineText.TYPE_TEXT, content: '', weight: 20, size: 40, width: 5, align: LineText.ALIGN_CENTER, linefeed: 1));
      list.add(LineText(type: LineText.TYPE_TEXT, content: '', weight: 20, size: 40, width: 5, align: LineText.ALIGN_CENTER, linefeed: 1));
      if (waitBeforePrint) {
        waitBeforePrint = false;
        await Future.delayed(const Duration(seconds: 5));
      }
      if (await bluetoothPrint.isConnected ?? false) {
        for (int i = 0; i < event.printCnt; i++) {
          if (event.isTest) {
            await bluetoothPrint.printReceipt(config, list);
          } else {
            await bluetoothPrint.printReceipt(config, event.design ?? list);
          }
        }
        emit(DocumentPrintedState(event.blDevice));
      } else {
        emit(ConnectingToBlDeviceState(device: event.blDevice));
        bluetoothPrint.connect(event.blDevice);
        bluetoothPrint.state.listen((bpEvent) async {
          switch (bpEvent) {
            case BluetoothPrint.CONNECTED:
              for (int i = 0; i <= event.printCnt; i++) {
                if (event.isTest) {
                  await bluetoothPrint.printReceipt(config, list);
                } else {
                  await bluetoothPrint.printReceipt(config, event.design ?? list);
                }
              }
              emit(DocumentPrintedState(event.blDevice));
              break;
            default:
              break;
          }
        });
      }
    } catch (e) {
      debugPrint("PrintError onDisconnectFromBlDevice(): ${e.toString()}");
      emit(ErrorOnBluetoothPrintersState(e.toString()));
    }
  }
}
