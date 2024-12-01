// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkExcRate extends Model {
  //region Properties
  final int? ExcRateId;
  final String? ExcRateGuid;
  final int? CurrencyId;
  final DateTime? ExcRateDate;
  final double? ExcRateInValue;
  final double? ExcRateOutValue;
  final DateTime? CreatedDate;
  final DateTime? ModifiedDate;
  final int? CreatedUId;
  final int? ModifiedUId;
  final DateTime? SyncDateTime;

  //endregion Properties

  //region Constructor
  TblDkExcRate({
    this.ExcRateId,
    this.ExcRateGuid,
    this.CurrencyId,
    this.ExcRateDate,
    this.ExcRateInValue,
    this.ExcRateOutValue,
    this.CreatedDate,
    this.ModifiedDate,
    this.CreatedUId,
    this.ModifiedUId,
    this.SyncDateTime,
  });

  //endregion Constructor

//region Functions
  @override
  Map<String, dynamic> toMap() => {
        "ExcRateId": ExcRateId,
        "ExcRateGuid": ExcRateGuid,
        "CurrencyId": CurrencyId,
        "ExcRateDate": ExcRateDate?.millisecondsSinceEpoch,
        "ExcRateInValue": ExcRateInValue,
        "ExcRateOutValue": ExcRateOutValue,
        "CreatedDate": CreatedDate?.millisecondsSinceEpoch,
        "ModifiedDate": ModifiedDate?.millisecondsSinceEpoch,
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.millisecondsSinceEpoch,
      };

  static TblDkExcRate fromMap(Map<String, dynamic> map) => TblDkExcRate(
        ExcRateId: map['ExcRateId'],
        ExcRateGuid: map['ExcRateGuid'],
        CurrencyId: map['CurrencyId'],
        ExcRateDate: (map['ExcRateDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ExcRateDate']) : null,
        ExcRateInValue: map['ExcRateInValue'],
        ExcRateOutValue: map['ExcRateOutValue'],
        CreatedDate: (map['CreatedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['CreatedDate']) : null,
        ModifiedDate: (map['ModifiedDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['ModifiedDate']) : null,
        CreatedUId: map['CreatedUId'],
        ModifiedUId: map['ModifiedUId'],
        SyncDateTime: (map['SyncDateTime'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime']) : null,
      );

  TblDkExcRate.fromJson(Map<String, dynamic> json)
      : ExcRateId = json['ExcRateId'],
        ExcRateGuid = json['ExcRateGuid'],
        CurrencyId = json['CurrencyId'],
        ExcRateDate = (json['ExcRateDate'] != null) ? DateTime.parse(json['ExcRateDate']) : null,
        ExcRateInValue = json['ExcRateInValue'],
        ExcRateOutValue = json['ExcRateOutValue'],
        CreatedDate = (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate = (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId = json['CreatedUId'],
        ModifiedUId = json['ModifiedUId'],
        SyncDateTime = (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null;

  Map<String, dynamic> toJson() => {
        'ExcRateId': ExcRateId,
        'ExcRateGuid': ExcRateGuid,
        'CurrencyId': CurrencyId,
        'ExcRateDate': ExcRateDate?.toIso8601String(),
        'ExcRateInValue': ExcRateInValue,
        'ExcRateOutValue': ExcRateOutValue,
        'CreatedDate': CreatedDate?.toIso8601String(),
        'ModifiedDate': ModifiedDate?.toIso8601String(),
        'CreatedUId': CreatedUId,
        'ModifiedUId': ModifiedUId,
        'SyncDateTime': SyncDateTime?.toIso8601String(),
      };

  TblDkExcRate copyWith({
    int? ExcRateId,
    String? ExcRateGuid,
    int? CurrencyId,
    DateTime? ExcRateDate,
    double? ExcRateInValue,
    double? ExcRateOutValue,
    DateTime? CreatedDate,
    DateTime? ModifiedDate,
    int? CreatedUId,
    int? ModifiedUId,
    DateTime? SyncDateTime,
  }) {
    return TblDkExcRate(
      ExcRateId: ExcRateId ?? this.ExcRateId,
      ExcRateGuid: ExcRateGuid ?? this.ExcRateGuid,
      CurrencyId: CurrencyId ?? this.CurrencyId,
      ExcRateDate: ExcRateDate ?? this.ExcRateDate,
      ExcRateInValue: ExcRateInValue ?? this.ExcRateInValue,
      ExcRateOutValue: ExcRateOutValue ?? this.ExcRateOutValue,
      CreatedDate: CreatedDate ?? this.CreatedDate,
      ModifiedDate: ModifiedDate ?? this.ModifiedDate,
      CreatedUId: CreatedUId ?? this.CreatedUId,
      ModifiedUId: ModifiedUId ?? this.ModifiedUId,
      SyncDateTime: SyncDateTime ?? this.SyncDateTime,
    );
  }

//endregion Functions
}
