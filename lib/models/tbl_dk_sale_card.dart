// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkSaleCard extends Model {
  //region Properties
  final int SaleCardId;
  final String SaleCardGuid;
  final int CId;
  final int DivId;
  final int WpId;
  final int RpAccId;
  final int CurrencyId;
  final int SaleAgrId;
  final int ResPriceGroupId;
  final String SaleCardRegNo;
  final String SaleCardName;
  final String SaleCardDesc;
  final DateTime? SaleCardStartDate;
  final DateTime? SaleCardEndDate;
  final double SaleCardMinSaleAmount;
  final double SaleCardMaxSaleAmount;
  final double SaleCardMinSalePrice;
  final double SaleCardMaxSalePrice;
  final double SaleCardMaxManualDiscPerc;
  final int SaleCardIsPayable;
  final String SaleCardCustName;
  final DateTime? SaleCardCustBirthDate;
  final String SaleCardCustTel;
  final String SaleCardCustEmail;
  final String SaleCardCustAddress;
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
  TblDkSaleCard({
    required this.SaleCardId,
    required this.SaleCardGuid,
    required this.CId,
    required this.DivId,
    required this.WpId,
    required this.RpAccId,
    required this.CurrencyId,
    required this.SaleAgrId,
    required this.ResPriceGroupId,
    required this.SaleCardRegNo,
    required this.SaleCardName,
    required this.SaleCardDesc,
    required this.SaleCardStartDate,
    required this.SaleCardEndDate,
    required this.SaleCardMinSaleAmount,
    required this.SaleCardMaxSaleAmount,
    required this.SaleCardMinSalePrice,
    required this.SaleCardMaxSalePrice,
    required this.SaleCardMaxManualDiscPerc,
    required this.SaleCardIsPayable,
    required this.SaleCardCustName,
    required this.SaleCardCustBirthDate,
    required this.SaleCardCustTel,
    required this.SaleCardCustEmail,
    required this.SaleCardCustAddress,
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
    "SaleCardId": SaleCardId,
    "SaleCardGuid": SaleCardGuid,
    "CId": CId,
    "DivId": DivId,
    "WpId": WpId,
    "RpAccId": RpAccId,
    "CurrencyId": CurrencyId,
    "SaleAgrId": SaleAgrId,
    "ResPriceGroupId": ResPriceGroupId,
    "SaleCardRegNo": SaleCardRegNo,
    "SaleCardName": SaleCardName,
    "SaleCardDesc": SaleCardDesc,
    "SaleCardStartDate": SaleCardStartDate?.millisecondsSinceEpoch,
    "SaleCardEndDate": SaleCardEndDate?.millisecondsSinceEpoch,
    "SaleCardMinSaleAmount": SaleCardMinSaleAmount,
    "SaleCardMaxSaleAmount": SaleCardMaxSaleAmount,
    "SaleCardMinSalePrice": SaleCardMinSalePrice,
    "SaleCardMaxSalePrice": SaleCardMaxSalePrice,
    "SaleCardMaxManualDiscPerc": SaleCardMaxManualDiscPerc,
    "SaleCardIsPayable": SaleCardIsPayable,
    "SaleCardCustName": SaleCardCustName,
    "SaleCardCustBirthDate": SaleCardCustBirthDate?.millisecondsSinceEpoch,
    "SaleCardCustTel": SaleCardCustTel,
    "SaleCardCustEmail": SaleCardCustEmail,
    "SaleCardCustAddress": SaleCardCustAddress,
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

  static TblDkSaleCard fromMap(Map<String, dynamic> map) => TblDkSaleCard(
    SaleCardId: map['SaleCardId'] ?? 0,
    SaleCardGuid: map['SaleCardGuid']?.toString() ?? '',
    CId: map['CId'] ?? 0,
    DivId: map['DivId'] ?? 0,
    WpId: map['WpId'] ?? 0,
    RpAccId: map['RpAccId'] ?? 0,
    CurrencyId: map['CurrencyId'] ?? 0,
    SaleAgrId: map['SaleAgrId'] ?? 0,
    ResPriceGroupId: map['ResPriceGroupId'] ?? 0,
    SaleCardRegNo: map['SaleCardRegNo']?.toString() ?? '',
    SaleCardName: map['SaleCardName']?.toString() ?? '',
    SaleCardDesc: map['SaleCardDesc']?.toString() ?? '',
    SaleCardStartDate: (map['SaleCardStartDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SaleCardStartDate'] ?? 0) : null,
    SaleCardEndDate: (map['SaleCardEndDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SaleCardEndDate'] ?? 0) : null,
    SaleCardMinSaleAmount: map['SaleCardMinSaleAmount'] ?? 0.0,
    SaleCardMaxSaleAmount: map['SaleCardMaxSaleAmount'] ?? 0.0,
    SaleCardMinSalePrice: map['SaleCardMinSalePrice'] ?? 0.0,
    SaleCardMaxSalePrice: map['SaleCardMaxSalePrice'] ?? 0.0,
    SaleCardMaxManualDiscPerc: map['SaleCardMaxManualDiscPerc'] ?? 0.0,
    SaleCardIsPayable: map['SaleCardIsPayable'] ?? 0,
    SaleCardCustName: map['SaleCardCustName']?.toString() ?? '',
    SaleCardCustBirthDate: (map['SaleCardCustBirthDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SaleCardCustBirthDate'] ?? 0) : null,
    SaleCardCustTel: map['SaleCardCustTel']?.toString() ?? '',
    SaleCardCustEmail: map['SaleCardCustEmail']?.toString() ?? '',
    SaleCardCustAddress: map['SaleCardCustAddress']?.toString() ?? '',
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

  Map<String, dynamic> toJson() => {
    'SaleCardId': SaleCardId,
    'SaleCardGuid': SaleCardGuid,
    'CId': CId,
    'DivId': DivId,
    'WpId': WpId,
    'RpAccId': RpAccId,
    'CurrencyId': CurrencyId,
    'SaleAgrId': SaleAgrId,
    'ResPriceGroupId': ResPriceGroupId,
    'SaleCardRegNo': SaleCardRegNo,
    'SaleCardName': SaleCardName,
    'SaleCardDesc': SaleCardDesc,
    'SaleCardStartDate': SaleCardStartDate?.toIso8601String(),
    'SaleCardEndDate': SaleCardEndDate?.toIso8601String(),
    'SaleCardMinSaleAmount': SaleCardMinSaleAmount,
    'SaleCardMaxSaleAmount': SaleCardMaxSaleAmount,
    'SaleCardMinSalePrice': SaleCardMinSalePrice,
    'SaleCardMaxSalePrice': SaleCardMaxSalePrice,
    'SaleCardMaxManualDiscPerc': SaleCardMaxManualDiscPerc,
    'SaleCardIsPayable': SaleCardIsPayable,
    'SaleCardCustName': SaleCardCustName,
    'SaleCardCustBirthDate': SaleCardCustBirthDate?.toIso8601String(),
    'SaleCardCustTel': SaleCardCustTel,
    'SaleCardCustEmail': SaleCardCustEmail,
    'SaleCardCustAddress': SaleCardCustAddress,
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

  TblDkSaleCard.fromJson(Map<String, dynamic> json)
      : SaleCardId = json['SaleCardId'] ?? 0,
        SaleCardGuid = json['SaleCardGuid']?.toString() ?? '',
        CId = json['CId'] ?? 0,
        DivId = json['DivId'] ?? 0,
        WpId = json['WpId'] ?? 0,
        RpAccId = json['RpAccId'] ?? 0,
        CurrencyId = json['CurrencyId'] ?? 0,
        SaleAgrId = json['SaleAgrId'] ?? 0,
        ResPriceGroupId = json['ResPriceGroupId'] ?? 0,
        SaleCardRegNo = json['SaleCardRegNo']?.toString() ?? '',
        SaleCardName = json['SaleCardName']?.toString() ?? '',
        SaleCardDesc = json['SaleCardDesc']?.toString() ?? '',
        SaleCardStartDate = (json['SaleCardStartDate'] != null) ? DateTime.parse(json['SaleCardStartDate']) : null,
        SaleCardEndDate = (json['SaleCardEndDate'] != null) ? DateTime.parse(json['SaleCardEndDate']) : null,
        SaleCardMinSaleAmount = json['SaleCardMinSaleAmount'] ?? 0.0,
        SaleCardMaxSaleAmount = json['SaleCardMaxSaleAmount'] ?? 0.0,
        SaleCardMinSalePrice = json['SaleCardMinSalePrice'] ?? 0.0,
        SaleCardMaxSalePrice = json['SaleCardMaxSalePrice'] ?? 0.0,
        SaleCardMaxManualDiscPerc = json['SaleCardMaxManualDiscPerc'] ?? 0.0,
        SaleCardIsPayable = json['SaleCardIsPayable'] ?? 0,
        SaleCardCustName = json['SaleCardCustName']?.toString() ?? '',
        SaleCardCustBirthDate = (json['SaleCardCustBirthDate'] != null) ? DateTime.parse(json['SaleCardCustBirthDate']) : null,
        SaleCardCustTel = json['SaleCardCustTel']?.toString() ?? '',
        SaleCardCustEmail = json['SaleCardCustEmail']?.toString() ?? '',
        SaleCardCustAddress = json['SaleCardCustAddress']?.toString() ?? '',
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

  //endregion Functions
}