import 'package:delivery/models/productos.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/extras/ver_producto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductoGeneralSocio extends StatelessWidget {
  final Producto producto;

  const ProductoGeneralSocio({Key? key, required this.producto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pantallasService = Provider.of<LlenarPantallasService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerProductoView(
                  soloTienda: true,
                  producto: producto,
                  tienda: pantallasService.tiendas.firstWhere(
                      (element) => element.nombre == producto.tienda)),
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(producto.nombre,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(fontSize: 16)),
            ],
          ),
          Text('\$ ' + producto.precio.toStringAsFixed(2),
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: const Color.fromRGBO(47, 47, 47, .9),
              ))
        ],
      ),
    );
  }
}
