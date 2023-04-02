import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/busqueda_result_producto.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPrenda extends SearchDelegate<BusquedaResultPrenda> {
  @override
  // ignore: overridden_fields
  final String searchFieldLabel;
  final TrafficService _trafficService;

  SearchPrenda()
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
        onPressed: () => close(context, BusquedaResultPrenda(cancelo: true)),
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

    _trafficService.getPrendaPorQuery(query.trim());

    return StreamBuilder(
      stream: _trafficService.prendasStream,
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
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
            crossAxisSpacing: 15,
            children: List.generate(
                snapshot.data!.productos.length,
                (index) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        close(
                            context,
                            BusquedaResultPrenda(
                                cancelo: false,
                                producto: snapshot.data!.productos[index]));
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(.2))),
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.black.withOpacity(.2),
                                )),
                          ),
                          Container(
                              width: double.infinity,
                              height: 60,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data!.productos[index].sku,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                    Text(
                                      snapshot.data!.productos[index].nombre,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                    Text(
                                      '\$ ${snapshot.data!.productos[index].precio.toStringAsFixed(2)}',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white.withOpacity(.7)),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )),
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
