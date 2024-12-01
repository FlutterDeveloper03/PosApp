// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkTable extends Model {
  //region Properties
  final int TableId;
  final String TableGuid;
  final int SaleCardId;
  final int CId;
  final int DivId;
  final int WpId;
  final int TableStatusId;
  final int TableTypeId;
  final int CatId;
  final int EmpId;
  final String TableName;
  final String TableDesc;
  final int TablePersonCount;
  final int MergedTablesCount;
  final String? TableGroupGuid;
  final String AddInf1;
  final String AddInf2;
  final String AddInf3;
  final String AddInf4;
  final String AddInf5;
  final String AddInf6;
  final String AddInf7;
  final String AddInf8;
  final String AddInf9;
  final String AddInf10;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  TblDkTable({
    required this.TableId,
    required this.TableGuid,
    required this.SaleCardId,
    required this.CId,
    required this.DivId,
    required this.WpId,
    required this.TableStatusId,
    required this.TableTypeId,
    required this.CatId,
    required this.EmpId,
    required this.TableName,
    required this.TableDesc,
    required this.TablePersonCount,
    required this.MergedTablesCount,
    required this.TableGroupGuid,
    required this.AddInf1,
    required this.AddInf2,
    required this.AddInf3,
    required this.AddInf4,
    required this.AddInf5,
    required this.AddInf6,
    required this.AddInf7,
    required this.AddInf8,
    required this.AddInf9,
    required this.AddInf10,
    required this.CreatedDate,
    required this.ModifiedDate,
    required this.CreatedUId,
    required this.ModifiedUId,
    required this.SyncDateTime,
  });

  @override
  Map<String, dynamic> toMap() => {
        "TableId": TableId,
        "TableGuid": TableGuid,
        "SaleCardId": SaleCardId,
        "CId": CId,
        "DivId": DivId,
        "WpId": WpId,
        "TableStatusId": TableStatusId,
        "TableTypeId": TableTypeId,
        "CatId": CatId,
        "EmpId": EmpId,
        "TableName": TableName,
        "TableDesc": TableDesc,
        "TablePersonCount": TablePersonCount,
        "MergedTablesCount": MergedTablesCount,
        "TableGroupGuid": TableGroupGuid,
        "AddInf1": AddInf1,
        "AddInf2": AddInf2,
        "AddInf3": AddInf3,
        "AddInf4": AddInf4,
        "AddInf5": AddInf5,
        "AddInf6": AddInf6,
        "AddInf7": AddInf7,
        "AddInf8": AddInf8,
        "AddInf9": AddInf9,
        "AddInf10": AddInf10,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkTable fromMap(Map<String, dynamic> map) => TblDkTable(
        TableId: map['TableId'] ?? 0,
        TableGuid: map['TableGuid'] ?? '',
        SaleCardId: map['SaleCardId'] ?? 0,
        CId: map['CId'] ?? 0,
        DivId: map['DivId'] ?? 0,
        WpId: map['WpId'] ?? 0,
        TableStatusId: map['TableStatusId'] ?? 0,
        TableTypeId: map['TableTypeId'] ?? 2,
        CatId: map['CatId'] ?? 0,
        EmpId: map['EmpId'] ?? 0,
        TableName: map['TableName']?.toString() ?? '',
        TableDesc: map['TableDesc']?.toString() ?? '',
        TablePersonCount: map['TablePersonCount'] ?? 0,
        MergedTablesCount: map['MergedTablesCount'] ?? 0,
        TableGroupGuid: map['TableGroupGuid']?.toString(),
        AddInf1: map['AddInf1'] ?? '',
        AddInf2: map['AddInf2'] ?? '',
        AddInf3: map['AddInf3'] ?? '',
        AddInf4: map['AddInf4'] ?? '',
        AddInf5: map['AddInf5'] ?? '',
        AddInf6: map['AddInf6'] ?? '',
        AddInf7: map['AddInf7'] ?? '',
        AddInf8: map['AddInf8'] ?? '',
        AddInf9: map['AddInf9'] ?? '',
        AddInf10: map['AddInf10'] ?? '',
        CreatedDate: DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0),
        ModifiedDate: DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0),
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0),
      );

  TblDkTable.fromJson(Map<String, dynamic> json)
      : TableId = json['TableId'] ?? 0,
        TableGuid = json['TableGuid'] ?? '',
        SaleCardId = json['SaleCardId'] ?? 0,
        CId = json['CId'] ?? 0,
        DivId = json['DivId'] ?? 0,
        WpId = json['WpId'] ?? 0,
        TableStatusId = json['TableStatusId'] ?? 0,
        TableTypeId = int.tryParse(json['TableTypeId']?.toString() ?? '2') ?? 2,
        CatId = int.tryParse(json['CatId']?.toString() ?? '0') ?? 0,
        EmpId = int.tryParse(json['EmpId']?.toString() ?? '0') ?? 0,
        TableName = json['TableName']?.toString() ?? '',
        TableDesc = json['TableDesc']?.toString() ?? '',
        TablePersonCount = int.tryParse(json['TablePersonCount']?.toString() ?? '2') ?? 2,
        MergedTablesCount = int.tryParse(json['MergedTablesCount']?.toString() ?? '0') ?? 0,
        TableGroupGuid = json['TableGroupGuid']?.toString(),
        AddInf1 = json['AddInf1']?.toString() ?? '',
        AddInf2 = json['AddInf2']?.toString() ?? '',
        AddInf3 = json['AddInf3']?.toString() ?? '',
        AddInf4 = json['AddInf4']?.toString() ?? '',
        AddInf5 = json['AddInf5']?.toString() ?? '',
        AddInf6 = json['AddInf6']?.toString() ?? '',
        AddInf7 = json['AddInf7']?.toString() ?? '',
        AddInf8 = json['AddInf8']?.toString() ?? '',
        AddInf9 = json['AddInf9']?.toString() ?? '',
        AddInf10 = json['AddInf10']?.toString() ?? '',
        CreatedDate = DateTime.parse(json['CreatedDate'] ?? '1900-01-01'),
        ModifiedDate = DateTime.parse(json['ModifiedDate'] ?? '1900-01-01'),
        CreatedUId = json['CreatedUId'] ?? 0,
        ModifiedUId = json['ModifiedUId'] ?? 0,
        SyncDateTime = DateTime.parse(json['SyncDateTime'] ?? '1900-01-01');

