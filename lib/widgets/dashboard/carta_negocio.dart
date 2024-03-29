import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/views/tienda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartaNegocio extends StatelessWidget {
  final bool small;
  final Tienda tienda;

  const CartaNegocio({Key? key, required this.tienda, required this.small})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final direccionesService = Provider.of<DireccionesService>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoreIndividual(
                    tienda: tienda,
                  )),
        );
      },
      child: SizedBox(
        width: 240,
        child: Column(
          children: [
            Hero(
              tag: tienda.uid,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: tienda.imagenPerfil,
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
                            padding: const EdgeInsets.all(100),
                            child: const CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.black,
                            )),
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error);
                        })),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 4, top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: tienda.online
                                      ? Colors.green
                                      : Colors.red)),
                          Text(
                            tienda.online ? 'Abierto' : 'Cerrado',
                            style: GoogleFonts.quicksand(
                                fontSize: 11, color: Colors.black),
                          )
                        ],
                      ),
                      Text(
                        tienda.nombre,
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: 5,
                      ignoreGestures: true,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => FaIcon(
                        FontAwesomeIcons.solidStar,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(1),
                      ),
                      itemSize: 13,
                      unratedColor: Colors.grey.withOpacity(.2),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(width: 5),
                    // Text('(49)',
                    //     style: GoogleFonts.quicksand(
                    //         color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                direccionesService.direcciones.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              color: Colors.black,
                              size: 14,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${(calculateDistance(lat1: tienda.coordenadas.latitud, lon1: tienda.coordenadas.longitud, lat2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lat, lon2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lng).toStringAsFixed(2))} km',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  color: Colors.black, fontSize: 13),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '|',
                                style: GoogleFonts.quicksand(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(1)),
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 1),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.black.withOpacity(.8),
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Text('${tienda.tiempoEspera} min',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(.8))),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }
}
