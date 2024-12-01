// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkResPriceGroup extends Model {
  final int ResPriceGroupId;
  final String ResPriceGroupName;
  final String ResPriceGroupDesc;
  final DateTime? SyncDateTime;

  TblDkResPriceGroup({
    required this.ResPriceGroupId,
    required this.ResPriceGroupName,
    required this.ResPriceGroupDesc,
    required this.SyncDateTime,
  });

  @override
  Map<String, dynamic> toMap() => {
        "ResPriceGroupId": ResPriceGroupId,
        "ResPriceGroupName": ResPriceGroupName,
        "ResPriceGroupDesc": ResPriceGroupDesc,
        "SyncDateTime": (SyncDateTime != null) ? SyncDateTime.toString() : null,
      };

  static TblDkResPriceGroup fromMap(Map<String, dynamic> map) {
    return TblDkResPriceGroup(
      ResPriceGroupId: map["ResPriceGroupId"] ?? 0,
      ResPriceGroupName: map["ResPriceGroupName"]?.toString() ?? "",
      ResPriceGroupDesc: map["ResPriceGroupDesc"]?.toString() ?? "",
      SyncDateTime: DateTime.parse(map["SyncDateTime"] ?? '1900-01-01'),
    );
  }

  Map<String, dynamic> toJson() => {
        "ResPriceGroupId": ResPriceGroupId,
        "ResPriceGroupName": ResPriceGroupName,
        "ResPriceGroupDesc": ResPriceGroupDesc,
        "SyncDateTime": SyncDateTime?.toIso8601String(),
      };

  TblDkResPriceGroup.fromJson(Map<String, dynamic> json)
      : ResPriceGroupId = json["ResPriceGroupId"] ?? 0,
        ResPriceGroupName = json["ResPriceGroupName"] ?? '',
        ResPriceGroupDesc = json["ResPriceGroupDesc"] ?? '',
        SyncDateTime = (json["SyncDateTime"] != null) ? DateTime.parse(json["SyncDateTime"]) : null;

  TblDkResPriceGroup copyWith({
    int? ResPriceGroupId,
    String? ResPriceGroupName,
    String? ResPriceGroupDesc,
    DateTime? SyncDateTime,
  }) {
    return TblDkResPriceGroup(
      ResPriceGroupId: ResPriceGroupId ?? this.ResPriceGroupId,
      ResPriceGroupName: ResPriceGroupName ?? this.ResPriceGroupName,
      ResPriceGroupDesc: ResPriceGroupDesc ?? this.ResPriceGroupDesc,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }
}
