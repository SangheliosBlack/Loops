import 'dart:convert';

import 'package:delivery/models/venta_response.dart';

VentaPro ventaProFromJson(String str) => VentaPro.fromJson(json.decode(str));

class VentaPro {
  VentaPro({
    required this.venta,
    required this.size,
    required this.completados,
    required this.ganancia,
  });

  List<PedidoProducto> venta;
  num size;
  num completados;
  num ganancia;

  factory VentaPro.fromJson(Map<String, dynamic> json) => VentaPro(
      venta: List<PedidoProducto>.from(json['ventas'].map((x) => PedidoProducto.fromJson(x))),
      size: json['size'],
      completados: json['completados'],
      ganancia: json['ganancia']);
}
