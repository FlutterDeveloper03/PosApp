// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkInvoice extends Model {
  //region Properties
  final int InvId;
  final int InvTypeId;
  final int PtId;
  final int PmId;
  final int InvStatId;
  final int CurrencyId;
  final int RpAccId;
  final int CId;
  final int DivId;
  final int WhId;
  final int WpId;
  final int EmpId;
  final int UId;
  final String InvGuid;
  final String InvRegNo;
  final String InvDesc;
  final DateTime? InvDate;
  final double InvTotal;
  final double InvExpenseAmount;
  final double InvTaxAmount;
  final double InvDiscountAmount;
  final double InvFTotal;
  final String InvFTotalInWrite;
  final int InvModifyCount;
  final int InvPrintCount;
  final int InvCreditDays;
  final String InvCreditDesc;
  final double InvLatitude;
  final double InvLongitude;
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
  TblDkInvoice({
    required this.InvId,
    required this.InvTypeId,
    required this.PtId,
    required this.PmId,
    required this.InvStatId,
    required this.CurrencyId,
    required this.RpAccId,
    required this.CId,
    required this.DivId,
    required this.WhId,
    required this.WpId,
    required this.EmpId,
    required this.UId,
    required this.InvGuid,
    required this.InvRegNo,
    required this.InvDesc,
    required this.InvDate,
    required this.InvTotal,
    required this.InvExpenseAmount,
    required this.InvTaxAmount,
    required this.InvDiscountAmount,
    required this.InvFTotal,
    required this.InvFTotalInWrite,
    required this.InvModifyCount,
    required this.InvPrintCount,
    required this.InvCreditDays,
    required this.InvCreditDesc,
    required this.InvLatitude,
    required this.InvLongitude,
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
        "InvId": InvId,
        "InvTypeId": InvTypeId,
        "PtId": PtId,
        "PmId": PmId,
        "InvStatId": InvStatId,
        "CurrencyId": CurrencyId,
        "RpAccId": RpAccId,
        "CId": CId,
        "DivId": DivId,
        "WhId": WhId,
        "WpId": WpId,
        "EmpId": EmpId,
        "UId": UId,
        "InvGuid": InvGuid,
        "InvRegNo": InvRegNo,
        "InvDesc": InvDesc,
        "InvDate": InvDate?.millisecondsSinceEpoch,
        "InvTotal": InvTotal,
        "InvExpenseAmount": InvExpenseAmount,
        "InvTaxAmount": InvTaxAmount,
        "InvDiscountAmount": InvDiscountAmount,
        "InvFTotal": InvFTotal,
        "InvFTotalInWrite": InvFTotalInWrite,
        "InvModifyCount": InvModifyCount,
        "InvPrintCount": InvPrintCount,
        "InvCreditDays": InvCreditDays,
        "InvCreditDesc": InvCreditDesc,
        "InvLatitude": InvLatitude,
        "InvLongitude": InvLongitude,
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

  static TblDkInvoice fromMap(Map<String, dynamic> map) => TblDkInvoice(
        InvId: map['InvId'] ?? 0,
        InvTypeId: map['InvTypeId'] ?? 0,
        PtId: map['PtId'] ?? 0,
        PmId: map['PmId'] ?? 0,
        InvStatId: map['InvStatId'] ?? 0,
        CurrencyId: map['CurrencyId'] ?? 0,
        RpAccId: map['RpAccId'] ?? 0,
        CId: map['CId'] ?? 0,
        DivId: map['DivId'] ?? 0,
        WhId: map['WhId'] ?? 0,
        WpId: map['WpId'] ?? 0,
        EmpId: map['EmpId'] ?? 0,
        UId: map['UId'] ?? 0,
        InvGuid: map['InvGuid']?.toString() ?? '',
        InvRegNo: map['InvRegNo']?.toString() ?? '',
        InvDesc: map['InvDesc']?.toString() ?? '',
        InvDate: (map['InvDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['InvDate'] ?? 0) : null,
        InvTotal: map['InvTotal'] ?? 0.0,
        InvExpenseAmount: map['InvExpenseAmount'] ?? 0.0,
        InvTaxAmount: map['InvTaxAmount'] ?? 0.0,
        InvDiscountAmount: map['InvDiscountAmount'] ?? 0.0,
        InvFTotal: map['InvFTotal'] ?? 0.0,
        InvFTotalInWrite: map['InvFTotalInWrite']?.toString() ?? '',
        InvModifyCount: map['InvModifyCount'] ?? 0,
        InvPrintCount: map['InvPrintCount'] ?? 0,
        InvCreditDays: map['InvCreditDays'] ?? 0,
        InvCreditDesc: map['InvCreditDesc']?.toString() ?? '',
        InvLatitude: map['InvLatitude'] ?? 0.0,
        InvLongitude: map['InvLongitude'] ?? 0.0,
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

  TblDkInvoice.fromJson(Map<String, dynamic> json)
      : InvId = json['InvId'] ?? 0,
        InvTypeId = json['InvTypeId'] ?? 0,
        PtId = json['PtId'] ?? 0,
        PmId = json['PmId'] ?? 0,
        InvStatId = json['InvStatId'] ?? 0,
        CurrencyId = json['CurrencyId'] ?? 0,
        RpAccId = json['RpAccId'] ?? 0,
        CId = json['CId'] ?? 0,
        DivId = json['DivId'] ?? 0,
        WhId = json['WhId'] ?? 0,
        WpId = json['WpId'] ?? 0,
        EmpId = json['EmpId'] ?? 0,
        UId = json['UId'] ?? 0,
        InvGuid = json['InvGuid']?.toString() ?? '',
        InvRegNo = json['InvRegNo']?.toString() ?? '',
        InvDesc = json['InvDesc']?.toString() ?? '',
        InvDate = (json['InvDate'] != null) ? DateTime.parse(json['InvDate']) : null,
        InvTotal = json['InvTotal'] ?? 0.0,
        InvExpenseAmount = json['InvExpenseAmount'] ?? 0.0,
        InvTaxAmount = json['InvTaxAmount'] ?? 0.0,
        InvDiscountAmount = json['InvDiscountAmount'] ?? 0.0,
        InvFTotal = json['InvFTotal'] ?? 0.0,
        InvFTotalInWrite = json['InvFTotalInWrite']?.toString() ?? '',
        InvModifyCount = json['InvModifyCount'] ?? 0,
        InvPrintCount = json['InvPrintCount'] ?? 0,
        InvCreditDays = json['InvCreditDays'] ?? 0,
        InvCreditDesc = json['InvCreditDesc'] ?? '',
        InvLatitude = json['InvLatitude'] ?? 0.0,
        InvLongitude = json['InvLongitude'] ?? 0.0,
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
        'InvId': InvId,
        'InvTypeId': InvTypeId,
        'PtId': PtId,
        'PmId': PmId,
        'InvStatId': InvStatId,
        'CurrencyId': CurrencyId,
        'RpAccId': RpAccId,
        'CId': CId,
        'DivId': DivId,
        'WhId': WhId,
        'WpId': WpId,
        'EmpId': EmpId,
        'UId': UId,
        'InvGuid': InvGuid,
        'InvRegNo': InvRegNo,
        'InvDesc': InvDesc,
        'InvDate': InvDate?.toIso8601String(),
        'InvTotal': InvTotal,
        'InvExpenseAmount': InvExpenseAmount,
        'InvTaxAmount': InvTaxAmount,
        'InvDiscountAmount': InvDiscountAmount,
        'InvFTotal': InvFTotal,
        'InvFTotalInWrite': InvFTotalInWrite,
        'InvModifyCount': InvModifyCount,
        'InvPrintCount': InvPrintCount,
        'InvCreditDays': InvCreditDays,
        'InvCreditDesc': InvCreditDesc,
        'InvLatitude': InvLatitude,
        'InvLongitude': InvLongitude,
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

  TblDkInvoice copyWith({
    int? InvId,
    int? InvTypeId,
    int? PtId,
    int? PmId,
    int? InvStatId,
    int? CurrencyId,
    int? RpAccId,
    int? CId,
    int? DivId,
    int? WhId,
    int? WpId,
    int? EmpId,
    int? UId,
    String? InvGuid,
    String? InvRegNo,
    String? InvDesc,
    DateTime? InvDate,
    double? InvTotal,
    double? InvExpenseAmount,
    double? InvTaxAmount,
    double? InvDiscountAmount,
    double? InvFTotal,
    String? InvFTotalInWrite,
    int? InvModifyCount,
    int? InvPrintCount,
    int? InvCreditDays,
    String? InvCreditDesc,
    double? InvLatitude,
    double? InvLongitude,
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
    return TblDkInvoice(
      InvId: InvId ?? this.InvId,
      InvTypeId: InvTypeId ?? this.InvTypeId,
      PtId: PtId ?? this.PtId,
      PmId: PmId ?? this.PmId,
      InvStatId: InvStatId ?? this.InvStatId,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      RpAccId: RpAccId ?? this.RpAccId,
      CId: CId ?? this.CId,
      DivId: DivId ?? this.DivId,
      WhId: WhId ?? this.WhId,
      WpId: WpId ?? this.WpId,
      EmpId: EmpId ?? this.EmpId,
      UId: UId ?? this.UId,
      InvGuid: InvGuid ?? this.InvGuid,
      InvRegNo: InvRegNo ?? this.InvRegNo,
      InvDesc: InvDesc ?? this.InvDesc,
      InvDate: InvDate ?? this.InvDate,
      InvTotal: InvTotal ?? this.InvTotal,
      InvExpenseAmount: InvExpenseAmount ?? this.InvExpenseAmount,
      InvTaxAmount: InvTaxAmount ?? this.InvTaxAmount,
      InvDiscountAmount: InvDiscountAmount ?? this.InvDiscountAmount,
      InvFTotal: InvFTotal ?? this.InvFTotal,
      InvFTotalInWrite: InvFTotalInWrite ?? this.InvFTotalInWrite,
      InvModifyCount: InvModifyCount ?? this.InvModifyCount,
      InvPrintCount: InvPrintCount ?? this.InvPrintCount,
      InvCreditDays: InvCreditDays ?? this.InvCreditDays,
      InvCreditDesc: InvCreditDesc ?? this.InvCreditDesc,
      InvLatitude: InvLatitude ?? this.InvLatitude,
      InvLongitude: InvLongitude ?? this.InvLongitude,
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
