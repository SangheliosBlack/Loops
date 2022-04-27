// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto(
      {required this.id,
      required this.precio,
      required this.nombre,
      required this.descripcion,
      required this.descuentoP,
      required this.descuentoC,
      required this.disponible,
      required this.tienda,
      required this.cantidad,
      required this.sku,
      required this.opciones});

  String id;
  num precio;
  String nombre;
  String descripcion;
  int descuentoP;
  int descuentoC;
  bool disponible;
  String tienda;
  List<Opcion> opciones;
  num cantidad ;
  String sku;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["_id"],
        precio: json["precio"],
        cantidad: json["cantidad"] ?? 0,
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        descuentoP: json["descuentoP"],
        descuentoC: json["descuentoC"],
        disponible: json["disponible"],
        tienda: json['tienda'],
        sku:json['sku'] ?? '',
        opciones:
            List<Opcion>.from(json["opciones"].map((x) => Opcion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "precio": precio,
        "nombre": nombre,
        "descripcion": descripcion,
        "descuentoP": descuentoP,
        "descuentoC": descuentoC,
        "disponible": disponible,
        "sku": sku,
        "opciones": opciones
      };
}

Opcion opcionFromJson(String str) => Opcion.fromJson(json.decode(str));

class Opcion extends Equatable {
  Opcion({
    required this.titulo,
    required this.listado,
  });

  String titulo;
  List<Listado> listado;

  factory Opcion.fromJson(Map<String, dynamic> json) => Opcion(
        titulo: json["titulo"],
        listado:
            List<Listado>.from(json["listado"].map((x) => Listado.fromJson(x))),
      );

  @override
  List<Object?> get props => [titulo, listado];
}

class Listado extends Equatable {
  Listado({required this.precio, required this.tipo, required this.activo});

  int precio;
  String tipo;
  bool activo;

  factory Listado.fromJson(Map<String, dynamic> json) => Listado(
      precio: json["precio"],
      tipo: json["tipo"],
      activo: json['activo'] ?? false);

  Map<String, dynamic> toJson() => {
        "precio": precio,
        "tipo": tipo,
      };

  @override
  List<Object?> get props => [precio, tipo, activo];
}
