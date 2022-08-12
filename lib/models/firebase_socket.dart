import 'dart:convert';

import 'package:delivery/models/venta_response.dart';

FirebaseSocket firebaseSocketfromJson(String str) =>
    FirebaseSocket.fromJson(json.decode(str));

class FirebaseSocket {
  FirebaseSocket({required this.evento, required this.pedido});

  String evento;
  PedidoProducto pedido;

  factory FirebaseSocket.fromJson(Map<String, dynamic> json) => FirebaseSocket(
        evento: json["evento"],
        pedido: PedidoProducto.fromJson(json),
      );
}
