
import 'dart:convert';

import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';

Categorias categoriasFromJson(String str) => Categorias.fromJson(json.decode(str));


class Categorias {
    Categorias({
        required this.ok,
        required this.productos,
    });

    bool ok;
    List<Item> productos;

    factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        ok: json["ok"],
        productos: List<Item>.from(json["productos"].map((x) => Item.fromJson(x))),
    );
   
}

class Item {
    Item({
        required this.id,
        required this.productos,
        required this.tienda,
        required this.index,
    });

    String id;
    Producto productos;
    Tienda tienda;
    int index;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        productos: Producto.fromJson(json["producto"]),
        tienda:Tienda.fromJson(json["tienda"]),
        index: json["index"],
    );

  
}


