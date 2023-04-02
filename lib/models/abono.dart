import 'dart:convert';

Abono abonoFromJson(String str) => Abono.fromJson(json.decode(str));

String abonoToJson(Abono data) => json.encode(data.toJson());

class Abono {
  Abono({
    required this.fecha,
    required this.cantidad,
    required this.titulo,
  });

  DateTime fecha;
  num cantidad;
  String titulo;

  factory Abono.fromJson(Map<String, dynamic> json) => Abono(
        fecha: DateTime.parse(json["fecha"]),
        cantidad: json["cantidad"],
        titulo: json["titulo"],
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha.toIso8601String(),
        "cantidad": cantidad,
      };
}
