import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';

class BusquedaResult {
  final bool cancelo;
  final Tienda? tienda;
  final Producto? producto;

  BusquedaResult({required this.cancelo, this.tienda,this.producto});
}
