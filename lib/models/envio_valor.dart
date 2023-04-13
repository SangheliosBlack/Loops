// To parse this JSON data, do
//
//     final envioValor = envioValorFromJson(jsonString);

import 'dart:convert';

EnvioValor envioValorFromJson(String str) => EnvioValor.fromJson(json.decode(str));

String envioValorToJson(EnvioValor data) => json.encode(data.toJson());

class EnvioValor {
    EnvioValor({
        required this.cantidad,
        required this.tienda,
    });

    double cantidad;
    String tienda;

    factory EnvioValor.fromJson(Map<String, dynamic> json) => EnvioValor(
        cantidad: json["cantidad"]?.toDouble(),
        tienda: json["tienda"],
    );

    Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
        "tienda": tienda,
    };
}
