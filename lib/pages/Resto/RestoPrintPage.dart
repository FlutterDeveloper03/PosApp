// ignore_for_file: file_names

import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_dart/esc_pos_printer.dart';
import 'package:esc_pos_dart/esc_pos_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RestoPrintPage extends StatefulWidget {
  const RestoPrintPage({super.key});

  @override
  State<RestoPrintPage> createState() => _RestoPrintPageState();
}

class _RestoPrintPageState extends State<RestoPrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initBluetooth();

    });
  }
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected??false;

    bluetoothPrint.state.listen((state) {
      if (kDebugMode) {
        print('******************* cur device status: $state');
      }

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  TextEditingController ipCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      onPopInvoked: (didPop){
        GoRouter.of(context).go('/restoHome');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Print Page',style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize:20)),
    elevation:0,
            backgroundColor: Theme.of(context).primaryColor,
    leading: IconButton(
    onPressed: () {
    GoRouter.of(context).go('/restoHome');
    },
      icon: Icon(Icons.arrow_back,color:Theme.of(context).iconTheme.color),
    iconSize: 30,
    ),
        ),
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardColor,
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) =>
                      Column(
                        children: snapshot.data!.map((d) =>
                            ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null && _device!.address == d
                                  .address ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              ) : null,
                            )).toList(),
                      ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: _connected ? null : () async {
                              if (_device != null && _device!.address != null) {
                                setState(() {
                                  tips = 'connecting...';
                                });
                                await bluetoothPrint.connect(_device!);
                              } else {
                                setState(() {
                                  tips = 'please select device';
                                });
                                if (kDebugMode) {
                                  print('please select device');
                                }
                              }
                            },
                            child: const Text('connect'),
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            onPressed: _connected ? () async {
                              setState(() {
                                tips = 'disconnecting...';
                              });
                              await bluetoothPrint.disconnect();
                            } : null,
                            child: const Text('disconnect'),
                          ),
                        ],
                      ),
                      const Divider(),
                      OutlinedButton(
                        onPressed: _connected ? () async {
                          await bltPrint();
                        } : null,
                        child: const Text('print receipt(esc)'),
                      ),

                      OutlinedButton(
                        onPressed: () async {
                          if (_connected == true) {
                            await bluetoothPrint.printTest();
                          }
                          else {
                            null;
                          }
                        },
                        child: const Text('print selftest'),
                      ),
                      const Text("Thermal Printer",
                          style: TextStyle(fontSize: 25, color: Colors.blue)),
                      TextField(
                        controller: ipCtrl,
                        decoration: const InputDecoration(
                          filled: true,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide( width: 2.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await printReceiptfromThermal(ipCtrl.text);
                        },
                        child: const Text('print from thermal printer'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return FloatingActionButton(
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.search, color: Theme.of(context).cardColor,),
                  onPressed: () =>
                      bluetoothPrint.startScan(
                          timeout: const Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
  Future<void> bltPrint() async{
    Map<String, dynamic> config = {};
    List<String> matNames=[
      'Kitap 2',
      '0 5heetoz 240 gr motor snake',
      'PeaNuts Pisse Dasy Yasyl 100gramlyk',
      'Akyol Kola 1.5'
    ];
    List<String> quantities=[
      '9999.00',
      '9999.00',
      '2.00',
      '1.00',
    ];
    List<String> prices=[
      '11,00',
      '12345,67',
      '13,00',
      '4,40'
    ];
    List<String> totalPrices=[
      '11,00',
      '12345,67',
      '26,00',
      '4,40'
    ];
    final now = DateTime.now();
    final dformatter = DateFormat('dd.MM.yyyy');
    final hformatter=DateFormat('HH:mm:ss');
    final date = dformatter.format(now);
    final time=hformatter.format(now);
    List<LineText> list = [];
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'B_KOMP SERVICE',
        weight: 10,
        size:20,
        width:1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '+99362 29-21-18',
        weight: 10,
        size:10,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Cek No:',
        align: LineText.ALIGN_LEFT,
        x: 40,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '1704810831514',
        align: LineText.ALIGN_LEFT,
        x: 120,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Sene:',
        align: LineText.ALIGN_LEFT,
        x: 320,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: time,
        align: LineText.ALIGN_LEFT,
        x: 385,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Kassir:',
        align: LineText.ALIGN_LEFT,
        x: 60,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '2201116TG',
        align: LineText.ALIGN_LEFT,
        x: 110,
        relativeX: 1,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Sene:',
        align: LineText.ALIGN_LEFT,
        x: 310,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: date,
        align: LineText.ALIGN_LEFT,
        x: 385,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Musderi:',
        align: LineText.ALIGN_LEFT,
        x: 30,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: "Sowetskiy dom 22 Guwanch +99362002007",
        align: LineText.ALIGN_LEFT,
        x: 95,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Bellik:',
        align: LineText.ALIGN_LEFT,
        x: 60,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: '______________________________________________', weight: 3, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'HarytAdy',
        align: LineText.ALIGN_LEFT,
        x: 20,
        relativeX: 0,
        weight:1,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Muk',
        align: LineText.ALIGN_LEFT,
        x: 270,
        relativeX: 0,
        weight:1,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Baha',
        align: LineText.ALIGN_LEFT,
        x: 370,
        relativeX: 0,
        weight:1,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Jemi',
        align: LineText.ALIGN_LEFT,
        x: 480,
        relativeX: 0,
        weight:1,
        linefeed: 1));
    for(int i=0;i<matNames.length;i++){
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: matNames[i].replaceAllMapped(RegExp(r".{19}"), (match) => "${match.group(0)}\n  "),
          align: LineText.ALIGN_LEFT,
          x: 10,
          relativeX: 10,
          linefeed: 0));
      list.add(LineText(type: LineText.TYPE_TEXT,
          content: quantities[i],
          align: LineText.ALIGN_LEFT,
          x: 270,
          relativeX: 0,
          linefeed: 0));
      list.add(LineText(type: LineText.TYPE_TEXT,
          content: prices[i],
          align: LineText.ALIGN_LEFT,
          x: 370,
          relativeX: 0,
          linefeed: 0));
      list.add(LineText(type: LineText.TYPE_TEXT,
          content: totalPrices[i],
          align: LineText.ALIGN_LEFT,
          x: 480,
          relativeX: 0,
          linefeed: 1));
    }
    list.add(LineText(type: LineText.TYPE_TEXT, content: '______________________________________________', weight: 3, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Umumy Jemi:',
        align: LineText.ALIGN_LEFT,
        x: 50,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '296,40',
        align: LineText.ALIGN_LEFT,
        x: 90,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Arz %:',
        align: LineText.ALIGN_LEFT,
        x: 320,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '0,00',
        align: LineText.ALIGN_LEFT,
        x: 385,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Tolenen:',
        align: LineText.ALIGN_LEFT,
        x: 70,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '296,40',
        align: LineText.ALIGN_LEFT,
        x: 90,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Arz Muk:',
        align: LineText.ALIGN_LEFT,
        x: 310,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '0,00',
        align: LineText.ALIGN_LEFT,
        x: 385,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: 'Gaytargy:',
        align: LineText.ALIGN_LEFT,
        x: 60,
        relativeX: 0,
        linefeed: 0));
    list.add(LineText(type: LineText.TYPE_TEXT,
        content: '0,00',
        align: LineText.ALIGN_LEFT,
        x: 90,
        relativeX: 0,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        content:"Sowdanyz ucin sag bolun!",
        weight:1,
        type: LineText.TYPE_TEXT,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 2));
    // ByteData data = await rootBundle.load("assets/images/bluetooth_print.png");
    // List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // String base64Image = base64Encode(imageBytes);
    // list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

    await bluetoothPrint.printReceipt(config, list);
  }
    Future<void> printReceiptfromThermal(String ip) async {
      final profile = await CapabilityProfile.load(name: 'XP-N160I');
      final printer = NetworkPrinter(PaperSize.mm80, profile);
      final res = await printer.connect(ip, port: 9100);
      if (kDebugMode) {
        print('-- Printer connection: $res');
      }
      var printOK2 = await printDemoReceipt(printer);
      if (kDebugMode) {
        print('-- Print(2) finished: ${printOK2 ? 'OK' : 'FAIL'}');
      }
    }

    Future<bool> printDemoReceipt(NetworkPrinter printer) async {
      if (kDebugMode) {
        print('** Printing demo receipt:');
      }
      List<String> matNames=[
        'Kitap 2',
        'MackBook 2',
        'PeaNuts Pisse "Abat"',
        'Akyol Kola 1.5'
      ];
      List<String> quantities=[
        '1.00',
        '1.00',
        '2.00',
        '1.00',
      ];
      List<String> prices=[
        '11,00',
        '209,00',
        '13,00',
        '4,40'
      ];
      List<String> totalPrices=[
        '11,00',
        '209,00',
        '26,00',
        '4,40'
      ];
      final now = DateTime.now();
      final dformatter = DateFormat('dd.MM.yyyy');
      final hformatter=DateFormat('H:mm:ss');
      final date = dformatter.format(now);
      final time=hformatter.format(now);
      printer.text('B_KOMP SERVICE',
          styles: const PosStyles(
            align: PosAlign.center,
            width:PosTextSize.size2,
            bold: true
          ),
          linesAfter: 1);
      printer.text(
          '+99362 10-20-30', styles: const PosStyles(align: PosAlign.center,bold:true),linesAfter: 1);
      printer.row([
      PosColumn(width:1),
      PosColumn(text:'Cek No:',width:2),
      PosColumn(text:'ANHSF-00000299',width:9)
      ]);
      printer.row([
        PosColumn(width:1),
        PosColumn(text:'Kassir:',width:2),
        PosColumn(text:'Kassir 1',width:4),
        PosColumn(text:'Sene:',width:2),
        PosColumn(text:time,width:3)
      ]);
      printer.row([
        PosColumn(width:1),
        PosColumn(text:'Musderi:   ',width:2),
        PosColumn(text:'Nagt Satuw',width:4),
        PosColumn(text:'Sene: ',width:2),
        PosColumn(text:date,width:3)
      ]);
      printer.row([
        PosColumn(width:2),
        PosColumn(text:'Bellik:',width:10),
      ]);
      printer.hr(ch:'_');
      printer.row([
        PosColumn(text: 'HarytAdy', width: 4, styles: const PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(text: 'Muk', width: 2, styles: const PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: 'Olceg', width: 2, styles: const PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: 'Bah', width: 2, styles: const PosStyles(align: PosAlign.right,bold:true)),
        PosColumn(
            text: 'Jemi', width: 2, styles: const PosStyles(align: PosAlign.right,bold:true)),
      ]);
      for(int i=0;i<matNames.length;i++){
        printer.row([
          PosColumn(text: matNames[i], width: 5),
          PosColumn(text:quantities[i],width:2),
          PosColumn(text:'SAN',width:1),
          PosColumn(
              text: prices[i], width: 2, styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: totalPrices[i], width: 2, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }
      printer.hr(ch:'_');
      printer.row([
        PosColumn(width:1),
        PosColumn(text:'Umumy Jemi:',width:3),
        PosColumn(text:'296,40',width:4),
        PosColumn(text:'Arz %:',width:2),
        PosColumn(text:'0,00',width:2)
      ]);
      printer.row([
        PosColumn(width:2),
        PosColumn(text:'Tolenen:',width:3),
        PosColumn(text:'296,40',width:3),
        PosColumn(text:'Arz Muk:  ',width:2),
        PosColumn(text:'0,00',width:2)
      ]);
      printer.row([
        PosColumn(width:2),
        PosColumn(text:'Gaytargy:',width:3),
        PosColumn(text:'0,00',width:7)
      ]);

      printer.feed(2);
      printer.text('Sowdanyz ucin sag bolun!',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      printer.feed(1);
      printer.cut();
      printer.feed(1);

      printer.endJob();

      printer.disconnect(delayMs: 300);

      return true;
    }
  }




