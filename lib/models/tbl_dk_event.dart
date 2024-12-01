// ignore_for_file: non_constant_identifier_names

import 'package:pos_app/models/model.dart';

class TblDkEvent extends Model {
  //region Properties
  final int EventId;
  final String EventGuid;
  final int EventTypeId;
  final int ResCatId;
  final int ColorId;
  final int LocId;
  final int TableId;
  final String? TableGroupGuid;
  final int SaleCardId;
  final int RpAccId;
  final int CId;
  final int DivId;
  final int WpId;
  final int EmpId;
  final int OwnerEventId;
  final String EventName;
  final String EventDesc;
  final String EventTitle;
  final DateTime? EventStartDate;
  final DateTime? EventEndDate;
  final int WholeDay;
  final int NumberOfGuests;
  final String TagsInfo;
  final String RecurrenceInfo;
  final String ReminderInfo;
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
  TblDkEvent({
    required this.EventId,
    required this.EventGuid,
    required this.EventTypeId,
    required this.ResCatId,
    required this.ColorId,
    required this.LocId,
    required this.TableId,
    required this.TableGroupGuid,
    required this.SaleCardId,
    required this.RpAccId,
    required this.CId,
    required this.DivId,
    required this.WpId,
    required this.EmpId,
    required this.OwnerEventId,
    required this.EventName,
    required this.EventDesc,
    required this.EventTitle,
    required this.EventStartDate,
    required this.EventEndDate,
    required this.WholeDay,
    required this.NumberOfGuests,
    required this.TagsInfo,
    required this.RecurrenceInfo,
    required this.ReminderInfo,
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
        "EventId": EventId,
        "EventGuid": EventGuid,
        "EventTypeId": EventTypeId,
        "ResCatId": ResCatId,
        "ColorId": ColorId,
        "LocId": LocId,
        "TableId": TableId,
        "TableGroupGuid": TableGroupGuid,
        "SaleCardId": SaleCardId,
        "RpAccId": RpAccId,
        "CId": CId,
        "DivId": DivId,
        "WpId": WpId,
        "EmpId": EmpId,
        "OwnerEventId": OwnerEventId,
        "EventName": EventName,
        "EventDesc": EventDesc,
        "EventTitle": EventTitle,
        "EventStartDate": EventStartDate?.millisecondsSinceEpoch,
        "EventEndDate": EventEndDate?.millisecondsSinceEpoch,
        "WholeDay": WholeDay,
        "NumberOfGuests": NumberOfGuests,
        "TagsInfo": TagsInfo,
        "RecurrenceInfo": RecurrenceInfo,
        "ReminderInfo": ReminderInfo,
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

  static TblDkEvent fromMap(Map<String, dynamic> map) =>
      TblDkEvent(
        EventId: map['EventId'] ?? 0,
        EventGuid: map['EventGuid']?.toString() ?? '',
        EventTypeId: map['EventTypeId'] ?? 0,
        ResCatId: map['ResCatId'] ?? 0,
        ColorId: map['ColorId'] ?? 0,
        LocId: map['LocId'] ?? 0,
        TableId: map['TableId'] ?? 0,
        TableGroupGuid: map['TableGroupGuid']?.toString(),
        SaleCardId: map['SaleCardId'] ?? 0,
        RpAccId: map['RpAccId'] ?? 0,
        CId: map['CId'] ?? 0,
        DivId: map['DivId'] ?? 0,
        WpId: map['WpId'] ?? 0,
        EmpId: map['EmpId'] ?? 0,
        OwnerEventId: map['OwnerEventId'] ?? 0,
        EventName: map['EventName']?.toString() ?? '',
        EventDesc: map['EventDesc']?.toString() ?? '',
        EventTitle: map['EventTitle']?.toString() ?? '',
        EventStartDate: (map['EventStartDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['EventStartDate'] ?? 0) : null,
        EventEndDate: (map['EventEndDate'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['EventEndDate'] ?? 0) : null,
        WholeDay: map['WholeDay'] ?? 0,
        NumberOfGuests: map['NumberOfGuests'] ?? 0,
        TagsInfo: map['TagsInfo']?.toString() ?? '',
        RecurrenceInfo: map['RecurrenceInfo']?.toString() ?? '',
        ReminderInfo: map['ReminderInfo']?.toString() ?? '',
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
        "EventId": EventId,
        "EventGuid": EventGuid,
        "EventTypeId": EventTypeId,
        "ResCatId": ResCatId,
        "ColorId": ColorId,
        "LocId": LocId,
        "TableId": TableId,
        "TableGroupGuid": TableGroupGuid,
        "SaleCardId": SaleCardId,
        "RpAccId": RpAccId,
        "CId": CId,
        "DivId": DivId,
        "WpId": WpId,
        "EmpId": EmpId,
        "OwnerEventId": OwnerEventId,
        "EventName": EventName,
        "EventDesc": EventDesc,
        "EventTitle": EventTitle,
        "EventStartDate": EventStartDate?.toIso8601String(),
        "EventEndDate": EventEndDate?.toIso8601String(),
        "WholeDay": WholeDay,
        "NumberOfGuests": NumberOfGuests,
        "TagsInfo": TagsInfo,
        "RecurrenceInfo": RecurrenceInfo,
        "ReminderInfo": ReminderInfo,
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
        "CreatedDate": CreatedDate?.toIso8601String(),
        "ModifiedDate": ModifiedDate?.toIso8601String(),
        "CreatedUId": CreatedUId,
        "ModifiedUId": ModifiedUId,
        "SyncDateTime": SyncDateTime?.toIso8601String(),
      };

  static TblDkEvent fromJson(Map<String, dynamic> json) =>
      TblDkEvent(
        EventId: json['EventId'] ?? 0,
        EventGuid: json['EventGuid']?.toString() ?? '',
        EventTypeId: json['EventTypeId'] ?? 0,
        ResCatId: json['ResCatId'] ?? 0,
        ColorId: json['ColorId'] ?? 0,
        LocId: json['LocId'] ?? 0,
        TableId: json['TableId'] ?? 0,
        TableGroupGuid: json['TableGroupGuid']?.toString(),
        SaleCardId: json['SaleCardId'] ?? 0,
        RpAccId: json['RpAccId'] ?? 0,
        CId: json['CId'] ?? 0,
        DivId: json['DivId'] ?? 0,
        WpId: json['WpId'] ?? 0,
        EmpId: json['EmpId'] ?? 0,
        OwnerEventId: json['OwnerEventId'] ?? 0,
        EventName: json['EventName']?.toString() ?? '',
        EventDesc: json['EventDesc']?.toString() ?? '',
        EventTitle: json['EventTitle']?.toString() ?? '',
        EventStartDate: (json['EventStartDate'] != null) ? DateTime.parse(json['EventStartDate']) : null,
        EventEndDate: (json['EventEndDate'] != null) ? DateTime.parse(json['EventEndDate']) : null,
        WholeDay: json['WholeDay'] ?? 0,
        NumberOfGuests: json['NumberOfGuests'] ?? 0,
        TagsInfo: json['TagsInfo']?.toString() ?? '',
        RecurrenceInfo: json['RecurrenceInfo']?.toString() ?? '',
        ReminderInfo: json['ReminderInfo']?.toString() ?? '',
        AddInf1: json['AddInf1']?.toString() ?? '',
        AddInf2: json['AddInf2']?.toString() ?? '',
        AddInf3: json['AddInf3']?.toString() ?? '',
        AddInf4: json['AddInf4']?.toString() ?? '',
        AddInf5: json['AddInf5']?.toString() ?? '',
        AddInf6: json['AddInf6']?.toString() ?? '',
        AddInf7: json['AddInf7']?.toString() ?? '',
        AddInf8: json['AddInf8']?.toString() ?? '',
        AddInf9: json['AddInf9']?.toString() ?? '',
        AddInf10: json['AddInf10']?.toString() ?? '',
        CreatedDate: (json['CreatedDate'] != null) ? DateTime.parse(json['CreatedDate']) : null,
        ModifiedDate: (json['ModifiedDate'] != null) ? DateTime.parse(json['ModifiedDate']) : null,
        CreatedUId: json['CreatedUId'] ?? 0,
        ModifiedUId: json['ModifiedUId'] ?? 0,
        SyncDateTime: (json['SyncDateTime'] != null) ? DateTime.parse(json['SyncDateTime']) : null,
      );

//endregion
}