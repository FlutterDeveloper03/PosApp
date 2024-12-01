// ignore_for_file: file_names,depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos_app/models/model.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/models/tbl_dk_image.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_res_price.dart';
import 'package:pos_app/models/tbl_dk_res_price_group.dart';
import 'package:pos_app/models/tbl_dk_resource.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class DbHelper {
  static const _dbName = "dbSapPos.db";

  static get _dbVersion => 1;
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    debugPrint('Print Db Path is:$path');
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE tbl_dk_company(
            CId int,
            CGuid String NULL,
            CName String NULL,
            CDesc String NULL,
            CFullName String NULL,
            Phone1 String NULL,
            Phone2 String NULL,
            Phone3 String NULL,
            Phone4 String NULL,
            WebAddress String NULL,
            CEmail String NULL,
            SyncDateTime datetime NULL
          )
    '''); //Company
    await db.execute('''
          CREATE TABLE tbl_dk_cart_item(
            CIId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ResId int NULL,
            ResName String NULL,
            ResNameTm String NULL,
            ResNameRu String NULL,
            ResNameEn String NULL,
            ResPriceGroupId int NULL,
            ResPriceValue REAL NULL,
            ItemCount INT,
            ItemPriceTotal REAL,
            SyncDateTime datetime NULL,
            RpAccId int NULL,
            TableId int NULL,
            ImageFilePath String NULL,
            matAttributes TEXT NULL
          )
          '''); //CartItem
    await db.execute('''
          CREATE TABLE tbl_dk_res_category(
            ResCatId INTEGER NOT NULL,
            CatTypeId int NULL,
            CatTypeGuid String NULL,
            ResOwnerCatId int NULL,
            ResCatVisibleIndex int NULL,
            IsMain int NULL,
            ResCatName String NULL,
            ResCatNameTm String NULL,
            ResCatNameRu String NULL,
            ResCatNameEn String NULL,
            ResCatDesc String NULL,
            ResCatIconName String NULL,
            ResCatIconFilePath String NULL,
            SyncDateTime datetime NULL
            )
          '''); //ResCategory
    await db.execute('''
          CREATE TABLE tbl_dk_resources(
            ResId INTEGER NOT NULL,
            ResGuid String NULL,
            ResCatId int NULL,
            ResName String NULL,
            ResDesc String NULL,
            ResFullDesc String NULL,
            ResNameTm String NULL,
            ResNameRu String NULL,
            ResNameEn String NULL,
            SyncDateTime datetime NULL
          )
          '''); //Resource
    await db.execute('''
          CREATE TABLE tbl_dk_res_price(
            ResPriceId INTEGER NOT NULL,
            ResPriceGroupId int NULL,
            ResUnitId int NULL,
            CurrencyId int NULL,
            ResId int NULL,
            ResPriceRegNo String NULL,
            ResPriceValue float NULL,
            PriceStartDate datetime NULL,
            PriceEndDate datetime NULL,
            SyncDateTime datetime NULL
          )
    '''); //ResPrice
    await db.execute('''
          CREATE TABLE tbl_dk_res_price_group(
            ResPriceGroupId INTEGER NOT NULL,
            ResPriceGroupName String NULL,
            ResPriceGroupDesc String NULL,
            ResPriceGroupAMEnabled int NULL,
            ResPriceGroupAMPerc int NULL,
            RoundingType int NULL,
            FromResPriceGroupId int NULL,
            ToResPriceGroupId int NULL,
            FromResPriceTypeId int NULL,
            ToResPriceTypeId int NULL,
            SyncDateTime datetime NULL
          )
    '''); //ResPriceGroup
    await db.execute('''
          CREATE TABLE tbl_dk_image(
            ImgId INTEGER NOT NULL,
            ImgGuid String NULL,
            EventId int NULL,
            ResCatId int NULL,
            CId int NULL,
            ResId int NULL,
            FileName String NULL,
            FileHash String NULL,
            FilePath String NULL,
            Image Uint8List NULL,
            SyncDateTime datetime NULL
            )
          '''); //Image
    await db.execute('''
          CREATE TABLE tbl_dk_inv_line(
             InvLineId int NOT NULL, 
             InvLineGuid String NULL, 
             InvId int NULL, 
             WhId int NULL, 
             ResUnitId int NULL, 
             CurrencyId int NULL, 
             ResId int NULL, 
             LastVendorId int NULL, 
             InvLineRegNo String NULL, 
             InvLineDesc String NULL, 
             InvLineAmount int NULL, 
             InvLinePrice REAL NULL, 
             InvLineTotal REAL NULL, 
             InvLineExpenseAmount REAL NULL, 
             InvLineTaxAmount REAL NULL,
             InvLineDiscAmount REAL NULL, 
             InvLineFTotal REAL NULL, 
             ExcRateValue REAL NULL, 
             InvLineDate int NULL, 
             ResAttributesString String NULL,            
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL, 
             GCRecord int NULL
            )
          '''); //InvLine
    await db.execute('''
          CREATE TABLE tbl_dk_invoice(
             InvId int NULL, 
             InvTypeId int NULL, 
             PtId int NULL, 
             PmId int NULL, 
             InvStatId int NULL, 
             CurrencyId int NULL, 
             RpAccId int NULL, 
             CId int NULL, 
             DivId int NULL, 
             WhId int NULL, 
             WpId int NULL, 
             EmpId int NULL, 
             UId int NULL, 
             InvGuid String NULL, 
             InvRegNo String NULL, 
             InvDesc String NULL, 
             InvDate int NULL, 
             InvTotal REAL NULL, 
             InvExpenseAmount REAL NULL, 
             InvTaxAmount REAL NULL, 
             InvDiscountAmount REAL NULL, 
             InvFTotal REAL NULL,
             InvFTotalInWrite String NULL, 
             InvModifyCount int NULL, 
             InvPrintCount int NULL, 
             InvCreditDays int NULL, 
             InvCreditDesc String NULL, 
             InvLatitude REAL NULL, 
             InvLongitude REAL NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL 
            )
          '''); //Invoice
    await db.execute('''
          CREATE TABLE tbl_dk_inv_type(
             InvTypeId int NULL, 
             InvTypeGuid String NULL, 
             InvTypeName_tkTM String NULL, 
             InvTypeDesc_tkTM String NULL, 
             InvTypeName_ruRU String NULL, 
             InvTypeDesc_ruRU String NULL, 
             InvTypeName_enUS String NULL, 
             InvTypeDesc_enUS String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //InvType
    await db.execute('''
          CREATE TABLE tbl_dk_currency(
             CurrencyId int NULL, 
             CurrencyGuid String NULL, 
             CurrencyName_tkTM String NULL, 
             CurrencyDesc_tkTM String NULL, 
             CurrencyName_ruRU String NULL, 
             CurrencyDesc_ruRU String NULL, 
             CurrencyName_enUS String NULL, 
             CurrencyDesc_enUS String NULL, 
             CurrencyCode String NULL, 
             CurrencyNumCode String NULL, 
             CurrencySymbol String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //Currency
    await db.execute('''
          CREATE TABLE tbl_dk_unit(
             UnitId int NULL, 
             UnitGuid String NULL, 
             UnitName_tkTM String NULL, 
             UnitDesc_tkTM String NULL, 
             UnitName_ruRU String NULL, 
             UnitDesc_ruRU String NULL, 
             UnitName_enUS String NULL, 
             UnitDesc_enUS String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //Unit
    await db.execute('''
          CREATE TABLE tbl_dk_res_unit(
             ResUnitId int NULL, 
             ResUnitGuid String NULL, 
             ResId int NULL, 
             UnitId int NULL,
             ResUnitName String NULL, 
             ResUnitDesc String NULL, 
             ResUnitConvAmount REAL NULL, 
             ResUnitConvTypeId int NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //ResUnit
    await db.execute('''
          CREATE TABLE tbl_dk_exc_rate(
             ExcRateId int NULL, 
             ExcRateGuid String NULL, 
             CurrencyId int NULL, 
             ExcRateDate int NULL, 
             ExcRateInValue REAL NULL, 
             ExcRateOutValue REAL NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //ExchangeRate
    await db.execute('''
          CREATE TABLE tbl_dk_sale_card(
             SaleCardId int NULL, 
             SaleCardGuid String NULL, 
             CId int NULL, 
             DivId int NULL, 
             WpId int NULL, 
             RpAccId int NULL, 
             CurrencyId int NULL, 
             SaleAgrId int NULL, 
             ResPriceGroupId int NULL,  
             SaleCardRegNo String NULL, 
             SaleCardName String NULL, 
             SaleCardDesc String NULL, 
             SaleCardStartDate int NULL, 
             SaleCardEndDate int NULL, 
             SaleCardMinSaleAmount REAL NULL, 
             SaleCardMaxSaleAmount REAL NULL, 
             SaleCardMinSalePrice REAL NULL, 
             SaleCardMaxSalePrice REAL NULL, 
             SaleCardMaxManualDiscPerc REAL NULL, 
             SaleCardIsPayable int NULL, 
             SaleCardCustName String NULL, 
             SaleCardCustBirthDate int NULL, 
             SaleCardCustTel String NULL, 
             SaleCardCustEmail String NULL, 
             SaleCardCustAddress String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //SaleCard
    await db.execute('''
          CREATE TABLE tbl_dk_sale_agreement(
             SaleAgrId int NULL, 
             SaleAgrGuid String NULL, 
             CurrencyId int NULL, 
             SaleAgrName String NULL, 
             SaleAgrDesc String NULL, 
             SaleAgrMinOrderPrice REAL NULL, 
             SaleAgrDiscPerc REAL NULL, 
             SaleAgrMaxDiscPerc REAL NULL, 
             SaleAgrTaxPerc REAL NULL, 
             SaleAgrTaxAmount REAL NULL, 
             SaleAgrUseOwnPriceList int NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL,
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //SaleAgreement
    await db.execute('''
          CREATE TABLE tbl_dk_table(
             TableId int NULL, 
             TableGuid String NULL, 
             SaleCardId int NULL, 
             CId int NULL, 
             DivId int NULL, 
             WpId int NULL, 
             TableStatusId int NULL, 
             TableTypeId int NULL, 
             CatId int NULL, 
             EmpId int NULL,
             TableName String NULL, 
             TableDesc String NULL, 
             TablePersonCount int NULL,
             MergedTablesCount int NULL, 
             TableGroupGuid String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //Table
    await db.execute('''
          CREATE TABLE tbl_dk_table_status(
             TableStatusId int NULL, 
             TableStatusGuid String NULL, 
             TableStatusName_tkTM String NULL, 
             TableStatusDesc_tkTM String NULL, 
             TableStatusName_ruRU String NULL, 
             TableStatusDesc_ruRU String NULL, 
             TableStatusName_enUS String NULL, 
             TableStatusDesc_enUS String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //TableStatus
    await db.execute('''
          CREATE TABLE tbl_dk_table_type(
             TableTypeId int NULL, 
             TableTypeGuid String NULL, 
             TableTypeName_tkTM String NULL, 
             TableTypeDesc_tkTM String NULL, 
             TableTypeName_ruRU String NULL, 
             TableTypeDesc_ruRU String NULL, 
             TableTypeName_enUS String NULL, 
             TableTypeDesc_enUS String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //TableType
    await db.execute('''
          CREATE TABLE tbl_dk_event(
             EventId int NULL, 
             EventGuid String NULL, 
             EventTypeId int NULL, 
             ResCatId int NULL, 
             ColorId int NULL, 
             LocId int NULL, 
             TableId int NULL, 
             TableGroupGuid String NULL,
             SaleCardId int NULL, 
             RpAccId int NULL, 
             CId int NULL, 
             DivId int NULL,
             WpId int NULL, 
             EmpId int NULL, 
             OwnerEventId int NULL, 
             EventName String NULL, 
             EventDesc String NULL, 
             EventTitle String NULL, 
             EventStartDate int NULL, 
             EventEndDate int NULL, 
             WholeDay int NULL, 
             NumberOfGuests int NULL, 
             TagsInfo String NULL, 
             RecurrenceInfo String NULL, 
             ReminderInfo String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //Event
    await db.execute('''
          CREATE TABLE tbl_dk_event_type(
             EventTypeId int NULL, 
             EventTypeGuid String NULL, 
             EventTypeName_tkTM String NULL, 
             EventTypeDesc_tkTM String NULL, 
             EventTypeName_ruRU String NULL, 
             EventTypeDesc_ruRU String NULL, 
             EventTypeName_enUS String NULL, 
             EventTypeDesc_enUS String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //EventType
    await db.execute('''
          CREATE TABLE tbl_dk_color(
             ColorId int Null, 
             ColorGuid String NULL, 
             ColorName String NULL, 
             ColorDesc String NULL, 
             ColorCode String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //Color
    await db.execute('''
          CREATE TABLE tbl_dk_res_attribute(
             ResAttrId int NULL, 
             ResAttrGuid String NULL, 
             ResId int NULL, 
             ProdId int NULL, 
             ResAttrResId int NULL, 
             ResAttrName String NULL, 
             ResAttrDesc String NULL, 
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //ResAttributes
    await db.execute('''
          CREATE TABLE tbl_dk_order_inv(
             OInvId int NULL, 
             OInvGuid String NULL, 
             InvTypeId int NULL, 
             InvStatId int NULL, 
             PtId int NULL, 
             PmId int NULL, 
             CurrencyId int NULL, 
             RpAccId int NULL, 
             CId int NULL, 
             DivId int NULL, 
             WhId int NULL, 
             WpId int NULL, 
             EmpId int NULL, 
             UId int NULL, 
             PaymStatusId int NULL, 
             PaymCode String NULL, 
             PaymDesc String NULL, 
             OInvRegNo String NULL, 
             OInvDesc String NULL, 
             OInvDate int NULL, 
             OInvTotal REAL NULL,
             OInvExpenseAmount REAL NULL, 
             OInvTaxAmount REAL NULL, 
             OInvDiscountAmount REAL NULL, 
             OInvFTotal REAL NULL, 
             OInvFTotalInWrite String NULL, 
             OInvPaymAmount REAL NULL, 
             OInvModifyCount int NULL, 
             OInvPrintCount int NULL, 
             OInvCreditDays int NULL, 
             OInvCreditDesc String NULL, 
             OInvLatitude REAL NULL, 
             OInvLongitude REAL NULL,
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //OrderInv
    await db.execute('''
          CREATE TABLE tbl_dk_order_inv_line(
             OInvLineId int NULL, 
             OInvLineGuid String NULL, 
             OInvId int NULL, 
             WhId int NULL, 
             ResUnitId int NULL, 
             CurrencyId int NULL, 
             ResId int NULL, 
             LastVendorId int NULL,
             OInvLineRegNo String NULL, 
             OInvLineDesc String NULL, 
             OInvLineAmount REAL NULL, 
             OInvLinePrice REAL NULL, 
             OInvLineTotal REAL NULL, 
             OInvLineExpenseAmount REAL NULL, 
             OInvLineTaxAmount REAL NULL, 
             OInvLineDiscAmount REAL NULL, 
             OInvLineFTotal REAL NULL, 
             ExcRateValue REAL NULL, 
             OInvLineDate int NULL,
             AddInf1 String NULL, 
             AddInf2 String NULL, 
             AddInf3 String NULL, 
             AddInf4 String NULL, 
             AddInf5 String NULL, 
             AddInf6 String NULL, 
             AddInf7 String NULL, 
             AddInf8 String NULL, 
             AddInf9 String NULL, 
             AddInf10 String NULL,
             CreatedDate int NULL, 
             ModifiedDate int NULL, 
             CreatedUId int NULL, 
             ModifiedUId int NULL, 
             SyncDateTime int NULL
            )
          '''); //OrderInvLine

    debugPrint('Print Database is created');
  }

//region //////////////////////////// Basic functions //////////////////////////
  static Future<int?> rowCount(String table) async => Sqflite.firstIntValue(await _db!.rawQuery('Select Count(*) FROM $table'));

  static Future<List<Map<String, dynamic>>> queryAllRows(String table, {String where = ''}) async =>
      (where.isNotEmpty) ? await _db!.query(table, where: where) : await _db!.query(table);

  static Future<Map<String, dynamic>> queryFirstRow(String table, {String where = ''}) async {
    if (where.isNotEmpty) {
      List<Map<String, dynamic>> result0 = await _db!.query(table, where: where, limit: 1);
      if (result0.isNotEmpty) return result0[0];
      return {};
    }
    List<Map<String, dynamic>> result = await _db!.query(table, limit: 1);
    if (result.isNotEmpty) return result[0];
    return {};
  }

  static Future<int> insert(String table, Model model) async => await _db!.insert(table, model.toMap());

  static Future<int> update(String table, String columnId, Model model) async =>
      await _db!.update(table, model.toMap(), where: '$columnId = ?', whereArgs: [model.toMap()[columnId]]);

  static Future<int> delete(String table, {String where = '', List<String> whereArgs=const[]}) async => await _db!.delete(table, where: where, whereArgs: whereArgs);

  static Future<int> insertUpdateRowById(String table, Model model, String idColumnName, int id) async {
    try {
      int? count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $idColumnName=$id'));
      if ((count ?? 0) > 0) {
        return _db!.update(table, model.toMap(), where: '$idColumnName=$id');
      }
      return await _db!.insert(table, model.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> insertUpdateRowByGuid(String table, Model model, String guidColumnName, String uGuid) async {
    try {
      int count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $guidColumnName=\'$uGuid\'')) ?? 0;
      if (count > 0) {
        return _db!.update(table, model.toMap(), where: '$guidColumnName=\'$uGuid\'');
      } else {
        return await _db!.insert(table, model.toMap());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> initTable(String tableName) async => await _db!.delete(tableName);

  static Future<int> deleteRowByGuid(String tableName, String guidColumnName, String guid) async =>
      await _db!.delete(tableName, where: '$guidColumnName=\'$guid\'');

  static Future<List<Map<String, dynamic>>> getRowByGuid(String tableName, String guidColumnName, String guid) async =>
      await _db!.query(tableName, where: '$guidColumnName=\'$guid\'');

//endregion //////////////////// Basic functions /////////////////////////

//region ///////////////////////////// Tables ////////////////////////////////
  static Future<List<Map<String, dynamic>>> mergeTables(List<String> tableGuids, TblDkTable newMergedTable) async {
    return await _db!.rawQuery('''
                       update tbl_dk_table
                       set TableGroupGuid='${newMergedTable.TableGroupGuid}'
                       where TableGuid in (${tableGuids.join(',')})
                       
                       GO
                       
                       insert into tbl_dk_table
                          (TableId
                          ,TableGuid
                          ,SaleCardId
                          ,CId
                          ,DivId
                          ,WpId
                          ,TableStatusId
                          ,TableTypeId
                          ,CatId
                          ,TableName
                          ,TableDesc
                          ,TablePersonCount
                          ,TableGroupGuid
                          ,AddInf1
                          ,AddInf2
                          ,AddInf3
                          ,AddInf4
                          ,AddInf5
                          ,AddInf6
                          ,AddInf7
                          ,AddInf8
                          ,AddInf9
                          ,AddInf10
                          ,CreatedDate
                          ,ModifiedDate
                          ,CreatedUId
                          ,ModifiedUId
                          ,SyncDateTime)
                         VALUES
                           ${newMergedTable.TableId}
                           ,${newMergedTable.TableGuid}
                           ,${newMergedTable.TableId}
                           ,${newMergedTable.CId}
                           ,${newMergedTable.DivId}
                           ,${newMergedTable.WpId}
                           ,${newMergedTable.TableStatusId}
                           ,${newMergedTable.TableTypeId}
                           ,${newMergedTable.CatId}
                           ,${newMergedTable.TableName}
                           ,${newMergedTable.TableDesc}
                           ,${newMergedTable.TablePersonCount}
                           ,${newMergedTable.TableGroupGuid}
                           ,${newMergedTable.AddInf1}
                           ,${newMergedTable.AddInf2}
                           ,${newMergedTable.AddInf3}
                           ,${newMergedTable.AddInf4}
                           ,${newMergedTable.AddInf5}
                           ,${newMergedTable.AddInf6}
                           ,${newMergedTable.AddInf7}
                           ,${newMergedTable.AddInf8}
                           ,${newMergedTable.AddInf9}
                           ,${newMergedTable.AddInf10}
                           ,${newMergedTable.CreatedDate}
                           ,${newMergedTable.ModifiedDate}
                           ,${newMergedTable.CreatedUId}
                           ,${newMergedTable.ModifiedUId}
                           ,${newMergedTable.SyncDateTime}
                           )
    ''');
  }

  static Future<List<Map<String, dynamic>>> divideTables(List<String> tableGroupGuids) async {
    String guidsStr = tableGroupGuids.map((e) => "'$e'").join(",");
    return await _db!.rawQuery('''
                       update tbl_dk_table
                       set TableGroupGuid=''
                       where TableGroupGuid in ($guidsStr) and TableTypeId!=3
                       
                       GO
                        
                       delete from tbl_dk_table
                       where TableTypeId=3 and TableGroupGuid in ($guidsStr)
    ''');
  }

//endregion ////////////////////////// Tables ////////////////////////////////

//region ///////////////////////////// Cart Items //////////////////////////////
  static Future<int> insertCartItem(String table, Model model, int resId, int tableId) async {
    int count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM tbl_dk_cart_item WHERE ResId=$resId and TableId=$tableId')) ?? 0;
    if (count > 0) {
      if ((model as TblDkCartItem).ItemCount == 0) {
        return _db!.delete(table, where: 'ResId=? and TableId=?', whereArgs: [resId, tableId]);
      }
      return _db!.update(table, model.toMap(), where: 'ResId= ? and TableId=?', whereArgs: [resId, tableId]);
    }
    return await _db!.insert(table, model.toMap());
  }

  static Future<int> initCartItems(int rpAccId) async => await _db!.delete('tbl_dk_cart_item', where: 'RpAccId=?', whereArgs: [rpAccId]);

  static Future<int> deleteCartItem(int resId, int tableId) async =>
      await _db!.delete('tbl_dk_cart_item', where: 'ResId = ? and TableId=?', whereArgs: [resId, tableId]);

  static Future<List<Map<String, dynamic>>> getCartItemsByRpAccId(int rpAccId) async =>
      await _db!.query('tbl_dk_cart_item', where: 'RpAccId=?', whereArgs: [rpAccId]);

//endregion Cart Items

//region /////////////////////////ResCategories/////////////////////////////////

  static Future<int> insertCategoryList(String table, List<TblDkResCategory> categoryList) async {
    return await _db!.transaction((txn) async {
      Batch batch = txn.batch();
      try {
        await txn.delete(table);
        for (TblDkResCategory model in categoryList) {
          batch.insert(table, model.toMap());
        }

        await batch.commit(noResult: true);

        return categoryList.length;
      } catch (e) {
        debugPrint("PrintError on insertCategoryList: $e");
        return 0;
      }
    });
  }

//endregion ResCategories

//region ///////////////////////Resources//////////////////////////////


  // static Future<int> insertResourceList(String table, List<TblDkResource> resourceList) async {
  //   Batch batch = _db!.batch();
  //   await _db!.delete(table);
  //   batch.delete(table);
  //   for (TblDkResource model in resourceList) {
  //     try {
  //       batch.insert(table, model.toMap());
  //     } catch (e) {
  //       throw Exception(e.toString());
  //     }
  //   }
  //   try {
  //     await batch.commit();
  //     return resourceList.length;
  //   } catch (e) {
  //     debugPrint("PrintError on insertResourceList: $e");
  //     return 0;
  //   }
  // }

  static Future<int> insertResourceList(String table, List<TblDkResource> resourceList) async {
    return await _db!.transaction((txn) async {
      Batch batch = txn.batch();
      try {
        await txn.delete(table);

        for (TblDkResource model in resourceList) {
          batch.insert(table, model.toMap());
        }

        await batch.commit(noResult: true);

        return resourceList.length;
      } catch (e) {
        debugPrint("PrintError on insertResourceList: $e");
        return 0;
      }
    });
  }

  static Future<List<VDkResource>> queryVResource(int resPriceGroupId) async {
    try {
      List<Map<String, dynamic>> result = await _db!.rawQuery(
          "SELECT tbl_dk_resources.ResId, tbl_dk_resources.ResGuid,tbl_dk_resources.ResCatId,ResName,ResNameTm,ResNameRu,ResNameEn,ResDesc,ResFullDesc,tbl_dk_res_price.ResPriceValue,tbl_dk_image.FilePath FROM tbl_dk_resources "
          "LEFT OUTER JOIN tbl_dk_image ON tbl_dk_image.ResId=tbl_dk_resources.ResId "
          "LEFT OUTER JOIN tbl_dk_res_price ON tbl_dk_res_price.ResId=tbl_dk_resources.ResId and tbl_dk_res_price.ResPriceGroupId = $resPriceGroupId and tbl_dk_res_price.ResPriceValue>0");
      return result.map((e) => VDkResource.fromMap(e)).toList();
    } catch (e) {
      debugPrint("PrintError on dbHelper.queryVResource: $e");
      rethrow;
    }
  }

//endregion ////////////////////Resources///////////////////////////

//region ////////////////ResPriceGroup/////////////////////////////////

  static Future<int> insertResPriceGroupList(String table, List<TblDkResPriceGroup> resPriceGroupList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResPriceGroup model in resPriceGroupList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    try {
      await batch.commit();
      return resPriceGroupList.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion ResPriceGroup

//region //////////////////ResPrices///////////////////////////////////

  static Future<int> insertResPricesList(String table, List<TblDkResPrice> resPricesList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResPrice model in resPricesList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    try {
      await batch.commit();
      return resPricesList.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion ResPrices

//region //////////////////Tables///////////////////////////////////

  static Future<int> insertTablesList(String table, List<TblDkTable> tables) async {
    return await _db!.transaction((txn) async {
      Batch batch = txn.batch();
      try {
        await txn.delete(table);

        for (TblDkTable model in tables) {
          batch.insert(table, model.toMap());
        }

        await batch.commit(noResult: true);

        return tables.length;
      } catch (e) {
        debugPrint("PrintError on insertTablesList: $e");
        return 0;
      }
    });
  }

//endregion Tables

//region //////////////////Events///////////////////////////////////

  static Future<int> insertEventsList(String table, List<TblDkEvent> events) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkEvent model in events) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    try {
      await batch.commit();
      return events.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion Events

//region //////////////////////// tbl_dk_images ///////////////////////
  static Future<List<Map<String, dynamic>>> rawQueryImageNameAndGuid() async {
    return await _db!.rawQuery("Select ImgGuid from tbl_dk_image");
  }

  static Future<int> insertImagesList(String table, List<TblDkImage> imagesList) async {
    Batch batch = _db!.batch();
    int imgCount = 0;
    for (TblDkImage model in imagesList) {
      try {
        final imgList = await _db!.query(table, where: "ImgGuid='${model.ImgGuid}'", limit: 1);
        TblDkImage? image = (imgList.isNotEmpty) ? TblDkImage.fromMap(imgList[0]) : null;
        if (image != null && image.ImgId != model.ImgId) {
          imgCount++;
          debugPrint("Print update image ${imgCount.toString()}");
          batch.update(table, model.toMap(), where: "ImgGuid='${model.ImgGuid}'");
        } else if (image == null) {
          imgCount++;
          debugPrint("Print insert image ${imgCount.toString()}");
          batch.insert(table, model.toMap());
        }
        if (imgCount > 20) {
          try {
            imgCount = 0;
            debugPrint('Print ImageCnt>20 try to commiting');
            await batch.commit();
            batch = _db!.batch();
          } catch (e) {
            imgCount = 0;
            throw Exception('Print SaveImageError: ${e.toString()}');
          }
        }
      } catch (e) {
        throw Exception('Print SaveImageError: ${e.toString()}');
      }
    }

    try {
      await batch.commit();
      return imagesList.length;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
//endregion Brand
}
