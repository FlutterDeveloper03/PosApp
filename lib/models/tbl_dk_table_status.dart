// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkTableStatus extends Model {
  //region Properties
  final int TableStatusId;
  final String TableStatusGuid;
  final String TableStatusName_tkTM;
  final String TableStatusDesc_tkTM;
  final String TableStatusName_ruRU;
  final String TableStatusDesc_ruRU;
  final String TableStatusName_enUS;
  final String TableStatusDesc_enUS;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkTableStatus({
    required this.TableStatusId,
    required this.TableStatusGuid,
    required this.TableStatusName_tkTM,
    required this.TableStatusDesc_tkTM,
    required this.TableStatusName_ruRU,
    required this.TableStatusDesc_ruRU,
    required this.TableStatusName_enUS,
    required this.TableStatusDesc_enUS,
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
        "TableStatusId": TableStatusId,
        "TableStatusGuid": TableStatusGuid,
        "TableStatusName_tkTM": TableStatusName_tkTM,
        "TableStatusDesc_tkTM": TableStatusDesc_tkTM,
        "TableStatusName_ruRU": TableStatusName_ruRU,
        "TableStatusDesc_ruRU": TableStatusDesc_ruRU,
        "TableStatusName_enUS": TableStatusName_enUS,
        "TableStatusDesc_enUS": TableStatusDesc_enUS,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkTableStatus fromMap(Map<String, dynamic> map) => TblDkTableStatus(
        TableStatusId: map['TableStatusId'] ?? 0,
        TableStatusGuid: map['TableStatusGuid']?.toString() ?? '',
        TableStatusName_tkTM: map['TableStatusName_tkTM']?.toString() ?? '',
        TableStatusDesc_tkTM: map['TableStatusDesc_tkTM']?.toString() ?? '',
        TableStatusName_ruRU: map['TableStatusName_ruRU']?.toString() ?? '',
        TableStatusDesc_ruRU: map['TableStatusDesc_ruRU']?.toString() ?? '',
        TableStatusName_enUS: map['TableStatusName_enUS']?.toString() ?? '',
        TableStatusDesc_enUS: map['TableStatusDesc_enUS']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  Map<String, dynamic> toJson() => {
        "TableStatusId": TableStatusId,
        "TableStatusGuid": TableStatusGuid,
        "TableStatusName_tkTM": TableStatusName_tkTM,
        "TableStatusDesc_tkTM": TableStatusDesc_tkTM,
        "TableStatusName_ruRU": TableStatusName_ruRU,
        "TableStatusDesc_ruRU": TableStatusDesc_ruRU,
        "TableStatusName_enUS": TableStatusName_enUS,
        "TableStatusDesc_enUS": TableStatusDesc_enUS,
        "CreatedDate": CreatedDate?.toIso8601String(),
        "ModifiedDate": ModifiedDate?.toIso8601String(),
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.toIso8601String(),
      };

  static TblDkTableStatus fromJson(Map<String, dynamic> json) => TblDkTableStatus(
        TableStatusId: json['TableStatusId'] ?? 0,
        TableStatusGuid: json['TableStatusGuid']?.toString() ?? '',
        TableStatusName_tkTM: json['TableStatusName_tkTM']?.toString() ?? '',
        TableStatusDesc_tkTM: json['TableStatusDesc_tkTM']?.toString() ?? '',
        TableStatusName_ruRU: json['TableStatusName_ruRU']?.toString() ?? '',
        TableStatusDesc_ruRU: json['TableStatusDesc_ruRU']?.toString() ?? '',
        TableStatusName_enUS: json['TableStatusName_enUS']?.toString() ?? '',
        TableStatusDesc_enUS: json['TableStatusDesc_enUS']?.toString() ?? '',
        CreatedDate: (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate: (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId: json['CreatedUId'] ?? 0,
        ModifiedUId: json['ModifiedUId'] ?? 0,
        SyncDateTime: (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null,
      );

//endregion Functions
}
