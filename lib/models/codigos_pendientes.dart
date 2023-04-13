import 'dart:convert';


CodigosPendientes codigosPendientesFromJson(String str) =>
    CodigosPendientes.fromJson(json.decode(str));

String codigosPendientesToJson(CodigosPendientes data) =>
    json.encode(data.toJson());

class CodigosPendientes {
  CodigosPendientes(
      {required this.codigo, required this.tienda, required this.venta});

  String codigo;
  String tienda;
  String venta;

  factory CodigosPendientes.fromJson(Map<String, dynamic> json) =>
      CodigosPendientes(
        codigo: json["codigo"],
        tienda: json["nombre"],
        venta: json['venta'],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": tienda,
      };
}
