import 'dart:async';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_printer_manager/pos_printer_manager.dart'
    show NetworkPrinterManager, NetWorkPrinter;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _mChannel =
      MethodChannel('receive_sharing_intent/messages');
  late StreamSubscription _intentDataStreamSubscription;
  String _sharedText = "";
  List<String> printers = [];

  @override
  void initState() {
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        // printFromIntent();
        print("**************************************** creating subscription");
        print(value);
        if (value != null) {
          printFromIntent(value);
        } else {
          print("value is null on create");
        }
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
    ReceiveSharingIntent.getInitialText().then((value) async {
      print("**************************************** Updating subscription");
      print(value);
      if (value != null) {
        printFromIntent(value);
        print("HOLAAAAAAAAA");
        // print(value.runtimeType);
      } else {
        print("value is null on update");
      }
      setState(() {
        //printFromIntent();
        _sharedText = value ?? "";
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    print("Listener disposed");
    super.dispose();
  }

  static Future<String?> getInitialText() async {
    return await _mChannel.invokeMethod('getInitialText');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 500,
                child: ListView(
                  children: printers
                      .map((e) => InkWell(
                            onTap: () {
                              printReceip(e);
                            },
                            child: ListTile(
                              title: Text(e),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Text("Shared urls/text:"),
              Text(_sharedText)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _scan();
          },
        ),
      ),
    );
  }

  _scan() async {
    List<NetWorkPrinter> networkPrinters = [];
    var printers = await NetworkPrinterManager.discover();
    for (var element in printers) {
      this.printers.add(element.name!);
    }
    setState(() {});
  }

  printReceip(String value) async {
    print(value);
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(value, port: 9100);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
  }

  printFromIntent(value) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final value2 = value ?? "Printing from ionic";
    final PosPrintResult res =
        await printer.connect('192.168.1.120', port: 9100);

    if (res == PosPrintResult.success) {
      fromtext(printer, "Printing from ionic");
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  void fromtext(NetworkPrinter printer, value) {
    printer.text(value, styles: PosStyles(codeTable: 'CP1252'));
    printer.feed(2);
    printer.cut();
  }
}
