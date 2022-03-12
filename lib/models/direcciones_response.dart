// To parse this JSON data, do
//
//     final direccionesResponse = direccionesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:delivery/models/direccion_response.dart';

DireccionesResponse direccionesResponseFromJson(String str) => DireccionesResponse.fromJson(json.decode(str));

String direccionesResponseToJson(DireccionesResponse data) => json.encode(data.toJson());

class DireccionesResponse {
    DireccionesResponse({
        required this.ok,
        required this.direcciones,
    });

    bool ok;
    List<Direccion> direcciones;

    factory DireccionesResponse.fromJson(Map<String, dynamic> json) => DireccionesResponse(
        ok: json["ok"],
        direcciones: List<Direccion>.from(json["direcciones"].map((x) => Direccion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "direcciones": List<dynamic>.from(direcciones.map((x) => x.toJson())),
    };
}

