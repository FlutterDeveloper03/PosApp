// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkInvType extends Model {
  //region Properties
  final int InvTypeId;
  final String InvTypeGuid;
  final String InvTypeName_tkTM;
  final String InvTypeDesc_tkTM;
  final String InvTypeName_ruRU;
  final String InvTypeDesc_ruRU;
  final String InvTypeName_enUS;
  final String InvTypeDesc_enUS;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkInvType({
    required this.InvTypeId,
    required this.InvTypeGuid,
    required this.InvTypeName_tkTM,
    required this.InvTypeDesc_tkTM,
    required this.InvTypeName_ruRU,
    required this.InvTypeDesc_ruRU,
    required this.InvTypeName_enUS,
    required this.InvTypeDesc_enUS,
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
        "InvTypeId": InvTypeId,
        "InvTypeGuid": InvTypeGuid,
        "InvTypeName_tkTM": InvTypeName_tkTM,
        "InvTypeDesc_tkTM": InvTypeDesc_tkTM,
        "InvTypeName_ruRU": InvTypeName_ruRU,
        "InvTypeDesc_ruRU": InvTypeDesc_ruRU,
        "InvTypeName_enUS": InvTypeName_enUS,
        "InvTypeDesc_enUS": InvTypeDesc_enUS,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkInvType fromMap(Map<String, dynamic> map) => TblDkInvType(
        InvTypeId: map['InvTypeId'] ?? 0,
        InvTypeGuid: map['InvTypeGuid']?.toString() ?? '',
        InvTypeName_tkTM: map['InvTypeName_tkTM']?.toString() ?? '',
        InvTypeDesc_tkTM: map['InvTypeDesc_tkTM']?.toString() ?? '',
        InvTypeName_ruRU: map['InvTypeName_ruRU']?.toString() ?? '',
        InvTypeDesc_ruRU: map['InvTypeDesc_ruRU']?.toString() ?? '',
        InvTypeName_enUS: map['InvTypeName_enUS']?.toString() ?? '',
        InvTypeDesc_enUS: map['InvTypeDesc_enUS']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  TblDkInvType.fromJson(Map<String, dynamic> json)
      : InvTypeId = json['InvTypeId'] ?? 0,
        InvTypeGuid = json['InvTypeGuid']?.toString() ?? '',
        InvTypeName_tkTM = json['InvTypeName_tkTM']?.toString() ?? '',
        InvTypeDesc_tkTM = json['InvTypeDesc_tkTM']?.toString() ?? '',
        InvTypeName_ruRU = json['InvTypeName_ruRU']?.toString() ?? '',
        InvTypeDesc_ruRU = json['InvTypeDesc_ruRU']?.toString() ?? '',
        InvTypeName_enUS = json['InvTypeName_enUS']?.toString() ?? '',
        InvTypeDesc_enUS = json['InvTypeDesc_enUS']?.toString() ?? '',
        CreatedDate = (json['CreatedDate']!=null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate = (json['ModifiedDate']!=null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = json['CreatedUId'] ?? 0,
        ModifiedUId = json['ModifiedUId'] ?? 0,
        SyncDateTime = (json['SyncDateTime']!=null) ? DateTime.parse(json['SyncDateTime']) : null;

//SyncDateTime =(json['SyncDateTime']!=null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        //'BaseOs':BaseOs,
        'InvTypeId': InvTypeId,
        'InvTypeGuid': InvTypeGuid,
        'InvTypeName_tkTM': InvTypeName_tkTM,
        'InvTypeDesc_tkTM': InvTypeDesc_tkTM,
        'InvTypeName_ruRU': InvTypeName_ruRU,
        'InvTypeDesc_ruRU': InvTypeDesc_ruRU,
        'InvTypeName_enUS': InvTypeName_enUS,
        'InvTypeDesc_enUS': InvTypeDesc_enUS,
        'CreatedDate': CreatedDate?.toIso8601String(),
        'ModifiedDate': ModifiedDate?.toIso8601String(),
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.toIso8601String(),
      };

  TblDkInvType copyWith({
    int? InvTypeId,
    String? InvTypeGuid,
    String? InvTypeName_tkTM,
    String? InvTypeDesc_tkTM,
    String? InvTypeName_ruRU,
    String? InvTypeDesc_ruRU,
    String? InvTypeName_enUS,
    String? InvTypeDesc_enUS,
    DateTime? CreatedDate,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
  }) {
    return TblDkInvType(
      InvTypeId: InvTypeId ?? this.InvTypeId,
      InvTypeGuid: InvTypeGuid ?? this.InvTypeGuid,
      InvTypeName_tkTM: InvTypeName_tkTM ?? this.InvTypeName_tkTM,
      InvTypeDesc_tkTM: InvTypeDesc_tkTM ?? this.InvTypeDesc_tkTM,
      InvTypeName_ruRU: InvTypeName_ruRU ?? this.InvTypeName_ruRU,
      InvTypeDesc_ruRU: InvTypeDesc_ruRU ?? this.InvTypeDesc_ruRU,
      InvTypeName_enUS: InvTypeName_enUS ?? this.InvTypeName_enUS,
      InvTypeDesc_enUS: InvTypeDesc_enUS ?? this.InvTypeDesc_enUS,
      CreatedDate: CreatedDate ?? this.CreatedDate,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }

//endregion Functions
}
