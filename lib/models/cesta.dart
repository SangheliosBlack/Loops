import 'dart:convert';

import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';

Cesta cestaFromJson(String str) => Cesta.fromJson(json.decode(str));
String cestaToJson(Cesta data) => json.encode(data.toJson());

class Cesta {
  Cesta(
      {required this.productos,
      required this.total,
      required this.tarjeta,
      required this.direccion,
      required this.efectivo,
      required this.apartado,
      required this.codigo});

  List<Producto> productos;
  num total;
  String tarjeta;
  Direccion direccion;
  bool efectivo;
  bool apartado;
  String codigo;

  factory Cesta.fromJson(Map<String, dynamic> json) => Cesta(
      productos: List<Producto>.from(
          json["productos"].map((x) => Producto.fromJson(x))),
      total: json["total"],
      tarjeta: json["tarjeta"],
      direccion: Direccion.fromJson(json["direccion"]),
      efectivo: json["efectivo"],
      apartado: json['apartado'] ?? false,
      codigo: json['codigo']);

  Map<String, dynamic> toJson() => {
        'apartado': apartado,
        'total': total,
        'tarjeta': tarjeta,
        'direccion': direccion,
        'efectivo': efectivo,
        'codigo': codigo,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
      };
}
