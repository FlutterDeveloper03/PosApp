// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkInvLine extends Model {
  //region Properties
  final int InvLineId;
  final String InvLineGuid;
  final int InvId;
  final int WhId;
  final int ResUnitId;
  final int CurrencyId;
  final int ResId;
  final int LastVendorId;
  final String InvLineRegNo;
  final String InvLineDesc;
  final double InvLineAmount;
  final double InvLinePrice;
  final double InvLineTotal;
  final double InvLineExpenseAmount;
  final double InvLineTaxAmount;
  final double InvLineDiscAmount;
  final double InvLineFTotal;
  final double ExcRateValue;
  final DateTime? InvLineDate;
  final String ResAttributesString;
  final DateTime? ModifiedDate;
  final int CreatedUId;
  final int ModifiedUId;
  final DateTime? SyncDateTime;
  final int GCRecord;

  //endregion Properties

  //region Constructor
  TblDkInvLine({
    required this.InvLineId,
    required this.InvLineGuid,
    required this.InvId,
    required this.WhId,
    required this.ResUnitId,
    required this.CurrencyId,
    required this.ResId,
    required this.LastVendorId,
    required this.InvLineRegNo,
    required this.InvLineDesc,
    required this.InvLineAmount,
    required this.InvLinePrice,
    required this.InvLineTotal,
    required this.InvLineExpenseAmount,
    required this.InvLineTaxAmount,
    required this.InvLineDiscAmount,
    required this.InvLineFTotal,
    required this.ExcRateValue,
    required this.InvLineDate,
    required this.ResAttributesString,
    required this.ModifiedDate,
    required this.CreatedUId,
    required this.ModifiedUId,
    required this.SyncDateTime,
    required this.GCRecord,
  });

