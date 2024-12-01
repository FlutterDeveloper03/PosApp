// ignore_for_file: non_constant_identifier_names, file_names

class PrinterModel {
  final String? PrinterName;
  final String? PrinterIpAddress;
  final int? PrinterPort;
  final int? connectionMode; // 1=usb, 2=LAN, 3=Bluetooth
  final int? printCount;
  final String? AddInf1;
  final String? AddInf2;
  final String? AddInf3;

  PrinterModel({
    this.PrinterName,
    this.PrinterIpAddress,
    this.PrinterPort,
    this.connectionMode,
    this.printCount,
    this.AddInf1,
    this.AddInf2,
    this.AddInf3,
  });

  PrinterModel.fromJson(Map<String,dynamic> json)
    : PrinterName = json['PrinterName'] ?? '',
      PrinterIpAddress = json['PrinterIpAddress'] ?? '',
      PrinterPort = json['PrinterPort'] ?? 0,
      connectionMode = json['connectionMode'] ?? 0,
      printCount = json['printCount'] ?? 1,
      AddInf1 = json['AddInf1'] ?? '',
      AddInf2 = json['AddInf2'] ?? '',
      AddInf3 = json['AddInf3'] ?? '';

  Map<String,dynamic> toJson()=>{
    'PrinterName':PrinterName.toString(),
    'PrinterIpAddress':PrinterIpAddress.toString(),
    'PrinterPort':PrinterPort,
    'connectionMode':connectionMode,
    'printCount':printCount,
    'AddInf1':AddInf1.toString(),
    'AddInf2':AddInf2.toString(),
    'AddInf3':AddInf3.toString(),
  };
}
