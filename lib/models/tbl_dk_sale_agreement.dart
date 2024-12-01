// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkSaleAgreement extends Model {
  //region Properties
  final int SaleAgrId;
  final String SaleAgrGuid;
  final int CurrencyId;
  final String SaleAgrName;
  final String SaleAgrDesc;
  final double SaleAgrMinOrderPrice;
  final double SaleAgrDiscPerc;
  final double SaleAgrMaxDiscPerc;
  final double SaleAgrTaxPerc;
  final double SaleAgrTaxAmount;
  final int SaleAgrUseOwnPriceList;
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
  TblDkSaleAgreement({
    required this.SaleAgrId,
    required this.SaleAgrGuid,
    required this.CurrencyId,
    required this.SaleAgrName,
    required this.SaleAgrDesc,
    required this.SaleAgrMinOrderPrice,
    required this.SaleAgrDiscPerc,
    required this.SaleAgrMaxDiscPerc,
    required this.SaleAgrTaxPerc,
    required this.SaleAgrTaxAmount,
    required this.SaleAgrUseOwnPriceList,
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
        "SaleAgrId": SaleAgrId,
        "SaleAgrGuid": SaleAgrGuid,
        "CurrencyId": CurrencyId,
        "SaleAgrName": SaleAgrName,
        "SaleAgrDesc": SaleAgrDesc,
        "SaleAgrMinOrderPrice": SaleAgrMinOrderPrice,
        "SaleAgrDiscPerc": SaleAgrDiscPerc,
        "SaleAgrMaxDiscPerc": SaleAgrMaxDiscPerc,
        "SaleAgrTaxPerc": SaleAgrTaxPerc,
        "SaleAgrTaxAmount": SaleAgrTaxAmount,
        "SaleAgrUseOwnPriceList": SaleAgrUseOwnPriceList,
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

  static TblDkSaleAgreement fromMap(Map<String, dynamic> map) => TblDkSaleAgreement(
        SaleAgrId: map['SaleAgrId'] ?? 0,
        SaleAgrGuid: map['SaleAgrGuid']?.toString() ?? '',
        CurrencyId: map['CurrencyId'] ?? 0,
        SaleAgrName: map['SaleAgrName']?.toString() ?? '',
        SaleAgrDesc: map['SaleAgrDesc']?.toString() ?? '',
        SaleAgrMinOrderPrice: map['SaleAgrMinOrderPrice'] ?? 0.0,
        SaleAgrDiscPerc: map['SaleAgrDiscPerc'] ?? 0.0,
        SaleAgrMaxDiscPerc: map['SaleAgrMaxDiscPerc'] ?? 0.0,
        SaleAgrTaxPerc: map['SaleAgrTaxPerc'] ?? 0.0,
        SaleAgrTaxAmount: map['SaleAgrTaxAmount'] ?? 0.0,
        SaleAgrUseOwnPriceList: map['SaleAgrUseOwnPriceList'] ?? 0,
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

  TblDkSaleAgreement.fromJson(Map<String, dynamic> json)
      : SaleAgrId = json['SaleAgrId'] ?? 0,
        SaleAgrGuid = json['SaleAgrGuid']?.toString() ?? '',
        CurrencyId = json['CurrencyId'] ?? 0,
        SaleAgrName = json['SaleAgrName']?.toString() ?? '',
        SaleAgrDesc = json['SaleAgrDesc']?.toString() ?? '',
        SaleAgrMinOrderPrice = json['SaleAgrMinOrderPrice'] ?? 0.0,
        SaleAgrDiscPerc = json['SaleAgrDiscPerc'] ?? 0.0,
        SaleAgrMaxDiscPerc = json['SaleAgrMaxDiscPerc'] ?? 0.0,
        SaleAgrTaxPerc = json['SaleAgrTaxPerc'] ?? 0.0,
        SaleAgrTaxAmount = json['SaleAgrTaxAmount'] ?? 0.0,
        SaleAgrUseOwnPriceList = json['SaleAgrUseOwnPriceList'] ?? 0,
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
        'SaleAgrId': SaleAgrId,
        'SaleAgrGuid': SaleAgrGuid,
        'CurrencyId': CurrencyId,
        'SaleAgrName': SaleAgrName,
        'SaleAgrDesc': SaleAgrDesc,
        'SaleAgrMinOrderPrice': SaleAgrMinOrderPrice,
        'SaleAgrDiscPerc': SaleAgrDiscPerc,
        'SaleAgrMaxDiscPerc': SaleAgrMaxDiscPerc,
        'SaleAgrTaxPerc': SaleAgrTaxPerc,
        'SaleAgrTaxAmount': SaleAgrTaxAmount,
        'SaleAgrUseOwnPriceList': SaleAgrUseOwnPriceList,
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

  TblDkSaleAgreement copyWith({
    int? SaleAgrId,
    String? SaleAgrGuid,
    int? CurrencyId,
    String? SaleAgrName,
    String? SaleAgrDesc,
    double? SaleAgrMinOrderPrice,
    double? SaleAgrDiscPerc,
    double? SaleAgrMaxDiscPerc,
    double? SaleAgrTaxPerc,
    double? SaleAgrTaxAmount,
    int? SaleAgrUseOwnPriceList,
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
    return TblDkSaleAgreement(
      SaleAgrId: SaleAgrId ?? this.SaleAgrId,
      SaleAgrGuid: SaleAgrGuid ?? this.SaleAgrGuid,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      SaleAgrName: SaleAgrName ?? this.SaleAgrName,
      SaleAgrDesc: SaleAgrDesc ?? this.SaleAgrDesc,
      SaleAgrMinOrderPrice: SaleAgrMinOrderPrice ?? this.SaleAgrMinOrderPrice,
      SaleAgrDiscPerc: SaleAgrDiscPerc ?? this.SaleAgrDiscPerc,
      SaleAgrMaxDiscPerc: SaleAgrMaxDiscPerc ?? this.SaleAgrMaxDiscPerc,
      SaleAgrTaxPerc: SaleAgrTaxPerc ?? this.SaleAgrTaxPerc,
      SaleAgrTaxAmount: SaleAgrTaxAmount ?? this.SaleAgrTaxAmount,
      SaleAgrUseOwnPriceList: SaleAgrUseOwnPriceList ?? this.SaleAgrUseOwnPriceList,
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
