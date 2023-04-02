import 'package:delivery/models/productos.dart';

class BusquedaResultPrenda {
  final bool cancelo;
  final Producto ?producto;
  BusquedaResultPrenda({ this.producto,required this.cancelo});
}
