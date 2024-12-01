// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkOrderInvLine extends Model {
  //region Properties
  final int OInvLineId;
  final String OInvLineGuid;
  final int OInvId;
  final int WhId;
  final int ResUnitId;
  final int CurrencyId;
  final int ResId;
  final int LastVendorId;
  final String OInvLineRegNo;
  final String OInvLineDesc;
  final double OInvLineAmount;
  final double OInvLinePrice;
  final double OInvLineTotal;
  final double OInvLineExpenseAmount;
  final double OInvLineTaxAmount;
  final double OInvLineDiscAmount;
  final double OInvLineFTotal;
  final double ExcRateValue;
  final DateTime? OInvLineDate;
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
  TblDkOrderInvLine({
    required this.OInvLineId,
    required this.OInvLineGuid,
    required this.OInvId,
    required this.WhId,
    required this.ResUnitId,
    required this.CurrencyId,
    required this.ResId,
    required this.LastVendorId,
    required this.OInvLineRegNo,
    required this.OInvLineDesc,
    required this.OInvLineAmount,
    required this.OInvLinePrice,
    required this.OInvLineTotal,
    required this.OInvLineExpenseAmount,
    required this.OInvLineTaxAmount,
    required this.OInvLineDiscAmount,
    required this.OInvLineFTotal,
    required this.ExcRateValue,
    required this.OInvLineDate,
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
        "OInvLineId": OInvLineId,
        "OInvLineGuid": OInvLineGuid,
        "OInvId": OInvId,
        "WhId": WhId,
        "ResUnitId": ResUnitId,
        "CurrencyId": CurrencyId,
        "ResId": ResId,
        "LastVendorId": LastVendorId,
        "OInvLineRegNo": OInvLineRegNo,
        "OInvLineDesc": OInvLineDesc,
        "OInvLineAmount": OInvLineAmount,
        "OInvLinePrice": OInvLinePrice,
        "OInvLineTotal": OInvLineTotal,
        "OInvLineExpenseAmount": OInvLineExpenseAmount,
        "OInvLineTaxAmount": OInvLineTaxAmount,
        "OInvLineDiscAmount": OInvLineDiscAmount,
        "OInvLineFTotal": OInvLineFTotal,
        "ExcRateValue": ExcRateValue,
        "OInvLineDate": OInvLineDate?.millisecondsSinceEpoch,
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

  static TblDkOrderInvLine fromMap(Map<String, dynamic> map) => TblDkOrderInvLine(
        OInvLineId: map['OInvLineId'] ?? 0,
        OInvLineGuid: map['OInvLineGuid']?.toString() ?? '',
        OInvId: map['OInvId'] ?? 0,
        WhId: map['WhId'] ?? 0,
        ResUnitId: map['ResUnitId'] ?? 0,
        CurrencyId: map['CurrencyId'] ?? 0,
        ResId: map['ResId'] ?? 0,
        LastVendorId: map['LastVendorId'] ?? 0,
        OInvLineRegNo: map['OInvLineRegNo']?.toString() ?? '',
        OInvLineDesc: map['OInvLineDesc']?.toString() ?? '',
        OInvLineAmount: map['OInvLineAmount'] ?? 0.0,
        OInvLinePrice: map['OInvLinePrice'] ?? 0.0,
        OInvLineTotal: map['OInvLineTotal'] ?? 0.0,
        OInvLineExpenseAmount: map['OInvLineExpenseAmount'] ?? 0.0,
        OInvLineTaxAmount: map['OInvLineTaxAmount'] ?? 0.0,
        OInvLineDiscAmount: map['OInvLineDiscAmount'] ?? 0.0,
        OInvLineFTotal: map['OInvLineFTotal'] ?? 0.0,
        ExcRateValue: map['ExcRateValue'] ?? 0.0,
        OInvLineDate: (map['OInvLineDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['OInvLineDate'] ?? 0) : null,
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

  TblDkOrderInvLine.fromJson(Map<String, dynamic> json)
      : OInvLineId = json['OInvLineId'] ?? 0,
        OInvLineGuid = json['OInvLineGuid']?.toString() ?? '',
        OInvId = json['OInvId'] ?? 0,
        WhId = json['WhId'] ?? 0,
        ResUnitId = json['ResUnitId'] ?? 0,
        CurrencyId = json['CurrencyId'] ?? 0,
        ResId = json['ResId'] ?? 0,
        LastVendorId = json['LastVendorId'] ?? 0,
        OInvLineRegNo = json['OInvLineRegNo']?.toString() ?? '',
        OInvLineDesc = json['OInvLineDesc']?.toString() ?? '',
        OInvLineAmount = json['OInvLineAmount'] ?? 0.0,
        OInvLinePrice = json['OInvLinePrice'] ?? 0.0,
        OInvLineTotal = json['OInvLineTotal'] ?? 0.0,
        OInvLineExpenseAmount = json['OInvLineExpenseAmount'] ?? 0.0,
        OInvLineTaxAmount = json['OInvLineTaxAmount'] ?? 0.0,
        OInvLineDiscAmount = json['OInvLineDiscAmount'] ?? 0.0,
        OInvLineFTotal = json['OInvLineFTotal'] ?? 0.0,
        ExcRateValue = json['ExcRateValue'] ?? 0.0,
        OInvLineDate = (json['OInvLineDate'] != null) ? DateTime.parse(json['OInvLineDate']) : null,
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
        'OInvLineId': OInvLineId,
        'OInvLineGuid': OInvLineGuid,
        'OInvId': OInvId,
        'WhId': WhId,
        'ResUnitId': ResUnitId,
        'CurrencyId': CurrencyId,
        'ResId': ResId,
        'LastVendorId': LastVendorId,
        'OInvLineRegNo': OInvLineRegNo,
        'OInvLineDesc': OInvLineDesc,
        'OInvLineAmount': OInvLineAmount,
        'OInvLinePrice': OInvLinePrice,
        'OInvLineTotal': OInvLineTotal,
        'OInvLineExpenseAmount': OInvLineExpenseAmount,
        'OInvLineTaxAmount': OInvLineTaxAmount,
        'OInvLineDiscAmount': OInvLineDiscAmount,
        'OInvLineFTotal': OInvLineFTotal,
        'ExcRateValue': ExcRateValue,
        'OInvLineDate': OInvLineDate?.toIso8601String(),
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

  TblDkOrderInvLine copyWith({
    int? OInvLineId,
    String? OInvLineGuid,
    int? OInvId,
    int? WhId,
    int? ResUnitId,
    int? CurrencyId,
    int? ResId,
    int? LastVendorId,
    String? OInvLineRegNo,
    String? OInvLineDesc,
    double? OInvLineAmount,
    double? OInvLinePrice,
    double? OInvLineTotal,
    double? OInvLineExpenseAmount,
    double? OInvLineTaxAmount,
    double? OInvLineDiscAmount,
    double? OInvLineFTotal,
    double? ExcRateValue,
    DateTime? OInvLineDate,
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
    return TblDkOrderInvLine(
      OInvLineId: OInvLineId ?? this.OInvLineId,
      OInvLineGuid: OInvLineGuid ?? this.OInvLineGuid,
      OInvId: OInvId ?? this.OInvId,
      WhId: WhId ?? this.WhId,
      ResUnitId: ResUnitId ?? this.ResUnitId,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      ResId: ResId ?? this.ResId,
      LastVendorId: LastVendorId ?? this.LastVendorId,
      OInvLineRegNo: OInvLineRegNo ?? this.OInvLineRegNo,
      OInvLineDesc: OInvLineDesc ?? this.OInvLineDesc,
      OInvLineAmount: OInvLineAmount ?? this.OInvLineAmount,
      OInvLinePrice: OInvLinePrice ?? this.OInvLinePrice,
      OInvLineTotal: OInvLineTotal ?? this.OInvLineTotal,
      OInvLineExpenseAmount: OInvLineExpenseAmount ?? this.OInvLineExpenseAmount,
      OInvLineTaxAmount: OInvLineTaxAmount ?? this.OInvLineTaxAmount,
      OInvLineDiscAmount: OInvLineDiscAmount ?? this.OInvLineDiscAmount,
      OInvLineFTotal: OInvLineFTotal ?? this.OInvLineFTotal,
      ExcRateValue: ExcRateValue ?? this.ExcRateValue,
      OInvLineDate: OInvLineDate ?? this.OInvLineDate,
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
