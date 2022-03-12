import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/busqueda_result.dart';
import 'package:delivery/service/traffic_service.dart';
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
          elevation: .5,
          backgroundColor: Colors.white),
      textTheme: superThemeData.textTheme.copyWith(
          headline6: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold, color: Colors.black)),
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
    if (query.isEmpty) {
      return Container(
        width: 500,
        color: const Color(0xffF3F5F6),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            ListTile(
              leading: const Icon(Icons.search),
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
      );
    }
    return _construirResultadosSugerencias();
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
          return const Center(
              child: CircularProgressIndicator(
            color: Color.fromRGBO(41, 199, 184, 1),
          ));
        }
        final lugares = snapshot.data!.tiendas;
        if (lugares.isEmpty) {
          return ListTile(
            title: Text(
              'No hay resultados con $query 🤧',
              style: GoogleFonts.quicksand(
                  color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            itemCount: lugares.length,
            separatorBuilder: (_, i) => Divider(
              color: Colors.grey.withOpacity(.0),
            ),
            itemBuilder: (_, i) {
              final tienda = lugares[i];
              return GestureDetector(
                onTap: () {
                  close(context, BusquedaResult(cancelo: false,tienda: tienda));
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const SizedBox(
                        width: 60,
                        height: 60,
                        child: Image(
                          image: NetworkImage(
                              'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromRGBO(234, 248, 248, 1)),
                                child: const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(62, 204, 191, 1),
                                  size: 12,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '5.0',
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                ),
                              ),
                              Text(
                                tienda.nombre,
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Text(
                            'Categoria 1 - Categoria 2 - Categoria 3',
                            style: GoogleFonts.quicksand(color: Colors.grey),
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
}