//endregion Constructor

  //region Functions
  @override
  Map<String, dynamic> toMap() => {
        "InvLineId": InvLineId,
        "InvLineGuid": InvLineGuid,
        "InvId": InvId,
        "WhId": WhId,
        "ResUnitId": ResUnitId,
        "CurrencyId": CurrencyId,
        "ResId": ResId,
        "LastVendorId": LastVendorId,
        "InvLineRegNo": InvLineRegNo,
        "InvLineDesc": InvLineDesc,
        "InvLineAmount": InvLineAmount,
        "InvLinePrice": InvLinePrice,
        "InvLineTotal": InvLineTotal,
        "InvLineExpenseAmount": InvLineExpenseAmount,
        "InvLineTaxAmount": InvLineTaxAmount,
        "InvLineDiscAmount": InvLineDiscAmount,
        "InvLineFTotal": InvLineFTotal,
        "ExcRateValue": ExcRateValue,
        "InvLineDate": InvLineDate?.millisecondsSinceEpoch,
        "ResAttributesString": ResAttributesString,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
        "GCRecord": GCRecord,
      };

  static TblDkInvLine fromMap(Map<String, dynamic> map) => TblDkInvLine(
        InvLineId: map['InvLineId'] ?? 0,
        InvLineGuid: map['InvLineGuid'] ?? '',
        InvId: map['InvId'] ?? 0,
        WhId: map['WhId'] ?? 0,
        ResUnitId: map['ResUnitId'] ?? 0,
        CurrencyId: map['CurrencyId'] ?? 0,
        ResId: map['ResId'] ?? 0,
        LastVendorId: map['LastVendorId'] ?? 0,
        InvLineRegNo: map['InvLineRegNo'] ?? '',
        InvLineDesc: map['InvLineDesc'] ?? '',
        InvLineAmount: map['InvLineAmount'] ?? 0.0,
        InvLinePrice: map['InvLinePrice'] ?? 0.0,
        InvLineTotal: map['InvLineTotal'] ?? 0.0,
        InvLineExpenseAmount: map['InvLineExpenseAmount'] ?? 0.0,
        InvLineTaxAmount: map['InvLineTaxAmount'] ?? 0.0,
        InvLineDiscAmount: map['InvLineDiscAmount'] ?? 0.0,
        InvLineFTotal: map['InvLineFTotal'] ?? 0.0,
        ExcRateValue: map['ExcRateValue'] ?? 0.0,
        InvLineDate: (map['InvLineDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['InvLineDate'] ?? 0) : null,
        ResAttributesString: map['ResAttributesString'] ?? 0,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate'] ?? 0) : null,
        CreatedUId: map['CreatedUId'] ?? 0,
        ModifiedUId: map['ModifiedUId'] ?? 0,
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
        GCRecord: map['GCRecord'] ?? 0,
      );

  TblDkInvLine.fromJson(Map<String, dynamic> json)
      : InvLineId = (json['InvLineId']) ?? 0,
        InvLineGuid = (json['InvLineGuid']) ?? '',
        InvId = (json['InvId']) ?? 0,
        WhId = (json['WhId']) ?? 0,
        ResUnitId = (json['ResUnitId']) ?? 0,
        CurrencyId = (json['CurrencyId']) ?? 0,
        ResId = (json['ResId']) ?? 0,
        LastVendorId = (json['LastVendorId']) ?? 0,
        InvLineRegNo = (json['InvLineRegNo']) ?? '',
        InvLineDesc = (json['InvLineDesc']) ?? '',
        InvLineAmount = (json['InvLineAmount']) ?? 0.0,
        InvLinePrice = (json['InvLinePrice']) ?? 0.0,
        InvLineTotal = (json['InvLineTotal']) ?? 0.0,
        InvLineExpenseAmount = (json['InvLineExpenseAmount']) ?? 0.0,
        InvLineTaxAmount = (json['InvLineTaxAmount']) ?? 0.0,
        InvLineDiscAmount = (json['InvLineDiscAmount']) ?? 0.0,
        InvLineFTotal = (json['InvLineFTotal']) ?? 0.0,
        ExcRateValue = (json['ExcRateValue']) ?? 0.0,
        InvLineDate = (json['InvLineDate'] != null) ? DateTime.parse(json['InvLineDate']) : null,
        ResAttributesString = (json['ResAttributesString']) ?? '',
        ModifiedDate = (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = (json['CreatedUId']) ?? 0,
        ModifiedUId = (json['ModifiedUId']) ?? 0,
        SyncDateTime = (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null,
        GCRecord = json['GCRecord'];

  Map<String, dynamic> toJson() => {
        'InvLineId': InvLineId,
        'InvLineGuid': InvLineGuid,
        'InvId': InvId,
        'WhId': WhId,
        'ResUnitId': ResUnitId,
        'CurrencyId': CurrencyId,
        'ResId': ResId,
        'LastVendorId': LastVendorId,
        'InvLineRegNo': InvLineRegNo,
        'InvLineDesc': InvLineDesc,
        'InvLineAmount': InvLineAmount,
        'InvLinePrice': InvLinePrice,
        'InvLineTotal': InvLineTotal,
        'InvLineExpenseAmount': InvLineExpenseAmount,
        'InvLineTaxAmount': InvLineTaxAmount,
        'InvLineDiscAmount': InvLineDiscAmount,
        'InvLineFTotal': InvLineFTotal,
        'ExcRateValue': ExcRateValue,
        'InvLineDate': InvLineDate,
        'ResAttributesString': ResAttributesString,
        'ModifiedDate': ModifiedDate,
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime,
        'GCRecord': GCRecord,
      };

  TblDkInvLine copyWith({
    int? InvLineId,
    String? InvLineGuid,
    int? InvId,
    int? WhId,
    int? ResUnitId,
    int? CurrencyId,
    int? ResId,
    int? LastVendorId,
    String? InvLineRegNo,
    String? InvLineDesc,
    double? InvLineAmount,
    double? InvLinePrice,
    double? InvLineTotal,
    double? InvLineExpenseAmount,
    double? InvLineTaxAmount,
    double? InvLineDiscAmount,
    double? InvLineFTotal,
    double? ExcRateValue,
    DateTime? InvLineDate,
    String? ResAttributesString,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
    int? GCRecord,
  }) {
    return TblDkInvLine(
      InvLineId: InvLineId ?? this.InvLineId,
      InvLineGuid: InvLineGuid ?? this.InvLineGuid,
      InvId: InvId ?? this.InvId,
      WhId: WhId ?? this.WhId,
      ResUnitId: ResUnitId ?? this.ResUnitId,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      ResId: ResId ?? this.ResId,
      LastVendorId: LastVendorId ?? this.LastVendorId,
      InvLineRegNo: InvLineRegNo ?? this.InvLineRegNo,
      InvLineDesc: InvLineDesc ?? this.InvLineDesc,
      InvLineAmount: InvLineAmount ?? this.InvLineAmount,
      InvLinePrice: InvLinePrice ?? this.InvLinePrice,
      InvLineTotal: InvLineTotal ?? this.InvLineTotal,
      InvLineExpenseAmount: InvLineExpenseAmount ?? this.InvLineExpenseAmount,
      InvLineTaxAmount: InvLineTaxAmount ?? this.InvLineTaxAmount,
      InvLineDiscAmount: InvLineDiscAmount ?? this.InvLineDiscAmount,
      InvLineFTotal: InvLineFTotal ?? this.InvLineFTotal,
      ExcRateValue: ExcRateValue ?? this.ExcRateValue,
      InvLineDate: InvLineDate ?? this.InvLineDate,
      ResAttributesString: ResAttributesString ?? this.ResAttributesString,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
      GCRecord: GCRecord ?? this.GCRecord,
    );
  }

//endregion Functions
}
