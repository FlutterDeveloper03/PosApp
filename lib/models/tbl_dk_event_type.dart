// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkEventType extends Model {
  //region Properties
  final int EventTypeId;
  final String EventTypeGuid;
  final String EventTypeName_tkTM;
  final String EventTypeDesc_tkTM;
  final String EventTypeName_ruRU;
  final String EventTypeDesc_ruRU;
  final String EventTypeName_enUS;
  final String EventTypeDesc_enUS;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkEventType({
    required this.EventTypeId,
    required this.EventTypeGuid,
    required this.EventTypeName_tkTM,
    required this.EventTypeDesc_tkTM,
    required this.EventTypeName_ruRU,
    required this.EventTypeDesc_ruRU,
    required this.EventTypeName_enUS,
    required this.EventTypeDesc_enUS,
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
        "EventTypeId": EventTypeId,
        "EventTypeGuid": EventTypeGuid,
        "EventTypeName_tkTM": EventTypeName_tkTM,
        "EventTypeDesc_tkTM": EventTypeDesc_tkTM,
        "EventTypeName_ruRU": EventTypeName_ruRU,
        "EventTypeDesc_ruRU": EventTypeDesc_ruRU,
        "EventTypeName_enUS": EventTypeName_enUS,
        "EventTypeDesc_enUS": EventTypeDesc_enUS,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkEventType fromMap(Map<String, dynamic> map) => TblDkEventType(
        EventTypeId: map['EventTypeId'] ?? 0,
        EventTypeGuid: map['EventTypeGuid']?.toString() ?? '',
        EventTypeName_tkTM: map['EventTypeName_tkTM']?.toString() ?? '',
        EventTypeDesc_tkTM: map['EventTypeDesc_tkTM']?.toString() ?? '',
        EventTypeName_ruRU: map['EventTypeName_ruRU']?.toString() ?? '',
        EventTypeDesc_ruRU: map['EventTypeDesc_ruRU']?.toString() ?? '',
        EventTypeName_enUS: map['EventTypeName_enUS']?.toString() ?? '',
        EventTypeDesc_enUS: map['EventTypeDesc_enUS']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  Map<String, dynamic> toJson() => {
        "EventTypeId": EventTypeId,
        "EventTypeGuid": EventTypeGuid,
        "EventTypeName_tkTM": EventTypeName_tkTM,
        "EventTypeDesc_tkTM": EventTypeDesc_tkTM,
        "EventTypeName_ruRU": EventTypeName_ruRU,
        "EventTypeDesc_ruRU": EventTypeDesc_ruRU,
        "EventTypeName_enUS": EventTypeName_enUS,
        "EventTypeDesc_enUS": EventTypeDesc_enUS,
        "CreatedDate": CreatedDate?.toIso8601String(),
        "ModifiedDate": ModifiedDate?.toIso8601String(),
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.toIso8601String(),
      };

  static TblDkEventType fromJson(Map<String, dynamic> json) => TblDkEventType(
        EventTypeId: json['EventTypeId'] ?? 0,
        EventTypeGuid: json['EventTypeGuid']?.toString() ?? '',
        EventTypeName_tkTM: json['EventTypeName_tkTM']?.toString() ?? '',
        EventTypeDesc_tkTM: json['EventTypeDesc_tkTM']?.toString() ?? '',
        EventTypeName_ruRU: json['EventTypeName_ruRU']?.toString() ?? '',
        EventTypeDesc_ruRU: json['EventTypeDesc_ruRU']?.toString() ?? '',
        EventTypeName_enUS: json['EventTypeName_enUS']?.toString() ?? '',
        EventTypeDesc_enUS: json['EventTypeDesc_enUS']?.toString() ?? '',
        CreatedDate: (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate: (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId: json['CreatedUId'] ?? 0,
        ModifiedUId: json['ModifiedUId'] ?? 0,
        SyncDateTime: (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null,
      );

//endregion Functions
}
