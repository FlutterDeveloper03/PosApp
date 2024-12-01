// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkOrderInv extends Model {
  //region Properties
  final int OInvId;
  final String OInvGuid;
  final int InvTypeId;
  final int InvStatId;
  final int PtId;
  final int PmId;
  final int CurrencyId;
  final int RpAccId;
  final int CId;
  final int DivId;
  final int WhId;
  final int WpId;
  final int EmpId;
  final int UId;
  final int PaymStatusId;
  final String PaymCode;
  final String PaymDesc;
  final String OInvRegNo;
  final String OInvDesc;
  final DateTime? OInvDate;
  final double OInvTotal;
  final double OInvExpenseAmount;
  final double OInvTaxAmount;
  final double OInvDiscountAmount;
  final double OInvFTotal;
  final String OInvFTotalInWrite;
  final double OInvPaymAmount;
  final int OInvModifyCount;
  final int OInvPrintCount;
  final int OInvCreditDays;
  final String OInvCreditDesc;
  final double OInvLatitude;
  final double OInvLongitude;
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
  TblDkOrderInv({
    required this.OInvId,
    required this.OInvGuid,
    required this.InvTypeId,
    required this.InvStatId,
    required this.PtId,
    required this.PmId,
    required this.CurrencyId,
    required this.RpAccId,
    required this.CId,
    required this.DivId,
    required this.WhId,
    required this.WpId,
    required this.EmpId,
    required this.UId,
    required this.PaymStatusId,
    required this.PaymCode,
    required this.PaymDesc,
    required this.OInvRegNo,
    required this.OInvDesc,
    required this.OInvDate,
    required this.OInvTotal,
    required this.OInvExpenseAmount,
    required this.OInvTaxAmount,
    required this.OInvDiscountAmount,
    required this.OInvFTotal,
    required this.OInvFTotalInWrite,
    required this.OInvPaymAmount,
    required this.OInvModifyCount,
    required this.OInvPrintCount,
    required this.OInvCreditDays,
    required this.OInvCreditDesc,
    required this.OInvLatitude,
    required this.OInvLongitude,
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
  Map<String, dynamic> toMap() =>
      {
        'OInvId': OInvId,
        'OInvGuid': OInvGuid,
        'InvTypeId': InvTypeId,
        'InvStatId': InvStatId,
        'PtId': PtId,
        'PmId': PmId,
        'CurrencyId': CurrencyId,
        'RpAccId': RpAccId,
        'CId': CId,
        'DivId': DivId,
        'WhId': WhId,
        'WpId': WpId,
        'EmpId': EmpId,
        'UId': UId,
        'PaymStatusId': PaymStatusId,
        'PaymCode': PaymCode,
        'PaymDesc': PaymDesc,
        'OInvRegNo': OInvRegNo,
        'OInvDesc': OInvDesc,
        'OInvDate': OInvDate?.millisecondsSinceEpoch,
        'OInvTotal': OInvTotal,
        'OInvExpenseAmount': OInvExpenseAmount,
        'OInvTaxAmount': OInvTaxAmount,
        'OInvDiscountAmount': OInvDiscountAmount,
        'OInvFTotal': OInvFTotal,
        'OInvFTotalInWrite': OInvFTotalInWrite,
        'OInvPaymAmount': OInvPaymAmount,
        'OInvModifyCount': OInvModifyCount,
        'OInvPrintCount': OInvPrintCount,
        'OInvCreditDays': OInvCreditDays,
        'OInvCreditDesc': OInvCreditDesc,
        'OInvLatitude': OInvLatitude,
        'OInvLongitude': OInvLongitude,
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
        'CreatedDate': CreatedDate?.millisecondsSinceEpoch,
        'ModifiedDate': ModifiedDate?.millisecondsSinceEpoch,
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkOrderInv fromMap(Map<String, dynamic> map) =>
      TblDkOrderInv(
        OInvId: map['OInvId'] ?? 0,
        OInvGuid: map['OInvGuid']?.toString() ?? '',
        InvTypeId: map['InvTypeId'] ?? 0,
        InvStatId: map['InvStatId'] ?? 0,
        PtId: map['PtId'] ?? 0,
        PmId: map['PmId'] ?? 0,
        CurrencyId: map['CurrencyId'] ?? 0,
        RpAccId: map['RpAccId'] ?? 0,
        CId: map['CId'] ?? 0,
        DivId: map['DivId'] ?? 0,
        WhId: map['WhId'] ?? 0,
        WpId: map['WpId'] ?? 0,
        EmpId: map['EmpId'] ?? 0,
        UId: map['UId'] ?? 0,
        PaymStatusId: map['PaymStatusId'] ?? 0,
        PaymCode: map['PaymCode']?.toString() ?? '',
        PaymDesc: map['PaymDesc']?.toString() ?? '',
        OInvRegNo: map['OInvRegNo']?.toString() ?? '',
        OInvDesc: map['OInvDesc']?.toString() ?? '',
        OInvDate: (map['OInvDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['OInvDate'] ?? 0) : null,
        OInvTotal: map['OInvTotal']?.toDouble() ?? 0.0,
        OInvExpenseAmount: map['OInvExpenseAmount']?.toDouble() ?? 0.0,
        OInvTaxAmount: map['OInvTaxAmount']?.toDouble() ?? 0.0,
        OInvDiscountAmount: map['OInvDiscountAmount']?.toDouble() ?? 0.0,
        OInvFTotal: map['OInvFTotal']?.toDouble() ?? 0.0,
        OInvFTotalInWrite: map['OInvFTotalInWrite']?.toString() ?? '',
        OInvPaymAmount: map['OInvPaymAmount']?.toDouble() ?? 0.0,
        OInvModifyCount: map['OInvModifyCount'] ?? 0,
        OInvPrintCount: map['OInvPrintCount'] ?? 0,
        OInvCreditDays: map['OInvCreditDays'] ?? 0,
        OInvCreditDesc: map['OInvCreditDesc']?.toString() ?? '',
        OInvLatitude: map['OInvLatitude']?.toDouble() ?? 0.0,
        OInvLongitude: map['OInvLongitude']?.toDouble() ?? 0.0,
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

  Map<String, dynamic> toJson() =>
      {
        'OInvId': OInvId,
        'OInvGuid': OInvGuid,
        'InvTypeId': InvTypeId,
        'InvStatId': InvStatId,
        'PtId': PtId,
        'PmId': PmId,
        'CurrencyId': CurrencyId,
        'RpAccId': RpAccId,
        'CId': CId,
        'DivId': DivId,
        'WhId': WhId,
        'WpId': WpId,
        'EmpId': EmpId,
        'UId': UId,
        'PaymStatusId': PaymStatusId,
        'PaymCode': PaymCode,
        'PaymDesc': PaymDesc,
        'OInvRegNo': OInvRegNo,
        'OInvDesc': OInvDesc,
        'OInvDate': OInvDate?.toIso8601String(),
        'OInvTotal': OInvTotal,
        'OInvExpenseAmount': OInvExpenseAmount,
        'OInvTaxAmount': OInvTaxAmount,
        'OInvDiscountAmount': OInvDiscountAmount,
        'OInvFTotal': OInvFTotal,
        'OInvFTotalInWrite': OInvFTotalInWrite,
        'OInvPaymAmount': OInvPaymAmount,
        'OInvModifyCount': OInvModifyCount,
        'OInvPrintCount': OInvPrintCount,
        'OInvCreditDays': OInvCreditDays,
        'OInvCreditDesc': OInvCreditDesc,
        'OInvLatitude': OInvLatitude,
        'OInvLongitude': OInvLongitude,
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

  static TblDkOrderInv fromJson(Map<String, dynamic> map) =>
      TblDkOrderInv(
        OInvId: map['OInvId'] ?? 0,
        OInvGuid: map['OInvGuid']?.toString() ?? '',
        InvTypeId: map['InvTypeId'] ?? 0,
        InvStatId: map['InvStatId'] ?? 0,
        PtId: map['PtId'] ?? 0,
        PmId: map['PmId'] ?? 0,
        CurrencyId: map['CurrencyId'] ?? 0,
        RpAccId: map['RpAccId'] ?? 0,
        CId: map['CId'] ?? 0,
        DivId: map['DivId'] ?? 0,
        WhId: map['WhId'] ?? 0,
        WpId: map['WpId'] ?? 0,
        EmpId: map['EmpId'] ?? 0,
        UId: map['UId'] ?? 0,
        PaymStatusId: map['PaymStatusId'] ?? 0,
        PaymCode: map['PaymCode']?.toString() ?? '',
        PaymDesc: map['PaymDesc']?.toString() ?? '',
        OInvRegNo: map['OInvRegNo']?.toString() ?? '',
        OInvDesc: map['OInvDesc']?.toString() ?? '',
        OInvDate: (map['OInvDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['OInvDate'] ?? 0) : null,
        OInvTotal: map['OInvTotal']?.toDouble() ?? 0.0,
        OInvExpenseAmount: map['OInvExpenseAmount']?.toDouble() ?? 0.0,
        OInvTaxAmount: map['OInvTaxAmount']?.toDouble() ?? 0.0,
        OInvDiscountAmount: map['OInvDiscountAmount']?.toDouble() ?? 0.0,
        OInvFTotal: map['OInvFTotal']?.toDouble() ?? 0.0,
        OInvFTotalInWrite: map['OInvFTotalInWrite']?.toString() ?? '',
        OInvPaymAmount: map['OInvPaymAmount']?.toDouble() ?? 0.0,
        OInvModifyCount: map['OInvModifyCount'] ?? 0,
        OInvPrintCount: map['OInvPrintCount'] ?? 0,
        OInvCreditDays: map['OInvCreditDays'] ?? 0,
        OInvCreditDesc: map['OInvCreditDesc']?.toString() ?? '',
        OInvLatitude: map['OInvLatitude']?.toDouble() ?? 0.0,
        OInvLongitude: map['OInvLongitude']?.toDouble() ?? 0.0,
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

  TblDkOrderInv copyWith({
    int? OInvId,
    String? OInvGuid,
    int? InvTypeId,
    int? InvStatId,
    int? PtId,
    int? PmId,
    int? CurrencyId,
    int? RpAccId,
    int? CId,
    int? DivId,
    int? WhId,
    int? WpId,
    int? EmpId,
    int? UId,
    int? PaymStatusId,
    String? PaymCode,
    String? PaymDesc,
    String? OInvRegNo,
    String? OInvDesc,
    DateTime? OInvDate,
    double? OInvTotal,
    double? OInvExpenseAmount,
    double? OInvTaxAmount,
    double? OInvDiscountAmount,
    double? OInvFTotal,
    String? OInvFTotalInWrite,
    double? OInvPaymAmount,
    int? OInvModifyCount,
    int? OInvPrintCount,
    int? OInvCreditDays,
    String? OInvCreditDesc,
    double? OInvLatitude,
    double? OInvLongitude,
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
    return TblDkOrderInv(
      OInvId: OInvId ?? this.OInvId,
      OInvGuid: OInvGuid ?? this.OInvGuid,
      InvTypeId: InvTypeId ?? this.InvTypeId,
      InvStatId: InvStatId ?? this.InvStatId,
      PtId: PtId ?? this.PtId,
      PmId: PmId ?? this.PmId,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      RpAccId: RpAccId ?? this.RpAccId,
      CId: CId ?? this.CId,
      DivId: DivId ?? this.DivId,
      WhId: WhId ?? this.WhId,
      WpId: WpId ?? this.WpId,
      EmpId: EmpId ?? this.EmpId,
      UId: UId ?? this.UId,
      PaymStatusId: PaymStatusId ?? this.PaymStatusId,
      PaymCode: PaymCode ?? this.PaymCode,
      PaymDesc: PaymDesc ?? this.PaymDesc,
      OInvRegNo: OInvRegNo ?? this.OInvRegNo,
      OInvDesc: OInvDesc ?? this.OInvDesc,
      OInvDate: OInvDate ?? this.OInvDate,
      OInvTotal: OInvTotal ?? this.OInvTotal,
      OInvExpenseAmount: OInvExpenseAmount ?? this.OInvExpenseAmount,
      OInvTaxAmount: OInvTaxAmount ?? this.OInvTaxAmount,
      OInvDiscountAmount: OInvDiscountAmount ?? this.OInvDiscountAmount,
      OInvFTotal: OInvFTotal ?? this.OInvFTotal,
      OInvFTotalInWrite: OInvFTotalInWrite ?? this.OInvFTotalInWrite,
      OInvPaymAmount: OInvPaymAmount ?? this.OInvPaymAmount,
      OInvModifyCount: OInvModifyCount ?? this.OInvModifyCount,
      OInvPrintCount: OInvPrintCount ?? this.OInvPrintCount,
      OInvCreditDays: OInvCreditDays ?? this.OInvCreditDays,
      OInvCreditDesc: OInvCreditDesc ?? this.OInvCreditDesc,
      OInvLatitude: OInvLatitude ?? this.OInvLatitude,
      OInvLongitude: OInvLongitude ?? this.OInvLongitude,
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

  @override
  String toString() {
    return 'TblDkOrderInv{OInvId: $OInvId, OInvGuid: $OInvGuid, InvTypeId: $InvTypeId, InvStatId: $InvStatId, PtId: $PtId, PmId: $PmId, CurrencyId: $CurrencyId, RpAccId: $RpAccId, CId: $CId, DivId: $DivId, WhId: $WhId, WpId: $WpId, EmpId: $EmpId, UId: $UId, PaymStatusId: $PaymStatusId, PaymCode: $PaymCode, PaymDesc: $PaymDesc, OInvRegNo: $OInvRegNo, OInvDesc: $OInvDesc, OInvDate: $OInvDate, OInvTotal: $OInvTotal, OInvExpenseAmount: $OInvExpenseAmount, OInvTaxAmount: $OInvTaxAmount, OInvDiscountAmount: $OInvDiscountAmount, OInvFTotal: $OInvFTotal, OInvFTotalInWrite: $OInvFTotalInWrite, OInvPaymAmount: $OInvPaymAmount, OInvModifyCount: $OInvModifyCount, OInvPrintCount: $OInvPrintCount, OInvCreditDays: $OInvCreditDays, OInvCreditDesc: $OInvCreditDesc, OInvLatitude: $OInvLatitude, OInvLongitude: $OInvLongitude, AddInf1: $AddInf1, AddInf2: $AddInf2, AddInf3: $AddInf3, AddInf4: $AddInf4, AddInf5: $AddInf5, AddInf6: $AddInf6, AddInf7: $AddInf7, AddInf8: $AddInf8, AddInf9: $AddInf9, AddInf10: $AddInf10, CreatedDate: $CreatedDate, ModifiedDate: $ModifiedDate, CreatedUId: $CreatedUId, ModifiedUId: $ModifiedUId, SyncDateTime: $SyncDateTime}';
  }
}