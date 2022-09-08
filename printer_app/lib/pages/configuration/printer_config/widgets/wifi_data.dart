import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/wifi-data.dart';
import '../printer_page_provider.dart';

class WifiInformation extends StatefulWidget {
  const WifiInformation({Key? key}) : super(key: key);

  @override
  State<WifiInformation> createState() => _WifiInformationState();
}

class _WifiInformationState extends State<WifiInformation> {
  WifiData wifi = WifiData();
  @override
  initState() {
    //Get Wifi Network Information
    getWifiInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Red: ${wifi.wifiName ?? "No disponible"}",
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          "IP: ${wifi.wifiBSID ?? " No disponible"}",
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

  getWifiInformation() async {
    wifi = await Provider.of<PrinterConfigProvider>(context, listen: false)
        .getWifiInformation();
    setState(() {});
    print(wifi.wifiName);
  }
}
