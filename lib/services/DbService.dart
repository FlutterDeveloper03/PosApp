// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/helpers/CustomException.dart';
import 'package:pos_app/models/tbl_dk_company.dart';
import 'package:pos_app/models/tbl_dk_event.dart';
import 'package:pos_app/models/tbl_dk_image.dart';
import 'package:pos_app/models/tbl_dk_res_category.dart';
import 'package:pos_app/models/tbl_dk_res_price.dart';
import 'package:pos_app/models/tbl_dk_res_price_group.dart';
import 'package:pos_app/models/tbl_dk_resource.dart';
import 'package:pos_app/models/tbl_dk_table.dart';
import 'package:pos_app/models/tbl_dk_user.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:sql_conn/sql_conn.dart';

class DbService {
  final String host;
  final int port;
  final String dbUName;
  final String dbUPass;
  final String dbName;

  DbService(this.host, this.port, this.dbName, this.dbUName, this.dbUPass);

  Future<int> connect() async {
    try {
      if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        await SqlConn.connect(ip: host, port: port.toString(), databaseName: dbName, username: dbUName, password: dbUPass);
        if (SqlConn.isConnected) {
          debugPrint("Connected!");
          return 1;
        } else {
          debugPrint("Print: Can't connect to db.");
          return 0;
        }
      } else {
        debugPrint("Print: Can't connect to db. Some required fields are empty");
        return 0;
      }
    } catch (e) {
      debugPrint("PrintError on QueryFromDb.connect: $e");
      return 0;
    }
  }

  Future<TblDkCompany?> getCompany() async {
    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData("SELECT firm_id as CId, firm_id_guid as CGuid, firm_name as CName, firm_fullname as CFullName, "
              "firm_phone as Phone1, firm_fax as Phone2, firm_adres1 as WebAddress FROM tbl_mg_firm");
          if (result != null) {
            List decodedList = jsonDecode(result);
            return TblDkCompany.fromJson(decodedList.first);
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getCompany(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError on getCompany(): ${e.toString()}");
      }
    }
    return null;
  }

  Future<List<TblDkResCategory>> getResCategories() async {
    String query = '''select cat_id as ResCatId, 
                      0 as ResOwnerCatId,
                      cat_order as ResCatVisibleIndex,
                      cat_name as ResCatName,
                      1 as CatTypeId,
                      '225fcb11-4721-4c08-98fc-1448d6e1183f' as CatTypeGuid,
                      cat_name_tm as ResCatNameTm,
                      cat_name_ru as ResCatNameRu,
                      cat_name_en as ResCatNameEn,
                      cat_image as ResCatIconData
                      from tbl_mg_category''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResCategory.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getResCategories(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getResCategories(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResource>> getResources() async {
    String query = '''select 
            material_id as ResId,
            material_id_guid as ResGuid,
            cat_id as ResCatId,
            material_name as ResName,
            spe_code1 as ResDesc,
            spe_code2 as ResFullDesc,
            mat_name_lang1 as ResNameTm,
            mat_name_lang2 as ResNameRu,
            mat_name_lang3 as ResNameEn
           from tbl_mg_materials
          where m_cat_id=14 
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResource.fromMap(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getResources(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getResources(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<VDkResource>> getVResources(int resPriceGroupId) async {
    String query =
        '''SELECT tbl_mg_materials.material_id as ResId, tbl_mg_materials.material_id_guid as ResGuid,tbl_mg_materials.cat_id as ResCatId,
                  material_name as ResName,mat_name_lang1 as ResNameTm,mat_name_lang2 as ResNameRu,mat_name_lang3 as ResNameEn,spe_code1 as ResDesc,
                  spe_code2 as ResFullDesc,CAST(ISNULL(tbl_mg_mat_price.price_value,0) as DECIMAL(18,2)) as ResPriceValue,'' as FilePath 
           FROM tbl_mg_materials 
           LEFT OUTER JOIN tbl_mg_mat_price ON tbl_mg_mat_price.material_id=tbl_mg_materials.material_id and tbl_mg_mat_price.price_cat_id = $resPriceGroupId 
                          and tbl_mg_mat_price.price_value>0 and CONVERT(datetime,price_start_date,104)<CONVERT(datetime,GETDATE(),104) 
                          and CONVERT(datetime,price_end_date,104)>CONVERT(datetime,GETDATE(),104)
           order by ResCatId
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => VDkResource.fromMap(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getVResources(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getVResources(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResCategory>> getTableCategories() async {
    String query = '''WITH CTE AS
      (
        select	DISTINCT group_code as ResCatName
          from tbl_mg_sale_disc_cards
          where sale_disc_type_id=2 and ((LEN(sale_disc_specode2)=0 or sale_disc_specode2 is null))
      )
      select ROW_NUMBER() over (order by ResCatName) as ResCatId, ResCatName,NEWID() as ResCatGuid,3 as CatTypeId, '566af293-e1d4-4ea3-a95c-794e2ff3796d' as CatTypeGuid from CTE
    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResCategory.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getTableCategories(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getTableCategories(): ${e.toString()}");
        rethrow;
      }
    }
    return [];
  }

  Future<List<TblDkTable>> getTables() async {
    String query = '''WITH CTE AS
                      (
                          select	DISTINCT group_code as ResCatName
                          from tbl_mg_sale_disc_cards
                          where sale_disc_type_id=2 and ((LEN(sale_disc_specode2)=0 or sale_disc_specode2 is null))
                      )
                      select	CatId, sale_disc_card_id as TableId, sale_disc_card_id_guid as TableGuid, sale_disc_card_id as SaleCardId,T_ID as EmpId,
                          firm_id as CId, sale_disc_card_status_id as TableStatusId, sale_disc_specode4 as TableTypeId,
                          sale_disc_card_name as TableName,spe_code as AddInf1, group_code as AddInf2, security_code as AddInf3,
                          sale_disc_specode1 as TablePersonCount,sale_disc_specode3 as MergedTablesCount, sale_disc_specode2 as TableGroupGuid
                      from tbl_mg_sale_disc_cards cards
                      left outer join (select ROW_NUMBER() over (order by ResCatName) as CatId, ResCatName from CTE) Cat on Cat.ResCatName=cards.group_code
                      where sale_disc_type_id=2 and ((LEN(sale_disc_specode2)=0 or sale_disc_specode2 is null or sale_disc_specode4 like '3'))
                   ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkTable.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getTables(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getTables(): ${e.toString()}");
        rethrow;
      }
    }
    return [];
  }

  Future<List<TblDkEvent>> getEvents({int? tableId, DateTime? startDate, DateTime? endDate}) async {
    String where1 = (tableId!=null) ? "TableId=$tableId" : "1=1";
    String where2 = (startDate!=null && endDate!=null) ? "CONVERT(DATETIME,EventStartDate,104) between CONVERT(DATETIME,N'$startDate',121) and CONVERT(DATETIME,N'$endDate',121)": "1=1";
    String where = (tableId!=null || (startDate!=null && endDate!=null))
                      ? "where $where1 and $where2" : "";

    String query = '''SELECT [EventId]
                            ,[EventGuid],[EventTypeId],[ResCatId],[ColorId],[LocId],[TableId],[TableGroupGuid],[SaleCardId],[RpAccId],[CId],[DivId]
                            ,[WpId],[EmpId],[OwnerEventId],[EventName],[EventDesc],[EventTitle],[EventStartDate],[EventEndDate],[WholeDay]
                            ,[NumberOfGuests],[TagsInfo],[RecurrenceInfo],[ReminderInfo],[AddInf1],[AddInf2],[AddInf3],[AddInf4],[AddInf5]
                            ,[AddInf6],[AddInf7],[AddInf8],[AddInf9],[AddInf10],[CreatedDate],[ModifiedDate],[CreatedUId],[ModifiedUId]
                            ,[SyncDateTime],[OptimisticLockField],[GCRecord]
                        FROM [tbl_dk_event]
                        $where
  ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkEvent.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        } else if (e.message?.contains("Invalid object name 'tbl_dk_event'.") ?? false) {
          createEventsTable();
          throw CantFindEventsTableException(e);
        }
        else{
          throw Exception(e.message ?? "");
        }
      } catch (e) {
        debugPrint("PrintError from getEvents(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<TblDkUser?> getUserData(String uName, String uPass) async {
    String query =
        '''select Top(1) T_ID as UId, T_ID_guid as UGuid, s.firm_id as CId, s.div_id as DivId, t.arap_id as RpAccId, 1 as ResPriceGroupId, '' as URegNo,t.TName as UFullName, t.T_User_Name as UName,
		    '' as UEmail, T_User_Pass as UPass,'' as UShortName, t.salesman_id as EmpId, User_Type_ID as UTypeId
        from tbl_mg_salesman s
        left outer join Teachers t on t.salesman_id=s.salesman_id
        where t.T_User_Name like '${uName.replaceAll("'", '')}' and t.T_User_Pass like '${uPass.replaceAll("'", '')}'
    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkUser.fromJson(e)).first;
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getUserData(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getUserData(): ${e.toString()}");
        rethrow;
      }
    }
    return null;
  }

  Future<List<TblDkUser>?> getUserDataByPin(String pinCode) async {
    String query =
        '''select Top(1) T_ID as UId, T_ID_guid as UGuid, s.firm_id as CId, s.div_id as DivId, t.arap_id as RpAccId, 1 as ResPriceGroupId, '' as URegNo,t.TName as UFullName, t.T_User_Name as UName,
		    '' as UEmail, T_User_Pass as UPass,'' as UShortName, t.salesman_id as EmpId, User_Type_ID as UTypeId
        from tbl_mg_salesman s
        left outer join Teachers t on t.salesman_id=s.salesman_id
        where t.T_User_Pass like '${pinCode.replaceAll("'", '')}'
    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkUser.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getUserDataByPin(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getUserDataByPin(): ${e.toString()}");
        rethrow;
      }
    }
    return null;
  }

  Future<bool> mergeTables(List<String> tableGuids, TblDkTable newMergedTable) async {
    String guid = newMergedTable.TableGroupGuid ?? '';
    List<String> guids = [];
    for (var e in tableGuids) {
      guids.add("'$e'");
    }

    String query = '''update tbl_mg_sale_disc_cards
                       set sale_disc_specode2='$guid'
                       where sale_disc_card_id_guid in (${guids.join(',')}) and sale_disc_type_id=2;
                       
                       insert into tbl_mg_sale_disc_cards
                          (sale_disc_card_code
                          ,sale_disc_card_name
                          ,sale_disc_card_prc
                          ,firm_id
                          ,arap_id
                          ,spe_code
                          ,group_code
                          ,security_code
                          ,sale_disc_card_status_id
                          ,sale_disc_perc
                          ,data_send
                          ,sale_disc_passport_no
                          ,sale_disc_address
                          ,sale_disc_mobile
                          ,sale_disc_telefon
                          ,sale_disc_fname
                          ,sale_disc_lname
                          ,sale_disc_middle_name
                          ,sale_disc_birth_date
                          ,sale_disc_specode1
                          ,sale_disc_specode2
                          ,sale_disc_specode3
                          ,sale_disc_specode4
                          ,sale_create_date
                          ,T_ID
                          ,sale_disc_cart_status_id
                          ,sale_disc_cart_no_add_point
                          ,sale_disc_cart_stop_close_point
                          ,price_cat_id
                          ,sale_disc_disabled
                          ,sale_disc_type_id
                          ,sale_disc_card_id_guid)
                         VALUES
                           ('${newMergedTable.TableId.toString()}'
                           ,'${newMergedTable.TableName}'
                           ,0
                           ,${newMergedTable.CId}
                           ,0
                           ,'${newMergedTable.AddInf1}'
                           ,'${newMergedTable.AddInf2}'
                           ,'${newMergedTable.AddInf3}'
                           ,${newMergedTable.TableStatusId}
                           ,0
                           ,0
                           ,''
                           ,''
                           ,''
                           ,''
                           ,''
                           ,''
                           ,''
                           ,''
                           ,${newMergedTable.TablePersonCount}
                           ,'$guid'
                           ,${newMergedTable.MergedTablesCount}
                           ,'3'
                           ,''
                           ,${newMergedTable.EmpId}
                           ,${newMergedTable.TableStatusId}
                           ,0
                           ,0
                           ,0
                           ,0
                           ,2
                           ,NEWID())
                    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.writeData(query);
          return result;
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from mergeTables(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from mergeTables(): ${e.toString()}");
        rethrow;
      }
    }
    return false;
  }

  Future<bool> addEvent(TblDkEvent event) async {
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String query = '''INSERT INTO [dbo].[tbl_dk_event]
                           ([EventGuid],[EventTypeId],[ResCatId],[ColorId],[LocId],[TableId],[TableGroupGuid],[SaleCardId],[RpAccId],[CId],[DivId],[WpId]
                           ,[EmpId],[OwnerEventId],[EventName],[EventDesc],[EventTitle],[EventStartDate],[EventEndDate],[WholeDay],[NumberOfGuests]
                           ,[TagsInfo],[RecurrenceInfo],[ReminderInfo],[AddInf1],[AddInf2],[AddInf3],[AddInf4],[AddInf5],[AddInf6],[AddInf7],[AddInf8]
                           ,[AddInf9],[AddInf10],[CreatedDate],[ModifiedDate],[CreatedUId],[ModifiedUId],[SyncDateTime])
                      VALUES
                           (NEWID(),${event.EventTypeId},${event.ResCatId},${event.ColorId},${event.LocId}
                           ,${event.TableId},${(event.TableGroupGuid?.isEmpty ?? false) ? null : "'${event.TableGroupGuid}'"},${event.SaleCardId},${event.RpAccId},${event.CId}
                           ,${event.DivId},${event.WpId},${event.EmpId},${event.OwnerEventId},'${event.EventName}'
                           ,'${event.EventDesc}','${event.EventTitle}',N'${dateFormatter.format(event.EventStartDate!)}','${dateFormatter.format(event.EventEndDate!)}',${event.WholeDay}
                           ,${event.NumberOfGuests},'${event.TagsInfo}','${event.RecurrenceInfo}','${event.ReminderInfo}','${event.AddInf1}'
                           ,'${event.AddInf2}','${event.AddInf3}','${event.AddInf4}','${event.AddInf5}','${event.AddInf6}','${event.AddInf7}'
                           ,'${event.AddInf8}','${event.AddInf9}','${event.AddInf10}',${(event.CreatedDate!=null) ? "N'${event.CreatedDate}'" : null}
                           ,${(event.ModifiedDate!=null) ? "N'${event.ModifiedDate}'" : null},${event.CreatedUId}
                           ,${event.ModifiedUId},${(event.SyncDateTime!=null) ? "N'${event.SyncDateTime}'" : null})
                    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.writeData(query);
          return result;
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        } else if (e.message?.contains("Invalid object name 'dbo.tbl_dk_event'.") ?? false){
          createEventsTable();
          throw CantFindEventsTableException(e);
        }
        debugPrint("PrintError from addEvent(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from addEvent(): ${e.toString()}");
        rethrow;
      }
    }
    return false;
  }

  Future<bool> modifyEvent(TblDkEvent event, {bool? delete}) async {
    String query = '';
    if (delete ?? false){
      query = '''Delete from tbl_dk_event
                        where EventId=${event.EventId}
                    ''';
    } else {
      query = '''UPDATE tbl_dk_event
                        SET [EventGuid] = '${event.EventGuid}'
                          ,[EventTypeId] = ${event.EventTypeId}
                          ,[ResCatId] = ${event.ResCatId}
                          ,[ColorId] = ${event.ColorId}
                          ,[LocId] = ${event.LocId}
                          ,[TableId] = ${event.TableId}
                          ,[SaleCardId] = ${event.SaleCardId}
                          ,[RpAccId] = ${event.RpAccId}
                          ,[CId] = ${event.CId}
                          ,[DivId] = ${event.DivId}
                          ,[WpId] = ${event.WpId}
                          ,[EmpId] = ${event.EmpId}
                          ,[OwnerEventId] = ${event.OwnerEventId}
                          ,[EventName] = '${event.EventName}'
                          ,[EventDesc] = '${event.EventDesc}'
                          ,[EventTitle] = '${event.EventTitle}'
                          ,[EventStartDate] = N'${event.EventStartDate}'
                          ,[EventEndDate] = N'${event.EventEndDate}'
                          ,[WholeDay] = ${event.WholeDay}
                          ,[NumberOfGuests] = ${event.NumberOfGuests}
                          ,[TagsInfo] = '${event.TagsInfo}'
                          ,[RecurrenceInfo] = '${event.RecurrenceInfo}'
                          ,[ReminderInfo] = '${event.ReminderInfo}'
                          ,[AddInf1] = '${event.AddInf1}'
                          ,[AddInf2] = '${event.AddInf2}'
                          ,[AddInf3] = '${event.AddInf3}'
                          ,[AddInf4] = '${event.AddInf4}'
                          ,[AddInf5] = '${event.AddInf5}'
                          ,[AddInf6] = '${event.AddInf6}'
                          ,[AddInf7] = '${event.AddInf7}'
                          ,[AddInf8] = '${event.AddInf8}'
                          ,[AddInf9] = '${event.AddInf9}'
                          ,[AddInf10] = '${event.AddInf10}'
                          ,[CreatedDate] = ${(event.CreatedDate!=null) ? "N'${event.CreatedDate}'" : null}
                          ,[ModifiedDate] = ${(event.ModifiedDate!=null) ? "N'${event.ModifiedDate}'" : null}
                          ,[CreatedUId] = ${event.CreatedUId}
                          ,[ModifiedUId] = ${event.ModifiedUId}
                          ,[SyncDateTime] = ${(event.SyncDateTime!=null) ? "N'${event.SyncDateTime}'" : null}
                     WHERE EventId=${event.EventId}
                    ''';
    }

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.writeData(query);
          return result;
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        } else if (e.message == "Invalid object name 'tbl_dk_event'.") {
          createEventTable();
          return false;
        }
        debugPrint("PrintError from modifyEvent(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from modifyEvent(): ${e.toString()}");
        rethrow;
      }
    }
    return false;
  }


  Future<bool> createEventTable() async {
    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        var result = await SqlConn.writeData("""
            CREATE TABLE [dbo].[tbl_dk_event](
              [EventId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
              [EventGuid] [uniqueidentifier] NULL,
              [EventTypeId] [int] NULL,
              [ResCatId] [int] NULL,
              [ColorId] [int] NULL,
              [LocId] [int] NULL,
              [TableId] [int] NULL,
              [TableGroupGuid] [uniqueidentifier] NULL,
              [SaleCardId] [int] NULL,
              [RpAccId] [int] NULL,
              [CId] [int] NULL,
              [DivId] [int] NULL,
              [WpId] [int] NULL,
              [EmpId] [int] NULL,
              [OwnerEventId] [int] NULL,
              [EventName] [nvarchar](500) NULL,
              [EventDesc] [nvarchar](max) NULL,
              [EventTitle] [nvarchar](100) NULL,
              [EventStartDate] [datetime] NULL,
              [EventEndDate] [datetime] NULL,
              [WholeDay] [bit] NULL,
              [NumberOfGuests] [int] NULL,
              [TagsInfo] [nvarchar](1000) NULL,
              [RecurrenceInfo] [nvarchar](1000) NULL,
              [ReminderInfo] [nvarchar](1000) NULL,
              [AddInf1] [nvarchar](max) NULL,
              [AddInf2] [nvarchar](max) NULL,
              [AddInf3] [nvarchar](max) NULL,
              [AddInf4] [nvarchar](max) NULL,
              [AddInf5] [nvarchar](max) NULL,
              [AddInf6] [nvarchar](max) NULL,
              [AddInf7] [nvarchar](max) NULL,
              [AddInf8] [nvarchar](max) NULL,
              [AddInf9] [nvarchar](max) NULL,
              [AddInf10] [nvarchar](max) NULL,
              [CreatedDate] [datetime] NULL,
              [ModifiedDate] [datetime] NULL,
              [CreatedUId] [int] NULL,
              [ModifiedUId] [int] NULL,
              [SyncDateTime] [datetime] NULL,
              [OptimisticLockField] [int] NULL,
              [GCRecord] [int] NULL,
             CONSTRAINT [PK_tbl_dk_event] PRIMARY KEY CLUSTERED 
            (
              [EventId] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
            """);
        if (result != null) {
          return true;
        }
      } catch (e) {
        debugPrint("PrintError on createEventTable(): ${e.toString()}");
        rethrow;
      }
    }
    return false;
  }

  Future<bool> divideTables(List<String> tableGroupGuids) async {
    if (tableGroupGuids.isNotEmpty) {
      String guidsStr = tableGroupGuids.map((e) => "'$e'").join(",");
      String query = '''update tbl_mg_sale_disc_cards
                       set sale_disc_specode2=''
                       where sale_disc_specode2 in ($guidsStr) and sale_disc_type_id=2 and sale_disc_specode4!='3';
                       
                       
                       delete from tbl_mg_sale_disc_cards
                       where sale_disc_specode2 in ($guidsStr) and sale_disc_type_id=2 and sale_disc_specode4='3'
                    ''';

      if (host.isNotEmpty &&
          port > 0 &&
          dbUName.isNotEmpty &&
          dbUPass.isNotEmpty &&
          dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(query);
            return result;
          }
        } on PlatformException catch (e) {
          if (e.message?.contains('Network error IOException') ?? false) {
            throw CantConnectToServerException(e);
          }
          debugPrint("PrintError from divideTables(): ${e.toString()}");
        } catch (e) {
          debugPrint("PrintError from divideTables(): ${e.toString()}");
          rethrow;
        }
      }
    }
    return false;
  }

  Future<List<TblDkResPrice>> getResPrices() async {
    String query = '''select 
            price_id as ResPriceId,
            price_cat_id as ResPriceGroupId,
            currency_id as CurrencyId,
            material_id as ResId,
            '' as ResPriceRegNo,
            price_value as ResPriceValue,
            price_start_date as PriceStartDate,
            price_end_date as PriceEndDate,
            sync_datetime as SyncDateTime
           from tbl_mg_mat_price
           where price_type_id=2
           ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResPrice.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getResPrices(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getResPrices(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResPriceGroup>> getResPriceGroup() async {
    String query = '''select 
            price_cat_id as  ResPriceGroupId,
            price_cat_name as ResPriceGroupName
           from tbl_mg_price_category
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResPriceGroup.fromMap(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getResPriceGroup(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getResPriceGroup(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkImage>> getImages(String oldImages, int offset, int rowCnt) async {
    String query = '''select 
            image_id as ImgId,
            image_id_guid as ImgGuid,
            0 as ResCatId,
            0 as CId,
            material_id as ResId,
            image_pict as Image
            from tbl_mg_images 
           ${oldImages.isNotEmpty ? 'where image_id_guid not in ($oldImages)' : ''}
           ORDER BY image_id
           OFFSET $offset ROWS FETCH NEXT $rowCnt ROWS ONLY
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkImage.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getImages(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getImages(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkImage>> getImageByHash(int resId, {String? imgHash}) async {
    String query = '''select Top(1)
                          image_id as ImgId,
                          image_id_guid as ImgGuid,
                          0 as ResCatId,
                          0 as CId,
                          material_id as ResId,
                          HASHBYTES('SHA2_512',CAST(image_pict as varbinary(8000))) as FileHash,
                          image_pict as Image
                       from tbl_mg_images 
                       where material_id = $resId ${(imgHash!=null && imgHash.isNotEmpty) ? "and '$imgHash' not like HASHBYTES('SHA2_512',CAST(image_pict as varbinary(8000)))" : ""}
                    ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkImage.fromJson(e)).toList();
          }
        }
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from getImages(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from getImages(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<bool> createEventsTable() async {
    String query = '''CREATE TABLE [dbo].[tbl_dk_event](
                          [EventId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
                          [EventGuid] [uniqueidentifier] NULL,
                          [EventTypeId] [int] NULL,
                          [ResCatId] [int] NULL,
                          [ColorId] [int] NULL,
                          [LocId] [int] NULL,
                          [TableId] [int] NULL,
                          [TableGroupGuid] [uniqueidentifier] NULL,
                          [SaleCardId] [int] NULL,
                          [RpAccId] [int] NULL,
                          [CId] [int] NULL,
                          [DivId] [int] NULL,
                          [WpId] [int] NULL,
                          [EmpId] [int] NULL,
                          [OwnerEventId] [int] NULL,
                          [EventName] [nvarchar](500) NULL,
                          [EventDesc] [nvarchar](max) NULL,
                          [EventTitle] [nvarchar](100) NULL,
                          [EventStartDate] [datetime] NULL,
                          [EventEndDate] [datetime] NULL,
                          [WholeDay] [bit] NULL,
                          [NumberOfGuests] [int] NULL,
                          [TagsInfo] [nvarchar](1000) NULL,
                          [RecurrenceInfo] [nvarchar](1000) NULL,
                          [ReminderInfo] [nvarchar](1000) NULL,
                          [AddInf1] [nvarchar](max) NULL,
                          [AddInf2] [nvarchar](max) NULL,
                          [AddInf3] [nvarchar](max) NULL,
                          [AddInf4] [nvarchar](max) NULL,
                          [AddInf5] [nvarchar](max) NULL,
                          [AddInf6] [nvarchar](max) NULL,
                          [AddInf7] [nvarchar](max) NULL,
                          [AddInf8] [nvarchar](max) NULL,
                          [AddInf9] [nvarchar](max) NULL,
                          [AddInf10] [nvarchar](max) NULL,
                          [CreatedDate] [datetime] NULL,
                          [ModifiedDate] [datetime] NULL,
                          [CreatedUId] [int] NULL,
                          [ModifiedUId] [int] NULL,
                          [SyncDateTime] [datetime] NULL,
                          [OptimisticLockField] [int] NULL,
                          [GCRecord] [int] NULL,
                         CONSTRAINT [PK_tbl_dk_event] PRIMARY KEY CLUSTERED 
                        (
                          [EventId] ASC
                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
                    ''';

    if (host.isNotEmpty &&
        port > 0 &&
        dbUName.isNotEmpty &&
        dbUPass.isNotEmpty &&
        dbName.isNotEmpty) {
      try {
          var result = await SqlConn.writeData(query);
          return result;
      } on PlatformException catch (e) {
        if (e.message?.contains('Network error IOException') ?? false) {
          throw CantConnectToServerException(e);
        }
        debugPrint("PrintError from createEventsTable(): ${e.toString()}");
      } catch (e) {
        debugPrint("PrintError from createEventsTable(): ${e.toString()}");
        rethrow;
      }
    }
    return false;
  }
}
