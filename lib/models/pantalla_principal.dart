// To parse this JSON data, do
//
//     final pantallaPrincipal = pantallaPrincipalFromJson(jsonString);

import 'dart:convert';

import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';

PantallaPrincipal pantallaPrincipalFromJson(String str) => PantallaPrincipal.fromJson(json.decode(str));

String pantallaPrincipalToJson(PantallaPrincipal data) => json.encode(data.toJson());

class PantallaPrincipal {
    PantallaPrincipal({
        required this.tiendas,
        required this.productos,
        required this.categorias,
    });

    List<Tienda> tiendas;
    List<Producto> productos;
    List<String> categorias;

    factory PantallaPrincipal.fromJson(Map<String, dynamic> json) => PantallaPrincipal(
        tiendas: List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x))),
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
        categorias: List<String>.from(json["categorias"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "tiendas": List<dynamic>.from(tiendas.map((x) => x.toJson())),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "categorias": List<dynamic>.from(categorias.map((x) => x)),
    };
}




