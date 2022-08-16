import 'package:flutter/cupertino.dart';
import 'package:pos_printer_manager/pos_printer_manager.dart'
    show NetworkPrinterManager;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:printer_app/models/printer-model.dart';

class PrinterConfigProvider with ChangeNotifier {
  List<PrinterModel> availablePrinters = [];
  List<PrinterModel> configuredPrinters = [];
  bool loadingPrinters = false;
  bool testInProgress = false;

  set loadingPrintersState(bool value) {
    loadingPrinters = value;
    notifyListeners();
  }

  set testInProgressState(bool value) {
    testInProgress = value;
    notifyListeners();
  }

  scan() async {
    availablePrinters = [];
    try {
      loadingPrintersState = true;
      var printers = await NetworkPrinterManager.discover();
      for (var element in printers) {
        availablePrinters.add(PrinterModel(ip: element.name!, state: 0));
      }
      verifyIfAvailablePrinterIsConfigured();
      notifyListeners();
      loadingPrintersState = false;
    } catch (e) {
      loadingPrintersState = false;
    }
  }

  addFromAvailableToConfigured(PrinterModel printer) {
    printer.state = 1;
    configuredPrinters.add(printer);
    availablePrinters.remove(printer);
    notifyListeners();
  }

  removeFromConfiguredToAvailable(PrinterModel printer) {
    printer.state = 0;
    availablePrinters.add(printer);
    configuredPrinters.remove(printer);
    notifyListeners();
  }

  printReceip(PrinterModel printerToPrint) async {
    testInProgressState = true;
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect(printerToPrint.ip, port: 9100);
    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }
    debugPrint('Print result: ${res.msg}');
    testInProgressState = false;
    return '${res.msg} ${printerToPrint.ip}';
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  void fromtext(NetworkPrinter printer, value) {
    printer.text(value, styles: const PosStyles(codeTable: 'CP1252'));
    printer.feed(2);
    printer.cut();
  }

  printFromIntent(value) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res =
        await printer.connect('192.168.1.120', port: 9100);

    if (res == PosPrintResult.success) {
      fromtext(printer, "Printing from ionic");
      printer.disconnect();
    }

    debugPrint('Print result: ${res.msg}');
  }

  verifyIfAvailablePrinterIsConfigured() {
    for (var availablePrinter in availablePrinters) {
      for (var configuredPrinter in configuredPrinters) {
        if (availablePrinter.ip == configuredPrinter.ip) {
          availablePrinter.state = 2;
        }
      }
    }
    notifyListeners();
  }
}
