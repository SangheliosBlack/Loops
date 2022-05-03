import 'dart:convert';

import 'package:delivery/models/productos.dart';

ListaProductos listaProductosFromJson(String str) => ListaProductos.fromJson(json.decode(str));

String listaProductosToJson(ListaProductos data) => json.encode(data.toJson());

class ListaProductos {
    ListaProductos({
        required this.ok,
        required this.productos,
        required this.nombre
    });

    bool ok;
    String nombre;
    List<ListaProductosCategoria> productos;

    factory ListaProductos.fromJson(Map<String, dynamic> json) => ListaProductos(
        ok: json["ok"],
        productos: List<ListaProductosCategoria>.from(json["productos"].map((x) => ListaProductosCategoria.fromJson(x))), nombre: json['nombre'] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class ListaProductosCategoria {
    ListaProductosCategoria({
        required this.titulo,
        required this.productos,
    });

    String titulo;
    List<Producto> productos;

    factory ListaProductosCategoria.fromJson(Map<String, dynamic> json) => ListaProductosCategoria(
        titulo: json["titulo"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}


