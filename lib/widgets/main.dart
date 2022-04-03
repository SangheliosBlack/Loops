import 'dart:async';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/navegation_fade_in.dart';
import 'package:delivery/search/search_dashboard.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/tienda.dart';
import 'package:delivery/views/ver_todo.dart';
import 'package:delivery/widgets/dashboard/carta_negocio.dart';
import 'package:delivery/widgets/place_holder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MenuItems extends StatelessWidget {
  final double width;

  const MenuItems({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }

  Widget iconoCustom(IconData icono, BuildContext context, Widget orderScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, fadeInTransition(context, orderScreen));
      },
      child: Container(
        decoration: Styles.containerCustom(),
        child: Icon(
          icono,
          color: const Color(0xff7C5EF5),
        ),
        width: 45,
        height: 45,
      ),
    );
  }
}

class BottomWidgetMain extends StatelessWidget {
  final double height;
  final double width;
  const BottomWidgetMain({Key? key, required this.height, required this.width})
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
      height: 320,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: llenarPantallaProvider.tiendas.isEmpty
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        typeItem2(context),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 15),
                    itemCount: 3)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        CartaNegocio(
                          index: index,
                          tienda: llenarPantallaProvider.tiendas[index],
                          small: false,
                        ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 15),
                    itemCount: llenarPantallaProvider.tiendas.length),
          )
        ],
      ),
    );
  }

  Widget typeItem2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ]),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: '12A',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                      height: 100,
                      width: width / 2.8,
                      child: Shimmer(height: height, width: width, radius: 10)),
                ),
              ),
              Positioned(
                  top: -2,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10))),
                    child: Center(
                        child: Text(
                      '0.0',
                      style: GoogleFonts.quicksand(
                          fontSize: 12,
                          color: Colors.black.withOpacity(.7),
                          fontWeight: FontWeight.bold),
                    )),
                  ))
            ],
          ),
          const SizedBox(height: 15),
          Shimmer(height: 15, width: width / 2.8, radius: 10),
          const SizedBox(height: 10),
          Shimmer(height: 10, width: width / 4, radius: 10),
          const SizedBox(height: 10),
          Shimmer(height: 10, width: width / 2.9, radius: 10),
          Container(
            width: width / 2.8,
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
                const Shimmer(height: 20, width: 50, radius: 15)
              ],
            ),
          )
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