//SyncDateTime =(json['SyncDateTime']!=null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        'TableId': TableId,
        'TableGuid': TableGuid,
        'SaleCardId': SaleCardId,
        'CId': CId,
        'DivId': DivId,
        'WpId': WpId,
        'TableStatusId': TableStatusId,
        'TableTypeId': TableTypeId,
        'CatId': CatId,
        'EmpId': EmpId,
        'TableName': TableName,
        'TableDesc': TableDesc,
        'TablePersonCount': TablePersonCount,
        'MergedTablesCount': MergedTablesCount,
        'TableGroupGuid': TableGroupGuid,
        'AddInf1': AddInf1,
        'AddInf2': AddInf2,
        'AddInf3': AddInf3,
        'AddInf4': AddInf4,
        'AddInf5': AddInf5,
        'AddInf6': AddInf6,
        'AddInf7': AddInf7,
        'AddInf8': AddInf8,
        'AddInf9': AddInf9,
        'AddInf10': AddInf10,
        'CreatedDate': CreatedDate,
        'ModifiedDate': ModifiedDate,
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime,
      };

  TblDkTable copyWith({
    int? TableId,
    String? TableGuid,
    int? SaleCardId,
    int? CId,
    int? DivId,
    int? WpId,
    int? TableStatusId,
    int? TableTypeId,
    int? CatId,
    int? EmpId,
    String? TableName,
    String? TableDesc,
    int? TablePersonCount,
    int? MergedTablesCount,
    String? TableGroupGuid,
    String? AddInf1,
    String? AddInf2,
    String? AddInf3,
    String? AddInf4,
    String? AddInf5,
    String? AddInf6,
    String? AddInf7,
    String? AddInf8,
    String? AddInf9,
    String? AddInf10,
    DateTime? CreatedDate,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
  }) {
    return TblDkTable(
      TableId: TableId ?? this.TableId,
      TableGuid: TableGuid ?? this.TableGuid,
      SaleCardId: SaleCardId ?? this.SaleCardId,
      CId: CId ?? this.CId,
      DivId: DivId ?? this.DivId,
      WpId: WpId ?? this.WpId,
      TableStatusId: TableStatusId ?? this.TableStatusId,
      TableTypeId: TableTypeId ?? this.TableTypeId,
      CatId: CatId ?? this.CatId,
      EmpId: EmpId ?? this.EmpId,
      TableName: TableName ?? this.TableName,
      TableDesc: TableDesc ?? this.TableDesc,
      TablePersonCount: TablePersonCount ?? this.TablePersonCount,
      MergedTablesCount: MergedTablesCount ?? this.MergedTablesCount,
      TableGroupGuid: TableGroupGuid ?? this.TableGroupGuid,
      AddInf1: AddInf1 ?? this.AddInf1,
      AddInf2: AddInf2 ?? this.AddInf2,
      AddInf3: AddInf3 ?? this.AddInf3,
      AddInf4: AddInf4 ?? this.AddInf4,
      AddInf5: AddInf5 ?? this.AddInf5,
      AddInf6: AddInf6 ?? this.AddInf6,
      AddInf7: AddInf7 ?? this.AddInf7,
      AddInf8: AddInf8 ?? this.AddInf8,
      AddInf9: AddInf9 ?? this.AddInf9,
      AddInf10: AddInf10 ?? this.AddInf10,
      CreatedDate: CreatedDate ?? this.CreatedDate,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }
}
