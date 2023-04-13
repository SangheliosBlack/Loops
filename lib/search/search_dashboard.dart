import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/busqueda_result.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/traffic_service.dart';

import 'package:delivery/widgets/producto_general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          .copyWith(titleLarge: GoogleFonts.quicksand(color: Colors.black)),
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
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.transparent,
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(1),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        final lugares = snapshot.data!.tiendas;
        final productos = snapshot.data!.productos;
        if (lugares.isEmpty && productos.isEmpty) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'No hay resultados con " $query. "',
                    style: GoogleFonts.quicksand(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: lugares.isEmpty ? 0 : 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemCount: lugares.length,
                  separatorBuilder: (_, i) => Divider(
                    color: Colors.grey.withOpacity(.0),
                  ),
                  itemBuilder: (_, i) {
                    final tienda = lugares[i];
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        close(context,
                            BusquedaResult(cancelo: false, tienda: tienda));
                      },
                      child: SizedBox(
                          height: lugares.isEmpty ? 0 : 100,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              var tienda = snapshot.data!.tiendas[index];

                              return Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(1))),
                                      height: 75,
                                      width: 75,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
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
                                                            100),
                                                    child:
                                                        const CircularProgressIndicator(
                                                      strokeWidth: 1,
                                                      color: Colors.black,
                                                    )),
                                            errorWidget: (context, url, error) {
                                              return const Icon(Icons.error);
                                            }),
                                      )),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 75,
                                    child: Text(
                                      tienda.nombre,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(),
                                    ),
                                  )
                                ],
                              );
                            },
                            itemCount: snapshot.data!.tiendas.length,
                            separatorBuilder: (_, __) => const SizedBox(
                              width: 15,
                            ),
                          )),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.productos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        close(
                            context,
                            BusquedaResult(
                                cancelo: false,
                                producto: snapshot.data!.productos[index]));
                      },
                      child: ProductoGeneral(
                        noHit: false,
                        producto: snapshot.data!.productos[index],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10,
                  ),
                ),
              )
            ],
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
