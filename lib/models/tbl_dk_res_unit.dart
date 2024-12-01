// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkResUnit extends Model {
  //region Properties
  final int ResUnitId;
  final String ResUnitGuid;
  final int ResId;
  final int UnitId;
  final String ResUnitName;
  final String ResUnitDesc;
  final double ResUnitConvAmount;
  final int ResUnitConvTypeId;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkResUnit({
    required this.ResUnitId,
    required this.ResUnitGuid,
    required this.ResId,
    required this.UnitId,
    required this.ResUnitName,
    required this.ResUnitDesc,
    required this.ResUnitConvAmount,
    required this.ResUnitConvTypeId,
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
        "ResUnitId": ResUnitId,
        "ResUnitGuid": ResUnitGuid,
        "ResId": ResId,
        "UnitId": UnitId,
        "ResUnitName": ResUnitName,
        "ResUnitDesc": ResUnitDesc,
        "ResUnitConvAmount": ResUnitConvAmount,
        "ResUnitConvTypeId": ResUnitConvTypeId,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkResUnit fromMap(Map<String, dynamic> map) => TblDkResUnit(
        ResUnitId: map['ResUnitId'] ?? 0,
        ResUnitGuid: map['ResUnitGuid']?.toString() ?? '',
        ResId: map['ResId'] ?? 0,
        UnitId: map['UnitId'] ?? 0,
        ResUnitName: map['ResUnitName']?.toString() ?? '',
        ResUnitDesc: map['ResUnitDesc']?.toString() ?? '',
        ResUnitConvAmount: map['ResUnitConvAmount'] ?? 0,
        ResUnitConvTypeId: map['ResUnitConvTypeId'] ?? 0,
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  TblDkResUnit.fromJson(Map<String, dynamic> json)
      : ResUnitId = json['ResUnitId'] ?? 0,
        ResUnitGuid = json['ResUnitGuid']?.toString() ?? '',
        ResId = json['ResId'] ?? 0,
        UnitId = json['UnitId'] ?? 0,
        ResUnitName = json['ResUnitName']?.toString() ?? '',
        ResUnitDesc = json['ResUnitDesc']?.toString() ?? '',
        ResUnitConvAmount = json['ResUnitConvAmount'] ?? 0.0,
        ResUnitConvTypeId = json['ResUnitConvTypeId'] ?? 0,
        CreatedDate = (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate = (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = json['CreatedUId'] ?? 0,
        ModifiedUId = json['ModifiedUId'] ?? 0,
        SyncDateTime = (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        'ResUnitId': ResUnitId,
        'ResUnitGuid': ResUnitGuid,
        'ResId': ResId,
        'UnitId': UnitId,
        'ResUnitName': ResUnitName,
        'ResUnitDesc': ResUnitDesc,
        'ResUnitConvAmount': ResUnitConvAmount,
        'ResUnitConvTypeId': ResUnitConvTypeId,
        'CreatedDate': CreatedDate?.toIso8601String(),
        'ModifiedDate': ModifiedDate?.toIso8601String(),
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.toIso8601String(),
      };

  TblDkResUnit copyWith({
    int? ResUnitId,
    String? ResUnitGuid,
    int? ResId,
    int? UnitId,
    String? ResUnitName,
    String? ResUnitDesc,
    double? ResUnitConvAmount,
    int? ResUnitConvTypeId,
    DateTime? CreatedDate,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
  }) {
    return TblDkResUnit(
      ResUnitId: ResUnitId ?? this.ResUnitId,
      ResUnitGuid: ResUnitGuid ?? this.ResUnitGuid,
      ResId: ResId ?? this.ResId,
      UnitId: UnitId ?? this.UnitId,
      ResUnitName: ResUnitName ?? this.ResUnitName,
      ResUnitDesc: ResUnitDesc ?? this.ResUnitDesc,
      ResUnitConvAmount: ResUnitConvAmount ?? this.ResUnitConvAmount,
      ResUnitConvTypeId: ResUnitConvTypeId ?? this.ResUnitConvTypeId,
      CreatedDate: CreatedDate ?? this.CreatedDate,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }

//endregion Functions
}
