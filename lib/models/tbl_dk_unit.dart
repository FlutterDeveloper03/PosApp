// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkUnit extends Model {
  //region Properties
  final int UnitId;
  final String UnitGuid;
  final String UnitName_tkTM;
  final String UnitDesc_tkTM;
  final String UnitName_ruRU;
  final String UnitDesc_ruRU;
  final String UnitName_enUS;
  final String UnitDesc_enUS;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkUnit({
    required this.UnitId,
    required this.UnitGuid,
    required this.UnitName_tkTM,
    required this.UnitDesc_tkTM,
    required this.UnitName_ruRU,
    required this.UnitDesc_ruRU,
    required this.UnitName_enUS,
    required this.UnitDesc_enUS,
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
        "UnitId": UnitId,
        "UnitGuid": UnitGuid,
        "UnitName_tkTM": UnitName_tkTM,
        "UnitDesc_tkTM": UnitDesc_tkTM,
        "UnitName_ruRU": UnitName_ruRU,
        "UnitDesc_ruRU": UnitDesc_ruRU,
        "UnitName_enUS": UnitName_enUS,
        "UnitDesc_enUS": UnitDesc_enUS,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkUnit fromMap(Map<String, dynamic> map) => TblDkUnit(
        UnitId: map['UnitId'] ?? 0,
        UnitGuid: map['UnitGuid']?.toString() ?? '',
        UnitName_tkTM: map['UnitName_tkTM']?.toString() ?? '',
        UnitDesc_tkTM: map['UnitDesc_tkTM']?.toString() ?? '',
        UnitName_ruRU: map['UnitName_ruRU']?.toString() ?? '',
        UnitDesc_ruRU: map['UnitDesc_ruRU']?.toString() ?? '',
        UnitName_enUS: map['UnitName_enUS']?.toString() ?? '',
        UnitDesc_enUS: map['UnitDesc_enUS']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  TblDkUnit.fromJson(Map<String, dynamic> json)
      : UnitId = json['UnitId'] ?? 0,
        UnitGuid = json['UnitGuid']?.toString() ?? '',
        UnitName_tkTM = json['UnitName_tkTM']?.toString() ?? '',
        UnitDesc_tkTM = json['UnitDesc_tkTM']?.toString() ?? '',
        UnitName_ruRU = json['UnitName_ruRU']?.toString() ?? '',
        UnitDesc_ruRU = json['UnitDesc_ruRU']?.toString() ?? '',
        UnitName_enUS = json['UnitName_enUS']?.toString() ?? '',
        UnitDesc_enUS = json['UnitDesc_enUS']?.toString() ?? '',
        CreatedDate = (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate = (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = json['CreatedUId'] ?? 0,
        ModifiedUId = json['ModifiedUId'] ?? 0,
        SyncDateTime = (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        'UnitId': UnitId,
        'UnitGuid': UnitGuid,
        'UnitName_tkTM': UnitName_tkTM,
        'UnitDesc_tkTM': UnitDesc_tkTM,
        'UnitName_ruRU': UnitName_ruRU,
        'UnitDesc_ruRU': UnitDesc_ruRU,
        'UnitName_enUS': UnitName_enUS,
        'UnitDesc_enUS': UnitDesc_enUS,
        'CreatedDate': CreatedDate?.toIso8601String(),
        'ModifiedDate': ModifiedDate?.toIso8601String(),
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.toIso8601String(),
      };

  TblDkUnit copyWith({
    int? UnitId,
    String? UnitGuid,
    String? UnitName_tkTM,
    String? UnitDesc_tkTM,
    String? UnitName_ruRU,
    String? UnitDesc_ruRU,
    String? UnitName_enUS,
    String? UnitDesc_enUS,
    DateTime? CreatedDate,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
  }) {
    return TblDkUnit(
      UnitId: UnitId ?? this.UnitId,
      UnitGuid: UnitGuid ?? this.UnitGuid,
      UnitName_tkTM: UnitName_tkTM ?? this.UnitName_tkTM,
      UnitDesc_tkTM: UnitDesc_tkTM ?? this.UnitDesc_tkTM,
      UnitName_ruRU: UnitName_ruRU ?? this.UnitName_ruRU,
      UnitDesc_ruRU: UnitDesc_ruRU ?? this.UnitDesc_ruRU,
      UnitName_enUS: UnitName_enUS ?? this.UnitName_enUS,
      UnitDesc_enUS: UnitDesc_enUS ?? this.UnitDesc_enUS,
      CreatedDate: CreatedDate ?? this.CreatedDate,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }

//endregion Functions
}
