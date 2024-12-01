// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:pos_app/models/model.dart';
import 'package:pos_app/models/tbl_mg_mat_attributes.dart';

class TblDkCartItem extends Model {
  final int ResId;
  final String ResName;
  final String ResNameTm;
  final String ResNameRu;
  final String ResNameEn;
  int ItemCount;
  final int ResPriceGroupId;
  final double ResPriceValue;
  double ItemPriceTotal;
  final DateTime? SyncDateTime;
  final int RpAccId;
  final int TableId;
  final String ImageFilePath;
  List<TblMgMatAttributes> matAttributes;

  TblDkCartItem(
      {required this.ResId,
      required this.ResName,
      required this.ResNameTm,
      required this.ResNameRu,
      required this.ResNameEn,
      required this.ItemCount,
      required this.ResPriceGroupId,
      required this.ResPriceValue,
      required this.ItemPriceTotal,
      required this.SyncDateTime,
      required this.RpAccId,
      required this.TableId,
      required this.ImageFilePath,
      required this.matAttributes});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'ResId': ResId,
      'ResName': ResName,
      'ResNameTm': ResNameTm,
      'ResNameRu': ResNameRu,
      'ResNameEn': ResNameEn,
      'ItemCount': ItemCount,
      'ResPriceGroupId': ResPriceGroupId,
      'ResPriceValue': ResPriceValue,
      'ItemPriceTotal': ItemPriceTotal,
      'SyncDateTime': SyncDateTime,
      'RpAccId': RpAccId,
      'TableId': TableId,
      'ImageFilePath': ImageFilePath,
      'MatAttributes': jsonEncode(matAttributes.map((e) => e.toMap()).toList())
    };
    return map;
  }

  static TblDkCartItem fromMap(Map<String, dynamic> map) {
    return TblDkCartItem(
        ResId: map['ResId'] ?? 0,
        ResName: map['ResName']?.toString() ?? "",
        ResNameTm: map['ResNameTm']?.toString() ?? "",
        ResNameRu: map['ResNameRu']?.toString() ?? "",
        ResNameEn: map['ResNameEn']?.toString() ?? "",
        ItemCount: map['ItemCount'] ?? 0,
        ResPriceGroupId: map['ResPriceGroupId'] ?? 0,
        ResPriceValue: map['ResPriceValue'] ?? 0,
        ItemPriceTotal: map['ItemPriceTotal'] ?? 0,
        SyncDateTime: map['SyncDateTime'],
        RpAccId: map['RpAccId'] ?? 0,
        TableId: map['TableId'] ?? 0,
        ImageFilePath: map['ImageFilePath'] ?? '',
        matAttributes: map['MatAttributes'] != null
          ? (jsonDecode(map['MatAttributes']) as List)
          .map((e) => TblMgMatAttributes.fromMap(e))
          .toList()
          : [],
    );
  }

  TblDkCartItem copyWith({
    int? ResId,
    String? ResName,
    String? ResNameTm,
    String? ResNameRu,
    String? ResNameEn,
    int? ItemCount,
    int? ResPriceGroupId,
    double? ResPriceValue,
    double? ItemPriceTotal,
    DateTime? SyncDateTime,
    int? RpAccId,
    int? TableId,
    String? ImageFilePath,
    List<TblMgMatAttributes>? matAttributes
  }) {
    return TblDkCartItem(
        ResId:ResId ?? this.ResId,
        ResName:ResName ?? this.ResName,
        ResNameTm:ResNameTm ?? this.ResName,
        ResNameRu:ResNameRu ?? this.ResName,
        ResNameEn:ResNameEn ?? this.ResName,
        ItemCount:ItemCount ?? this.ItemCount,
        ResPriceGroupId:ResPriceGroupId ?? this.ResPriceGroupId,
        ResPriceValue:ResPriceValue ?? this.ResPriceValue,
        ItemPriceTotal:ItemPriceTotal ?? this.ItemPriceTotal,
        SyncDateTime: SyncDateTime ?? this.SyncDateTime,
        RpAccId: RpAccId ?? this.RpAccId,
        TableId: TableId ?? this.TableId,
        ImageFilePath: ImageFilePath ?? this.ImageFilePath,
        matAttributes: matAttributes ?? this.matAttributes
    );
  }
}
