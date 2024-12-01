// ignore_for_file: non_constant_identifier_names

import 'model.dart';

class TblDkResCategory extends Model {
  final int ResCatId;
  final int CatTypeId;
  final String CatTypeGuid;
  final int ResOwnerCatId;
  final int ResCatVisibleIndex;
  final int IsMain;
  final String ResCatName;
  final String ResCatNameTm;
  final String ResCatNameRu;
  final String ResCatNameEn;
  final String ResCatDesc;
  final String ResCatIconName;
  final String ResCatIconFilePath;
  final DateTime? SyncDateTime;

  TblDkResCategory({
    required this.ResCatId,
    required this.CatTypeId,
    required this.CatTypeGuid,
    required this.ResOwnerCatId,
    required this.ResCatVisibleIndex,
    required this.IsMain,
    required this.ResCatName,
    required this.ResCatNameTm,
    required this.ResCatNameRu,
    required this.ResCatNameEn,
    required this.ResCatDesc,
    required this.ResCatIconName,
    required this.ResCatIconFilePath,
    required this.SyncDateTime,
  });

  @override
  Map<String, dynamic> toMap() => {
        'ResCatId': ResCatId,
    'CatTypeId':CatTypeId,
    'CatTypeGuid':CatTypeGuid,
        'ResOwnerCatId': ResOwnerCatId,
        'ResCatVisibleIndex': ResCatVisibleIndex,
        'IsMain': IsMain,
        'ResCatName': ResCatName,
        'ResCatNameTm': ResCatNameTm,
        'ResCatNameRu': ResCatNameRu,
        'ResCatNameEn': ResCatNameEn,
        'ResCatDesc': ResCatDesc,
        'ResCatIconName': ResCatIconName,
        'ResCatIconFilePath': ResCatIconFilePath,
        'SyncDateTime': SyncDateTime.toString(),
      };

  static TblDkResCategory fromMap(Map<String, dynamic> map) => TblDkResCategory(
      ResCatId: map['ResCatId'] ?? 0,
      CatTypeId : map['CatTypeId'] ?? 0,
      CatTypeGuid : map['CatTypeGuid'] ?? '',
      ResOwnerCatId: map['ResOwnerCatId'] ?? 0,
      ResCatVisibleIndex: map['ResCatVisibleIndex'] ?? 0,
      IsMain: map['IsMain'] ?? 0,
      ResCatName: map['ResCatName']?.toString() ?? "",
      ResCatNameTm: map['ResCatNameTm']?.toString() ?? "",
      ResCatNameRu: map['ResCatNameRu']?.toString() ?? "",
      ResCatNameEn: map['ResCatNameEn']?.toString() ?? "",
      ResCatDesc: map['ResCatDesc']?.toString() ?? "",
      ResCatIconName: map['ResCatIconName']?.toString() ?? "",
      ResCatIconFilePath: map['ResCatIconFilePath']?.toString() ?? "",
      SyncDateTime: DateTime.parse(map['SyncDateTime'] ?? '1900-01-01'));

  TblDkResCategory.fromJson(Map<String, dynamic> json)
      : ResCatId = json['ResCatId'] ?? 0,
        CatTypeId = json['CatTypeId'] ?? 0,
        CatTypeGuid = json['CatTypeGuid'] ?? '',
        ResOwnerCatId = json['ResOwnerCatId'] ?? 0,
        ResCatVisibleIndex = json['ResCatVisibleIndex'] ?? 0,
        IsMain = json['IsMain'] ?? 0,
        ResCatName = json['ResCatName'] ?? "",
        ResCatNameTm = json['ResCatNameTm'] ?? "",
        ResCatNameRu = json['ResCatNameRu'] ?? "",
        ResCatNameEn = json['ResCatNameEn'] ?? "",
        ResCatDesc = json['ResCatDesc'] ?? "",
        ResCatIconName = json['ResCatIconName'] ?? "",
        ResCatIconFilePath = json['ResCatIconFilePath'] ?? "",
        SyncDateTime = DateTime.parse(json['SyncDateTime'] ?? '1900-01-01');

  TblDkResCategory copyWith({
    int? ResOwnerCatId,
    int? CatTypeId,
    String? CatTypeGuid,
    int? ResCatVisibleIndex,
    int? IsMain,
    String? ResCatName,
    String? ResCatNameTm,
    String? ResCatNameRu,
    String? ResCatNameEn,
    String? ResCatDesc,
    String? ResCatIconName,
    String? ResCatIconFilePath,
  }) {
    return TblDkResCategory(
        ResCatId: ResCatId,
        CatTypeId : CatTypeId ?? this.CatTypeId,
        CatTypeGuid : CatTypeGuid ?? this.CatTypeGuid,
        ResOwnerCatId: ResOwnerCatId ?? this.ResOwnerCatId,
        ResCatVisibleIndex: ResCatVisibleIndex ?? this.ResCatVisibleIndex,
        IsMain: IsMain ?? this.IsMain,
        ResCatName: ResCatName ?? this.ResCatName,
        ResCatNameTm: ResCatNameTm ?? this.ResCatNameTm,
        ResCatNameRu: ResCatNameRu ?? this.ResCatNameRu,
        ResCatNameEn: ResCatNameEn ?? this.ResCatNameEn,
        ResCatDesc: ResCatDesc ?? this.ResCatDesc,
        ResCatIconName: ResCatIconName ?? this.ResCatIconName,
        ResCatIconFilePath: ResCatIconFilePath ?? this.ResCatIconFilePath,
        SyncDateTime: SyncDateTime);
  }
}
