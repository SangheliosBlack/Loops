import 'package:delivery/models/search_response.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../service/permission_status.dart';

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
        onPressed: () =>
            close(context, SearchResult(cancelo: true, sugerencia: false)),
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugerencia = Provider.of<PermissionStatusProvider>(context);
    if (query.isEmpty) {
      return sugerencia.listaSugerencias.isEmpty
          ? Container()
          : Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Sugerencia por tu ultima ubicacion',
                      style: GoogleFonts.quicksand(),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (() {
                          close(
                              context,
                              SearchResult(
                                  titulo: sugerencia
                                      .listaSugerencias[index].formattedAddress,
                                  longitud: sugerencia.listaSugerencias[index]
                                      .geometry.location.lng,
                                  latitud: sugerencia.listaSugerencias[index]
                                      .geometry.location.lat,
                                  cancelo: false,
                                  placeId: sugerencia
                                      .listaSugerencias[index].placeId,
                                  sugerencia: true));
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: double.infinity,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 35,
                                  height: 35,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.grey.withOpacity(.2)),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.place_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(1),
                                    size: 22,
                                  )),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sugerencia.listaSugerencias[index]
                                          .formattedAddress,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey.withOpacity(.4),
                                      size: 20))
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: sugerencia.listaSugerencias.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 5,
                    ),
                  ),
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
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(1),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        final lugares = snapshot.data!.predictions;
        if (lugares.isEmpty) {
          return Container(
            color: Colors.white,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'No hay resultados con $query',
                    style: GoogleFonts.quicksand(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: ListView.separated(
            itemCount: lugares.length,
            separatorBuilder: (_, i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                color: Colors.grey.withOpacity(.1),
              ),
            ),
            itemBuilder: (_, i) {
              final lugar = lugares[i];
              return ListTile(
                leading: Container(
                    width: 35,
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(.2)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.place_outlined,
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(1),
                      size: 22,
                    )),
                title: Text(
                  lugar.structuredFormatting.mainText,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  lugar.structuredFormatting.secondaryText,
                  style: GoogleFonts.quicksand(),
                ),
                onTap: () {
                  close(
                      context,
                      SearchResult(
                          cancelo: false,
                          placeId: lugar.placeId,
                          sugerencia: false));
                },
              );
            },
          ),
        );
      },
    );
  }
}
