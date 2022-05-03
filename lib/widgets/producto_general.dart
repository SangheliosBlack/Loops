import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/views/extras/ver_producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductoGeneral extends StatelessWidget {
  final Producto producto;

  const ProductoGeneral({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerProductoView(
                    producto: producto,
                  )),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Container(
                  decoration: Styles.containerCustom(8),
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: producto.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg',
                          imageBuilder: (context, imageProvider) => Container(
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
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 92,
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(producto.nombre,
                            style: GoogleFonts.quicksand(fontSize: 20)),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color: Colors.black.withOpacity(.8),
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(producto.tienda,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(.8))),
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
                                Text('15 - 25 min',
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
                              initialRating: 4.5,
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
                              itemSize: 12,
                              unratedColor: Colors.grey.withOpacity(.2),
                              onRatingUpdate: (rating) {},
                            ),
                            const SizedBox(width: 5),
                            Text('(49)',
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey, fontSize: 11)),
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
            child: Row(
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
            ),
          )
        ],
      ),
    );
  }
}
