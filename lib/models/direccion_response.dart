// To parse this JSON data, do
//
//     final direccionResponse = direccionResponseFromJson(jsonString);

import 'dart:convert';

Direccion direccionResponseFromJson(String str) =>
    Direccion.fromJson(json.decode(str));

String direccionResponseToJson(Direccion data) => json.encode(data.toJson());

class Direccion {
  Direccion(
      {required this.id,
      required this.predeterminado,
      required this.texto,
      required this.descripcion,
      required this.coordenadas,
      required this.icono});

  String id;
  bool predeterminado;
  String texto;
  String descripcion;
  Coordenadas coordenadas;
  int icono;

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
      id: json["_id"],
      predeterminado: json["predeterminado"],
      texto: json["texto"],
      descripcion: json["descripcion"],
      coordenadas: Coordenadas.fromJson(json["coordenadas"]),
      icono: json["icono"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "texto": texto,
        "predeterminado": predeterminado,
        "descripcion": descripcion,
        "coordenadas": coordenadas.toJson(),
        "icono": icono,
      };
}

class Coordenadas {
  Coordenadas({
    required this.id,
    required this.latitud,
    required this.longitud,
  });

  String id;
  double latitud;
  double longitud;

  factory Coordenadas.fromJson(Map<String, dynamic> json) => Coordenadas(
        id: json["_id"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "latitud": latitud,
        "longitud": longitud,
      };
}
