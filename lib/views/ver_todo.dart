import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/haversine.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/tienda.dart';
import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerTodoView extends StatelessWidget {
  final String titulo;

  const VerTodoView({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final tiendaService = Provider.of<TiendasService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          titulo,
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(
              color: Colors.black.withOpacity(.8), fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        /*actions: [
          GestureDetector(
            onTap: () async {
              try {} catch (e) {
                debugPrint('Ningun lugar seleccionado');
              }
            },
            child: Container(
                height: 80,
                width: 45,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: const Center(
                        child: Icon(
                      Icons.search,
                      color: Colors.black,
                    )))),
          ),
        ],*/
      ),
      body: titulo == 'Establecimientos'
          ? FutureBuilder(
              future: tiendaService.verTodoTienda(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Tienda>> snapshot) {
                final direccionesService =
                    Provider.of<DireccionesService>(context);
                final authService = Provider.of<AuthService>(context);

                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: snapshot.hasData
                        ? GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: snapshot.data?.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    mainAxisExtent: 110,
                                    maxCrossAxisExtent: width),
                            itemBuilder: (BuildContext context, int index) {
                              Tienda tienda = snapshot.data![index];
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreIndividual(
                                              tienda: tienda,
                                            )),
                                  );
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
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.black
                                                            .withOpacity(.15),
                                                        BlendMode.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        const CircularProgressIndicator(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: tienda.online
                                                          ? Colors.green
                                                          : Colors.red)),
                                              Text(
                                                tienda.online
                                                    ? 'Abierto'
                                                    : 'Cerrado',
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
                                                color: Colors.black,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 0),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  tienda.nombre,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black
                                                              .withOpacity(.7),
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
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const FaIcon(
                                              FontAwesomeIcons.solidStar,
                                              color: Color.fromRGBO(
                                                  41, 199, 184, 1),
                                            ),
                                            itemSize: 11,
                                            unratedColor:
                                                Colors.grey.withOpacity(.4),
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
                                                  child: direccionesService
                                                          .direcciones
                                                          .isNotEmpty
                                                      ? Text(
                                                          '${(calculateDistance(lat1: tienda.coordenadas.latitud, lon1: tienda.coordenadas.longitud, lat2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lat, lon2: direccionesService.direcciones[authService.usuario.cesta.direccion.titulo != '' ? direccionesService.direcciones.indexWhere((element) => authService.usuario.cesta.direccion.titulo == element.titulo) : obtenerFavorito(direccionesService.direcciones) != -1 ? obtenerFavorito(direccionesService.direcciones) : 0].coordenadas.lng).toStringAsFixed(2))} km | ${tienda.direccion} ',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  color: Colors
                                                                      .black,
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
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LinearProgressIndicator(
                                minHeight: 1,
                                backgroundColor:
                                    Color.fromRGBO(234, 248, 248, 0),
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )
                            ],
                          ));
              },
            )
          : FutureBuilder(
              future: tiendaService.verTodoProductos(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Producto>> snapshot) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: snapshot.hasData
                        ? ListView.separated(
                            padding: const EdgeInsets.all(20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProductoGeneral(
                                producto: snapshot.data![index],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 10,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromRGBO(234, 248, 248, 0),
                                color: Color.fromRGBO(62, 204, 191, 1),
                              )
                            ],
                          ));
              },
            ),
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }
}
