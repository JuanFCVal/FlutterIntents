//Set named routes
import 'package:flutter/cupertino.dart';

import '../pages/configuration/printer_config/printer_config.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  final routes = {
    'printerconfig': (context) => PrinterPageConfiguration(),
  };
  return routes;
}
