import 'package:flutter/material.dart';

class UtilitiesSnackBar {
  //Show generic SnackBar
  static void showInformativeSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
