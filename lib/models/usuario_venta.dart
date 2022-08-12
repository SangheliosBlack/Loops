import 'dart:convert';

UsuarioVenta usuarioVentaFromJson(String str) =>
    UsuarioVenta.fromJson(json.decode(str));

class UsuarioVenta {
  UsuarioVenta({
    required this.imagen,
    required this.id,
    required this.nombre,
  });

  String id;
  String nombre;
  String imagen;

  factory UsuarioVenta.fromJson(Map<String, dynamic> json) => UsuarioVenta(
      imagen: json['imagen'], id: json['_id'] ?? json['uid'], nombre: json['nombre']);
}
