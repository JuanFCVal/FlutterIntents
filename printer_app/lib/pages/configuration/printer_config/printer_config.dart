import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'printer_page_provider.dart';
import 'widgets/printer_tile.dart';
import 'widgets/wifi_data.dart';

class PrinterPageConfiguration extends StatelessWidget {
  const PrinterPageConfiguration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PrinterConfigProvider printProvider =
        Provider.of<PrinterConfigProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 18),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const WifiInformation(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          printProvider.availablePrinters.isEmpty
                              ? "Presiona buscar para comenzar :)"
                              : "Impresoras disponibles",
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(
                        height: 20,
                      ),
                      printProvider.loadingPrinters
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            )
                          : Container(),
                      ...printProvider.availablePrinters
                          .map((i) => PrinterTile(printer: i))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                printProvider.testInProgress
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Imprimiendo documento de prueba....",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          onPressed: () {
            printProvider.scan();
          }),
    );
  }
}
