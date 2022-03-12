import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
    Producto({
        required this.id,
        required this.precio,
        required this.nombre,
        required this.descripcion,
        required this.descuentoP,
        required this.descuentoC,
        required this.disponible,
    });

    String id;
    num precio;
    String nombre;
    String descripcion;
    int descuentoP;
    int descuentoC;
    bool disponible;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["_id"],
        precio: json["precio"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        descuentoP: json["descuentoP"],
        descuentoC: json["descuentoC"],
        disponible: json["disponible"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "precio": precio,
        "nombre": nombre,
        "descripcion": descripcion,
        "descuentoP": descuentoP,
        "descuentoC": descuentoC,
        "disponible": disponible,
    };
}
