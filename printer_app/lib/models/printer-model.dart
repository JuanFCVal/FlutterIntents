// To parse this JSON data, do
//
//     final printerModel = printerModelFromJson(jsonString);

import 'dart:convert';

PrinterModel printerModelFromJson(String str) =>
    PrinterModel.fromJson(json.decode(str));

String printerModelToJson(PrinterModel data) => json.encode(data.toJson());

class PrinterModel {
  PrinterModel({
    required this.ip,
    this.name,
    this.port,
    this.state, //0 - available, 1 - configured, 2 - unavailable
  });

  final String ip;
  String? name;
  String? port;
  int? state;

  factory PrinterModel.fromJson(Map<String, dynamic> json) => PrinterModel(
        ip: json["ip"],
        name: json["name"],
        port: json["port"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "name": name,
        "port": port,
        "state": state,
      };
}
