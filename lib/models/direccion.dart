// To parse this JSON data, do
//
//     final direccion = direccionFromJson(jsonString);

import 'dart:convert';

Direccion direccionFromJson(String str) => Direccion.fromJson(json.decode(str));

String direccionToJson(Direccion data) => json.encode(data.toJson());

class Direccion {
  Direccion({
    required this.id,
    required this.coordenadas,
    required this.predeterminado,
    required this.titulo,
  });

  String id;
  Coordenadas coordenadas;
  bool predeterminado;
  String titulo;

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
        id: json["_id"],
        coordenadas: Coordenadas.fromJson(json["coordenadas"]),
        predeterminado: json["predeterminado"],
        titulo: json["titulo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "coordenadas": coordenadas.toJson(),
        "predeterminado": predeterminado,
        "titulo": titulo,
      };
}

class Coordenadas {
  Coordenadas({
    this.id,
    required this.lat,
    required this.lng,
  });

  String? id;
  num lat;
  num lng;

  factory Coordenadas.fromJson(Map<String, dynamic> json) => Coordenadas(
        id: json["_id"] ?? '',
        lat: json["lat"] ??  json['latitud'],
        lng: json["lng"] ??  json['longitud'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lat": lat,
        "lng": lng,
      };
}
