
import 'dart:convert';

import 'package:delivery/models/productos.dart';

Categorias categoriasFromJson(String str) => Categorias.fromJson(json.decode(str));


class Categorias {
    Categorias({
        required this.ok,
        required this.productos,
    });

    bool ok;
    List<Producto> productos;

    factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        ok: json["ok"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );
   
}




