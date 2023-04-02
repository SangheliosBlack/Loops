// To parse this JSON data, do
//
//     final promocion = promocionFromJson(jsonString);

import 'dart:convert';

Promocion promocionFromJson(String str) => Promocion.fromJson(json.decode(str));

String promocionToJson(Promocion data) => json.encode(data.toJson());

class Promocion {
    Promocion({
        required this.titulo,
        required this.cantidad,
        required this.descuento,
        required this.activo,
        required this.sku,
        required this.id,
    });

    String titulo;
    String id;
    int cantidad;
    int descuento;
    bool activo;
    String sku;

    factory Promocion.fromJson(Map<String, dynamic> json) => Promocion(
        titulo: json["titulo"],
        cantidad: json["cantidad"],
        descuento: json["descuento"],
        activo: json["activo"],
        sku: json["sku"], id: json['_id'],
    );

    Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "cantidad": cantidad,
        "descuento": descuento,
        "activo": activo,
        "sku": sku,
    };
}
