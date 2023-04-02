import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/extras/ver_producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductoGeneral extends StatelessWidget {
  final Producto producto;
  final bool noHit;

  const ProductoGeneral({Key? key, required this.producto, this.noHit = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pantallasService = Provider.of<LlenarPantallasService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: noHit? () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerProductoView(
                  producto: producto,
                  tienda: pantallasService.tiendas.firstWhere(
                      (element) => element.nombre == producto.tienda)),
            ));
      } :null,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  width: 95,
                  height: 95,
                  child: Hero(
                    tag: producto.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: producto.imagen.isNotEmpty
                          ? CachedNetworkImage(
                              key: UniqueKey(),
                              fit: BoxFit.cover,
                              imageUrl:
                                  'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(.15),
                                          BlendMode.color,
                                        ),
                                      ),
                                    ),
                                  ),
                              placeholder: (context, url) => Container(
                                  padding: const EdgeInsets.all(30),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.black,
                                  )),
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.error);
                              })
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey.withOpacity(.1))),
                              child: const Icon(Icons.image)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 95,
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(producto.nombre,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(fontSize: 18)),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            producto.hot > 0
                                ? RatingBar.builder(
                                    initialRating:
                                        double.parse(producto.hot.toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const FaIcon(
                                      FontAwesomeIcons.fireFlameCurved,
                                      color: Colors.red,
                                    ),
                                    itemSize: 11,
                                    unratedColor: Colors.grey.withOpacity(.4),
                                    onRatingUpdate: (rating) {},
                                  )
                                : Container(),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: Colors.black.withOpacity(.8),
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    producto.tienda,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(.8)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const SizedBox(width: 1),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.black.withOpacity(.8),
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                    '${pantallasService.tiendas.firstWhere((element) => element.nombre == producto.tienda).tiempoEspera} min',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(.8))),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.black.withOpacity(.8),
                              ),
                              itemSize: 11,
                              unratedColor: Colors.grey.withOpacity(.2),
                              onRatingUpdate: (rating) {},
                            ),
                            // const SizedBox(width: 5),
                            // Text('(49)',
                            //     style: GoogleFonts.quicksand(
                            //         color: Colors.grey, fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                producto.opciones.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Desde',
                          style: GoogleFonts.quicksand(
                            fontSize: 12,
                            color: Colors.grey.withOpacity(.7),
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      producto.precio.toStringAsFixed(2),
                      style: GoogleFonts.quicksand(
                        fontSize: 25,
                        color: const Color.fromRGBO(47, 47, 47, .9),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
