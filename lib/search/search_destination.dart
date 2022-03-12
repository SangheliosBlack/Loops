import 'package:delivery/models/search_response.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  // ignore: overridden_fields
  final String searchFieldLabel;
  final TrafficService _trafficService;

  SearchDestination()
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
        onPressed: () => close(context, SearchResult(cancelo: true)),
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
            /*ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Colocar ubicacion manualmente'),
              onTap: () {
                close(context, SearchResult(cancelo: false, manual: true));
              },
            )*/
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

    _trafficService.getSugerenciasPorQuery(query.trim());

    return StreamBuilder(
      stream: _trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color.fromRGBO(41, 199, 184, 1),
          ));
        }
        final lugares = snapshot.data!.features;
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
          margin: const EdgeInsets.only(top: 10),
          child: ListView.separated(
            itemCount: lugares.length,
            separatorBuilder: (_, i) => Divider(
              color: Colors.grey.withOpacity(.2),
            ),
            itemBuilder: (_, i) {
              final lugar = lugares[i];
              return ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(41, 199, 184, 1)),
                    child: const Icon(
                      Icons.place,
                      size: 20,
                      color: Colors.white,
                    )),
                title: Text(
                  lugar.textEs,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lugar.placeNameEs,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  close(
                      context,
                      SearchResult(
                          cancelo: false,
                          manual: false,
                          position: LatLng(lugar.center[1], lugar.center[0]),
                          nombreDestino: lugar.textEs,
                          descripcion: lugar.placeNameEs));
                },
              );
            },
          ),
        );
      },
    );
  }
}
