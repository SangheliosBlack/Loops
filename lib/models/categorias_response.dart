
import 'dart:convert';

import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';

Categorias categoriasFromJson(String str) => Categorias.fromJson(json.decode(str));


class Categorias {
    Categorias({
        required this.ok,
        required this.productos,
        required this.tiendas,
    });

    bool ok;
    List<Producto> productos;
    List<Tienda> tiendas;

    factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        ok: json["ok"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
        tiendas: List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x))),
    );
   
}




