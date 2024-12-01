// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkCurrency extends Model {
  //region Properties
  final int CurrencyId;
  final String CurrencyGuid;
  final String CurrencyName_tkTM;
  final String CurrencyDesc_tkTM;
  final String CurrencyName_ruRU;
  final String CurrencyDesc_ruRU;
  final String CurrencyName_enUS;
  final String CurrencyDesc_enUS;
  final String CurrencyCode;
  final String CurrencyNumCode;
  final String CurrencySymbol;
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

  //region Constructor
  TblDkCurrency({
    required this.CurrencyId,
    required this.CurrencyGuid,
    required this.CurrencyName_tkTM,
    required this.CurrencyDesc_tkTM,
    required this.CurrencyName_ruRU,
    required this.CurrencyDesc_ruRU,
    required this.CurrencyName_enUS,
    required this.CurrencyDesc_enUS,
    required this.CurrencyCode,
    required this.CurrencyNumCode,
    required this.CurrencySymbol,
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

//endregion Constructor

//region Functions
  @override
  Map<String, dynamic> toMap() => {
        //"CId":CId,
        "CurrencyId": CurrencyId,
        "CurrencyGuid": CurrencyGuid,
        "CurrencyName_tkTM": CurrencyName_tkTM,
        "CurrencyDesc_tkTM": CurrencyDesc_tkTM,
        "CurrencyName_ruRU": CurrencyName_ruRU,
        "CurrencyDesc_ruRU": CurrencyDesc_ruRU,
        "CurrencyName_enUS": CurrencyName_enUS,
        "CurrencyDesc_enUS": CurrencyDesc_enUS,
        "CurrencyCode": CurrencyCode,
        "CurrencyNumCode": CurrencyNumCode,
        "CurrencySymbol": CurrencySymbol,
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

  static TblDkCurrency fromMap(Map<String, dynamic> map) => TblDkCurrency(
        CurrencyId: map['CurrencyId'] ?? 0,
        CurrencyGuid: map['CurrencyGuid']?.toString() ?? '',
        CurrencyName_tkTM: map['CurrencyName_tkTM']?.toString() ?? '',
        CurrencyDesc_tkTM: map['CurrencyDesc_tkTM']?.toString() ?? '',
        CurrencyName_ruRU: map['CurrencyName_ruRU']?.toString() ?? '',
        CurrencyDesc_ruRU: map['CurrencyDesc_ruRU']?.toString() ?? '',
        CurrencyName_enUS: map['CurrencyName_enUS']?.toString() ?? '',
        CurrencyDesc_enUS: map['CurrencyDesc_enUS']?.toString() ?? '',
        CurrencyCode: map['CurrencyCode']?.toString() ?? '',
        CurrencyNumCode: map['CurrencyNumCode']?.toString() ?? '',
        CurrencySymbol: map['CurrencySymbol']?.toString() ?? '',
        AddInf1: map['AddInf1']?.toString() ?? '',
        AddInf2: map['AddInf2']?.toString() ?? '',
        AddInf3: map['AddInf3']?.toString() ?? '',
        AddInf4: map['AddInf4']?.toString() ?? '',
        AddInf5: map['AddInf5']?.toString() ?? '',
        AddInf6: map['AddInf6']?.toString() ?? '',
        AddInf7: map['AddInf7']?.toString() ?? '',
        AddInf8: map['AddInf8']?.toString() ?? '',
        AddInf9: map['AddInf9']?.toString() ?? '',
        AddInf10: map['AddInf10']?.toString() ?? '',
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate'] ?? 0) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  TblDkCurrency.fromJson(Map<String, dynamic> json)
      : CurrencyId = json['CurrencyId'] ?? 0,
        CurrencyGuid = json['CurrencyGuid']?.toString() ?? '',
        CurrencyName_tkTM = json['CurrencyName_tkTM']?.toString() ?? '',
        CurrencyDesc_tkTM = json['CurrencyDesc_tkTM']?.toString() ?? '',
        CurrencyName_ruRU = json['CurrencyName_ruRU']?.toString() ?? '',
        CurrencyDesc_ruRU = json['CurrencyDesc_ruRU']?.toString() ?? '',
        CurrencyName_enUS = json['CurrencyName_enUS']?.toString() ?? '',
        CurrencyDesc_enUS = json['CurrencyDesc_enUS']?.toString() ?? '',
        CurrencyCode = json['CurrencyCode']?.toString() ?? '',
        CurrencyNumCode = json['CurrencyNumCode']?.toString() ?? '',
        CurrencySymbol = json['CurrencySymbol']?.toString() ?? '',
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
        CreatedDate = (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate = (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = json['CreatedUId'] ?? 0,
        ModifiedUId = json['ModifiedUId'] ?? 0,
        SyncDateTime = (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        'CurrencyId': CurrencyId,
        'CurrencyGuid': CurrencyGuid,
        'CurrencyName_tkTM': CurrencyName_tkTM,
        'CurrencyDesc_tkTM': CurrencyDesc_tkTM,
        'CurrencyName_ruRU': CurrencyName_ruRU,
        'CurrencyDesc_ruRU': CurrencyDesc_ruRU,
        'CurrencyName_enUS': CurrencyName_enUS,
        'CurrencyDesc_enUS': CurrencyDesc_enUS,
        'CurrencyCode': CurrencyCode,
        'CurrencyNumCode': CurrencyNumCode,
        'CurrencySymbol': CurrencySymbol,
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
        'CreatedDate': CreatedDate?.toIso8601String(),
        'ModifiedDate': ModifiedDate?.toIso8601String(),
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.toIso8601String(),
      };

  TblDkCurrency copyWith({
    int? CurrencyId,
    String? CurrencyGuid,
    String? CurrencyName_tkTM,
    String? CurrencyDesc_tkTM,
    String? CurrencyName_ruRU,
    String? CurrencyDesc_ruRU,
    String? CurrencyName_enUS,
    String? CurrencyDesc_enUS,
    String? CurrencyCode,
    String? CurrencyNumCode,
    String? CurrencySymbol,
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
    return TblDkCurrency(
      CurrencyId: CurrencyId ?? this.CurrencyId,
      CurrencyGuid: CurrencyGuid ?? this.CurrencyGuid,
      CurrencyName_tkTM: CurrencyName_tkTM ?? this.CurrencyName_tkTM,
      CurrencyDesc_tkTM: CurrencyDesc_tkTM ?? this.CurrencyDesc_tkTM,
      CurrencyName_ruRU: CurrencyName_ruRU ?? this.CurrencyName_ruRU,
      CurrencyDesc_ruRU: CurrencyDesc_ruRU ?? this.CurrencyDesc_ruRU,
      CurrencyName_enUS: CurrencyName_enUS ?? this.CurrencyName_enUS,
      CurrencyDesc_enUS: CurrencyDesc_enUS ?? this.CurrencyDesc_enUS,
      CurrencyCode: CurrencyCode ?? this.CurrencyCode,
      CurrencyNumCode: CurrencyNumCode ?? this.CurrencyNumCode,
      CurrencySymbol: CurrencySymbol ?? this.CurrencySymbol,
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

//endregion Functions
}
