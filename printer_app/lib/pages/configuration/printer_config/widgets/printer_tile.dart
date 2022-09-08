import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/printer-model.dart';
import '../../../../utils/snackbars.dart';
import '../printer_page_provider.dart';

class PrinterTile extends StatelessWidget {
  const PrinterTile({Key? key, required this.printer}) : super(key: key);
  final PrinterModel printer;
  @override
  Widget build(BuildContext context) {
    PrinterConfigProvider printProvider =
        Provider.of<PrinterConfigProvider>(context);
    return InkWell(
      onDoubleTap: () {
        print("Printer selected: ${printer.ip}");
        !printProvider.testInProgress
            ? () async {
                final response = await printProvider.printReceip(printer);
                // ignore: use_build_context_synchronously
                UtilitiesSnackBar.showInformativeSnackBar(context, response);
              }
            : null;
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  printer.ip,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(printer.name ?? printer.ip,
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          )

          // ListTile(
          //   title: Text(
          //     printer.ip,
          //     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //   ),
          //   subtitle: Text(
          //     printer.name ?? printer.ip,
          //     style: const TextStyle(fontSize: 12),
          //   ),
          //   trailing: printer.state == 0
          //       ? IconButton(
          //           icon: const Icon(Icons.add),
          //           onPressed: () {
          //             printProvider.addFromAvailableToConfigured(printer);
          //           },
          //         )
          //       : printer.state == 1
          //           ? IconButton(
          //               icon: const Icon(Icons.delete),
          //               onPressed: () {
          //                 printProvider.removeFromConfiguredToAvailable(printer);
          //               },
          //             )
          //           : IconButton(
          //               icon: const Icon(Icons.check),
          //               onPressed: () {
          //                 printProvider.removeFromConfiguredToAvailable(printer);
          //               },
          //             ),
          // ),
          ),
    );
  }
}
