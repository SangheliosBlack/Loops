import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/busqueda_result.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../service/auth_service.dart';

class SearchBusqueda extends SearchDelegate<BusquedaResult> {
  @override
  // ignore: overridden_fields
  final String searchFieldLabel;
  final TrafficService _trafficService;

  SearchBusqueda()
      : searchFieldLabel = 'Buscar',
        _trafficService = TrafficService();

  @override
  ThemeData appBarTheme(BuildContext context) {
    // You can use Theme.of(context) directly too
    var superThemeData = super.appBarTheme(context);

    return superThemeData.copyWith(
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          toolbarHeight: 74,
          elevation: 0,
          backgroundColor: Colors.white),
      textTheme: superThemeData.textTheme
          .copyWith(headline6: GoogleFonts.quicksand(color: Colors.black)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, BusquedaResult(cancelo: true)),
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: query.isEmpty
            ? Container(
                width: 500,
                color: Colors.white,
                child: ListView(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Que buscamos ?',
                        style: GoogleFonts.quicksand(),
                      ),
                      /*onTap: () {
                close(context, BusquedaResult(cancelo: cancelo));
              },*/
                    )
                  ],
                ),
              )
            : _construirResultadosSugerencias());
  }

  Widget _construirResultadosSugerencias() {
    if (query.isEmpty) {
      return Container();
    }

    _trafficService.getBusquedaPorQuery(query.trim());

    return StreamBuilder(
      stream: _trafficService.busquedaStream,
      builder: (BuildContext context, AsyncSnapshot<Busqueda> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: const [
                LinearProgressIndicator(
                  minHeight: 1,
                  color: Color.fromRGBO(41, 199, 184, 1),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        }
        final lugares = snapshot.data!.tiendas;
        if (lugares.isEmpty) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'No hay resultados con $query',
                    style: GoogleFonts.quicksand(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: lugares.length,
            separatorBuilder: (_, i) => Divider(
              color: Colors.grey.withOpacity(.0),
            ),
            itemBuilder: (_, i) {
              final tienda = lugares[i];
              final authService = Provider.of<AuthService>(context);
              final direccionesService =
                  Provider.of<DireccionesService>(context);
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  close(
                      context, BusquedaResult(cancelo: false, tienda: tienda));
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: 85,
                        height: 85,
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
                                padding: const EdgeInsets.all(10),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                )),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error);
                            }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
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
                                    fontSize: 11,
                                    color: tienda.online
                                        ? Colors.green
                                        : Colors.red),
                              )
                            ],
                          ),
                          Text(
                            'Restaurante',
                            style: GoogleFonts.quicksand(
                                color: Colors.black, fontSize: 12),
                          ),
                          const SizedBox(height: 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  tienda.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.playfairDisplay(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(.7),
                                      fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
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
                              color: Color.fromRGBO(41, 199, 184, 1),
                            ),
                            itemSize: 11,
                            unratedColor: Colors.grey.withOpacity(.4),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                  child:
                                      direccionesService.direcciones.isNotEmpty
                                          ? Text(
                                              '${(calculateDistance(lat1: tienda.coordenadas.latitud, lon1: tienda.coordenadas.longitud, lat2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lat, lon2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lng).toStringAsFixed(2))} km | ${tienda.direccion} ',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            )
                                          : Container())
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }
}
