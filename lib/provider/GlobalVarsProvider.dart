// ignore_for_file: file_names

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/tbl_dk_user.dart';
import 'package:pos_app/models/v_dk_resource.dart';

class GlobalVarsProvider with ChangeNotifier{

  List<BluetoothDevice> _bluetoothDevices=[];
  List<BluetoothDevice> get getBluetoothDevices=>_bluetoothDevices;
  set setBluetoothDevices(List<BluetoothDevice> bluetoothDevices){
    _bluetoothDevices = bluetoothDevices;
    notifyListeners();
  }

  TblDkUser? _user;
  TblDkUser? get getUser=>_user;
  set setUser(TblDkUser user){
    _user = user;
    notifyListeners();
  }

  List<VDkResource> _resources=[];
  List<VDkResource> get getResources=>_resources;
  set setResources(List<VDkResource> resources){
    _resources = resources;
    notifyListeners();
  }

  List<TblDkCartItem> _cartItems=[];
  List<TblDkCartItem> get  getCartItems=>_cartItems;
  set setCartItems(List<TblDkCartItem> cartItems){
    _cartItems=cartItems;
    notifyListeners();
  }

  updateCartItems(int index, TblDkCartItem cartItem){
    _cartItems[index]=cartItem;
    notifyListeners();
  }

  List<TblDkTable> tables=[];
  List<TblDkTable> get  getTables=>tables;
  set setTables(List<TblDkTable> tables1){
    tables=tables1;
    notifyListeners();
  }
  updateTables(int index, TblDkTable table){
    tables[index]=table;
    notifyListeners();
  }

  List<TblDkResCategory> _resCategories=[];
  List<TblDkResCategory> get getResCategories=>_resCategories;
  set setResCategories(List<TblDkResCategory> resCategories){
    _resCategories = resCategories;
    notifyListeners();
  }

  List<TblDkResCategory> _tableCategories=[];
  List<TblDkResCategory> get gettableCategories=>_tableCategories;
  set setTableCategories(List<TblDkResCategory> tableCategories){
    _tableCategories = tableCategories;
    notifyListeners();
  }

  List<TblDkEvent> _reservations=[];
  List<TblDkEvent> get getReservations=>_reservations;
  set setReservations(List<TblDkEvent> reservations){
    _reservations = reservations;
    notifyListeners();
  }

  String _host="";
  String get getHost=>_host;
  set setHost(String host){
    _host = host;
    notifyListeners();
  }

  int _port=1433;
  int get getPort=>_port;
  set setPort(int port){
    _port = port;
    notifyListeners();
  }

  String _dbName="";
  String get getDbName=>_dbName;
  set setDbName(String dbName){
    _dbName = dbName;
    notifyListeners();
  }

  String _dbUName="";
  String get getDbUName=>_dbUName;
  set setDbUName(String dbUName){
    _dbUName = dbUName;
    notifyListeners();
  }

  String _dbUPass="";
  String get getDbUPass=>_dbUPass;
  set setDbUPass(String dbUPass){
    _dbUPass = dbUPass;
    notifyListeners();
  }
}