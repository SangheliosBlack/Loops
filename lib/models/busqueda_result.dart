import 'package:delivery/models/tienda.dart';

class BusquedaResult {
  final bool cancelo;
  final Tienda ?tienda;

  BusquedaResult({required this.cancelo, this.tienda});
}
