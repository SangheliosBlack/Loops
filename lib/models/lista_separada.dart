

import 'dart:convert';

import 'package:delivery/models/productos.dart';

ListaSeparada listaSeparadaFromJson(String str) => ListaSeparada.fromJson(json.decode(str));

String listaSeparadaToJson(ListaSeparada data) => json.encode(data.toJson());

class ListaSeparada {
    ListaSeparada({
        required this.ok,
        required this.separados,
    });

    bool ok;
    List<Separado> separados;

    factory ListaSeparada.fromJson(Map<String, dynamic> json) => ListaSeparada(
        ok: json["ok"],
        separados: List<Separado>.from(json["separados"].map((x) => Separado.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "separados": List<dynamic>.from(separados.map((x) => x.toJson())),
    };
}

class Separado {
    Separado({
        required this.linea,
        required this.productos,
    });

    int linea;
    List<Producto> productos;

    factory Separado.fromJson(Map<String, dynamic> json) => Separado(
        linea: json["linea"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "linea": linea,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

