import 'dart:convert';

import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';

Cesta cestaFromJson(String str) => Cesta.fromJson(json.decode(str));

class Cesta {
  Cesta(
      {required this.productos,
      required this.total,
      required this.tarjeta,
      required this.direccion,
      required this.efectivo,
      required this.codigo});

  List<Producto> productos;
  num total;
  String tarjeta;
  Direccion direccion;
  bool efectivo;
  String codigo;

  factory Cesta.fromJson(Map<String, dynamic> json) => Cesta(
      productos: List<Producto>.from(json["productos"].map((x) => x)),
      total: json["total"],
      tarjeta: json["tarjeta"],
      direccion: Direccion.fromJson(json["direccion"]),
      efectivo: json["efectivo"],
      codigo: json['codigo']);
}
