import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/busqueda_result.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                      child: const SizedBox(
                        width: 85,
                        height: 85,
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '4,9',
                                style: GoogleFonts.playfairDisplay(
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        const Color.fromRGBO(62, 204, 191, 1),
                                    fontSize: 25),
                              ),
                              const SizedBox(width: 5),
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
                          Text(
                            'Restaurante',
                            style: GoogleFonts.quicksand(
                                color: Colors.black, fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          RatingBar.builder(
                            initialRating: 3.5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.attach_money,
                              color: Colors.black,
                            ),
                            itemSize: 13,
                            unratedColor: Colors.grey,
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '2.4 km Centro, Lagos de Moreno ',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black, fontSize: 11),
                              ),
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
}
