import 'dart:convert';

EstadoPedidoAvanzado estadoPedidoAvanzadoFromJson(String str) =>
    EstadoPedidoAvanzado.fromJson(json.decode(str));

String estadoPedidoAvanzadoToJson(EstadoPedidoAvanzado data) =>
    json.encode(data.toJson());

class EstadoPedidoAvanzado {
  EstadoPedidoAvanzado({
    required this.titulo,
    required this.sub,
    required this.complete,
  });

  String titulo;
  List<Sub> sub;
  bool complete;

  factory EstadoPedidoAvanzado.fromJson(Map<String, dynamic> json) =>
      EstadoPedidoAvanzado(
        titulo: json["titulo"],
        sub: List<Sub>.from(json["sub"].map((x) => Sub.fromJson(x))), complete: json['complete'],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "sub": List<dynamic>.from(sub.map((x) => x.toJson())),
      };
}

class Sub {
  Sub({
    required this.estado,
    required this.titulo,
    required this.time
  });

  bool estado;
  DateTime time;
  String titulo;

  factory Sub.fromJson(Map<String, dynamic> json) => Sub(
    time: DateTime.parse(json["time"]),
        estado: json["estado"],
        titulo: json["Titulo"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "Titulo": titulo,
      };
}
