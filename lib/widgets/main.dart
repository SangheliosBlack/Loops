import 'dart:async';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/search/search_dashboard.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/tienda.dart';
import 'package:delivery/views/ver_todo.dart';
import 'package:delivery/widgets/dashboard/carta_negocio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BaraBusqueda extends StatelessWidget {
  final double width;

  const BaraBusqueda({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          try {
            final resultado =
                await showSearch(context: context, delegate: SearchBusqueda());
            if (!resultado!.cancelo) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StoreIndividual(tienda: resultado.tienda!)),
              );
            }
          } catch (e) {
            debugPrint('Wrong');
          }
        },
        child: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 250, 252, 1),
              borderRadius: BorderRadius.circular(15)),
          width: double.infinity,
          child: const Icon(
            Icons.search_outlined,
            color: Color.fromRGBO(98, 100, 105, 1),
          ),
        ),
      ),
    );
  }
}

class ListadoEstablecimientos extends StatelessWidget {
  final double height;
  final double width;
  const 
  ListadoEstablecimientos(
      {Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final llenarPantallaProvider = Provider.of<LlenarPantallasService>(context);

    return nav(height, width, context, llenarPantallaProvider);
  }

  Widget nav(
    double height,
    double width,
    BuildContext context,
    LlenarPantallasService llenarPantallaProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: Styles.containerCustom(),
                  child: Row(
                    children: [
                      Text(
                        'Establecimientos',
                        style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.7),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(width: 1, color: Colors.white),
                      primary: Colors.white,
                      backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerTodoView(
                                titulo: 'Establecimientos',
                              )),
                    );
                  },
                  child: Text(
                    'Ver todo',
                    style: GoogleFonts.quicksand(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            )),
        listMainItems(width, llenarPantallaProvider)
      ],
    );
  }

  Widget listMainItems(
      double width, LlenarPantallasService llenarPantallaProvider) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      height: 344,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return CartaNegocio(
                      tienda: llenarPantallaProvider.tiendas[index],
                      small: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 15),
                  itemCount: llenarPantallaProvider.tiendas.length))
        ],
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: Statics.kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(Statics.mapStyle);
        _controller.complete(controller);
      },
    );
  }
}

class CartItemsNumber extends StatelessWidget {
  const CartItemsNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 25,
        height: 25,
        child: Center(
            child: Text(
          '6',
          style: GoogleFonts.quicksand(
              color: Colors.white, fontWeight: FontWeight.w600),
        )),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor));
  }
}
