import 'package:flutter/material.dart';
import 'package:printer_app/routes/routes.dart';
import 'package:provider/provider.dart';

import 'pages/configuration/printer_config/printer_page_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrinterConfigProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        routes: getAppRoutes(),
        initialRoute: 'printerconfig',
      ),
    );
  }
}
