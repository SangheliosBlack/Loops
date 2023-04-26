// To parse this JSON data, do
//
//     final estadoSistema = estadoSistemaFromJson(jsonString);

import 'dart:convert';

EstadoSistema estadoSistemaFromJson(String str) =>
    EstadoSistema.fromJson(json.decode(str));

String estadoSistemaToJson(EstadoSistema data) => json.encode(data.toJson());

class EstadoSistema {
  EstadoSistema(
      {required this.mantenimiento,
      required this.restringido,
      required this.disponible,
      required this.cerrada,
      required this.version});

  bool mantenimiento;
  bool restringido;
  bool disponible;
  String version;
  bool cerrada;

  factory EstadoSistema.fromJson(Map<String, dynamic> json) => EstadoSistema(
        mantenimiento: json["mantenimiento"],
        restringido: json["restringido"],
        disponible: json["disponible"],
        cerrada: json["cerrada"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "mantenimiento": mantenimiento,
        "restringido": restringido,
        "disponible": disponible,
        "version": version,
        "cerrada": cerrada,
      };
}
