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
      required this.hot,
      required this.extra,
      required this.sugerencia,
      required this.imagen,
      required this.opciones});

  String id;
  num precio;
  String nombre;
  String descripcion;
  int descuentoP;
  int descuentoC;
  int hot;
  bool disponible;
  String tienda;
  List<Opcion> opciones;
  num cantidad;
  String imagen;
  num extra;
  bool sugerencia;
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
        hot: json["hot"] ?? 0,
        tienda: json['tienda'],
        sku: json['sku'] ?? '',
        extra: json['extra'] ?? 0,
        opciones:
            List<Opcion>.from(json["opciones"].map((x) => Opcion.fromJson(x))),
        imagen: '',
        sugerencia: json["sugerencia"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "precio": precio,
        "nombre": nombre,
        "descripcion": descripcion,
        "descuentoP": descuentoP,
        "descuentoC": descuentoC,
        "hot": hot,
        "disponible": disponible,
        "tienda": tienda,
        "cantidad": cantidad,
        "extra": extra,
        "sku": sku,
        "imagen ": imagen,
        "opciones": List<dynamic>.from(opciones.map((x) => x.toJson()))
      };
}

Opcion opcionFromJson(String str) => Opcion.fromJson(json.decode(str));

class Opcion extends Equatable {
  Opcion(
      {required this.titulo,
      required this.listado,
      required this.maximo,
      required this.minimo});

  String titulo;
  List<Listado> listado;
  int maximo;
  int minimo;

  factory Opcion.fromJson(Map<String, dynamic> json) => Opcion(
        titulo: json["titulo"],
        listado:
            List<Listado>.from(json["listado"].map((x) => Listado.fromJson(x))),
        minimo: json["minimo"],
        maximo: json["maximo"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "listado": listado,
        "maximo": maximo,
        "minimo": minimo,
      };

  @override
  List<Object?> get props => [titulo, listado];
}

class Listado extends Equatable {
  Listado(
      {required this.precio,
      required this.tipo,
      required this.hot,
      required this.activo,
      required this.auto,
      required this.fijo});

  int precio;
  int hot;
  String tipo;
  bool activo;
  bool auto;
  bool fijo;

  factory Listado.fromJson(Map<String, dynamic> json) => Listado(
      auto: json["auto"] ?? false,
      precio: json["precio"],
      tipo: json["tipo"] ?? false,
      activo: json['activo'] ?? false,
      fijo: json['fijo'] ?? false,
      hot: json['hot'] ?? 0);

  Map<String, dynamic> toJson() => {
        "precio": precio,
        "tipo": tipo,
        "auto": auto,
        "activo": activo,
        "fijo": fijo
      };

  @override
  List<Object?> get props => [precio, tipo, activo];
}
