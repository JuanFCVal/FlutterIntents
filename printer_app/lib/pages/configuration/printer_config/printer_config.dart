import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'printer_page_provider.dart';
import 'widgets/printer_tile.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("Impresoras disponibles"),
                    Text("Mis impresoras"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              printProvider.loadingPrinters
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ...printProvider.configuredPrinters
                                  .map((i) => PrinterTile(printer: i))
                                  .toList()
                            ],
                          ),
                        ),
                      )
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
