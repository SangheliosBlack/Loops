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
                      child: const Image(
                        image: NetworkImage(
                            'https://www.pequeocio.com/wp-content/uploads/2010/11/hamburguesas-caseras-800x717.jpg'),
                        fit: BoxFit.cover,
                      ),
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
                                const Icon(
                                  Icons.place_outlined,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(producto.tienda,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const SizedBox(width: 1),
                                const Icon(
                                  Icons.schedule,
                                  color: Colors.grey,
                                  size: 10,
                                ),
                                const SizedBox(width: 5),
                                Text('15 - 25 min',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 12, color: Colors.grey)),
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
                              itemBuilder: (context, _) => const FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Color.fromRGBO(200, 201, 203, 1),
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
