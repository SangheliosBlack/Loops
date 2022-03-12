import 'dart:convert';

import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';

Busqueda busquedaFromJson(String str) => Busqueda.fromJson(json.decode(str));

class Busqueda {
    Busqueda({
        required this.ok,
        required this.productos,
        required this.tiendas,
    });

    bool ok;
    List<Producto> productos;
    List<Tienda> tiendas;

    factory Busqueda.fromJson(Map<String, dynamic> json) => Busqueda(
        ok: json["ok"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
        tiendas: List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x))),
    );

    
}


