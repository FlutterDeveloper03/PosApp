// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkTableType extends Model {
  //region Properties
  final int TableTypeId;
  final String TableTypeGuid;
  final String TableTypeName_tkTM;
  final String TableTypeDesc_tkTM;
  final String TableTypeName_ruRU;
  final String TableTypeDesc_ruRU;
  final String TableTypeName_enUS;
  final String TableTypeDesc_enUS;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkTableType({
    required this.TableTypeId,
    required this.TableTypeGuid,
    required this.TableTypeName_tkTM,
    required this.TableTypeDesc_tkTM,
    required this.TableTypeName_ruRU,
    required this.TableTypeDesc_ruRU,
    required this.TableTypeName_enUS,
    required this.TableTypeDesc_enUS,
    required this.CreatedDate,
    required this.ModifiedDate,
    required this.CreatedUId,
    required this.ModifiedUId,
    required this.SyncDateTime,
  });

//endregion Constructor

//region Functions
  @override
  Map<String, dynamic> toMap() => {
        "TableTypeId": TableTypeId,
        "TableTypeGuid": TableTypeGuid,
        "TableTypeName_tkTM": TableTypeName_tkTM,
        "TableTypeDesc_tkTM": TableTypeDesc_tkTM,
        "TableTypeName_ruRU": TableTypeName_ruRU,
        "TableTypeDesc_ruRU": TableTypeDesc_ruRU,
        "TableTypeName_enUS": TableTypeName_enUS,
        "TableTypeDesc_enUS": TableTypeDesc_enUS,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkTableType fromMap(Map<String, dynamic> map) => TblDkTableType(
        TableTypeId: map['TableTypeId'] ?? 0,
        TableTypeGuid: map['TableTypeGuid']?.toString() ?? '',
        TableTypeName_tkTM: map['TableTypeName_tkTM']?.toString() ?? '',
        TableTypeDesc_tkTM: map['TableTypeDesc_tkTM']?.toString() ?? '',
        TableTypeName_ruRU: map['TableTypeName_ruRU']?.toString() ?? '',
        TableTypeDesc_ruRU: map['TableTypeDesc_ruRU']?.toString() ?? '',
        TableTypeName_enUS: map['TableTypeName_enUS']?.toString() ?? '',
        TableTypeDesc_enUS: map['TableTypeDesc_enUS']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  Map<String, dynamic> toJson() => {
        "TableTypeId": TableTypeId,
        "TableTypeGuid": TableTypeGuid,
        "TableTypeName_tkTM": TableTypeName_tkTM,
        "TableTypeDesc_tkTM": TableTypeDesc_tkTM,
        "TableTypeName_ruRU": TableTypeName_ruRU,
        "TableTypeDesc_ruRU": TableTypeDesc_ruRU,
        "TableTypeName_enUS": TableTypeName_enUS,
        "TableTypeDesc_enUS": TableTypeDesc_enUS,
        "CreatedDate": CreatedDate?.toIso8601String(),
        "ModifiedDate": ModifiedDate?.toIso8601String(),
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.toIso8601String(),
      };

  static TblDkTableType fromJson(Map<String, dynamic> json) => TblDkTableType(
        TableTypeId: json['TableTypeId'] ?? 0,
        TableTypeGuid: json['TableTypeGuid']?.toString() ?? '',
        TableTypeName_tkTM: json['TableTypeName_tkTM']?.toString() ?? '',
        TableTypeDesc_tkTM: json['TableTypeDesc_tkTM']?.toString() ?? '',
        TableTypeName_ruRU: json['TableTypeName_ruRU']?.toString() ?? '',
        TableTypeDesc_ruRU: json['TableTypeDesc_ruRU']?.toString() ?? '',
        TableTypeName_enUS: json['TableTypeName_enUS']?.toString() ?? '',
        TableTypeDesc_enUS: json['TableTypeDesc_enUS']?.toString() ?? '',
        CreatedDate: (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate: (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId: json['CreatedUId'] ?? 0,
        ModifiedUId: json['ModifiedUId'] ?? 0,
        SyncDateTime: (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null,
      );

//endregion Functions
}
