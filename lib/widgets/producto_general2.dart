import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/views/extras/ver_producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductoGeneral2 extends StatelessWidget {
  final Tienda tienda;
  final Producto producto;

  const ProductoGeneral2(
      {Key? key, required this.producto, required this.tienda})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerProductoView(
                    producto: producto,
                    soloTienda: false,
                    tienda: tienda,
                  )),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: Styles.containerCustom(),
            child: Row(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: producto.nombre,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: producto.imagen.isNotEmpty
                            ? Image(
                                image:
                                    CachedNetworkImageProvider(producto.imagen),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.grey.withOpacity(.1))),
                                child: const Icon(Icons.image))),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(producto.nombre,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black.withOpacity(.8),
                                          fontSize: 20)),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                producto.hot > 0
                                    ? RatingBar.builder(
                                        initialRating: double.parse(
                                            producto.hot.toString()),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) =>
                                            const FaIcon(
                                          FontAwesomeIcons.fireFlameCurved,
                                          color: Colors.red,
                                        ),
                                        itemSize: 11,
                                        unratedColor:
                                            Colors.grey.withOpacity(.4),
                                        onRatingUpdate: (rating) {},
                                      )
                                    : Container()
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(producto.descripcion,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 5),
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
                              itemBuilder: (context, _) => const FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Colors.grey,
                              ),
                              itemSize: 12,
                              unratedColor: Colors.grey.withOpacity(.4),
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
            bottom: 0,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 15, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      producto.precio.toStringAsFixed(2),
                      style: GoogleFonts.quicksand(
                          fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
