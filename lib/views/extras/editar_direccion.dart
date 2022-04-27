import 'package:delivery/global/enviroment.dart';
import 'package:delivery/helpers/confirmar_eliminacion.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EditarDireccionView extends StatefulWidget {
  final Direccion direccion;

  const EditarDireccionView({Key? key, required this.direccion})
      : super(key: key);

  @override
  State<EditarDireccionView> createState() => _EditarDireccionViewState();
}

class _EditarDireccionViewState extends State<EditarDireccionView> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  @override
  void initState() {
    agregarMarcador();
    super.initState();
  }

  agregarMarcador() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pin.png",
    );

    markers.add(Marker(
        icon: markerbitmap,
        markerId: const MarkerId('SomeId'),
        position: LatLng(
            double.parse(widget.direccion.coordenadas.lat.toString()),
            double.parse(widget.direccion.coordenadas.lng.toString())),
        infoWindow: const InfoWindow(title: 'Ubicacion de envio')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    double width = MediaQuery.of(context).size.width;
    final cameraPosition = CameraPosition(
        zoom: 16,
        target: LatLng(
            double.parse(widget.direccion.coordenadas.lat.toString()),
            double.parse(widget.direccion.coordenadas.lng.toString())));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  direccionesService.calcularFavorito(id: widget.direccion.id, estado: widget.direccion.predeterminado);
                },
                child: Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.all(10),
                    child: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: widget.direccion.predeterminado
                          ? const Icon(
                              FontAwesomeIcons.solidStar,
                              size: 18,
                              color: Color.fromRGBO(253, 95, 122, 1),
                            )
                          : Icon(
                              FontAwesomeIcons.star,
                              size: 18,
                              color: Colors.black.withOpacity(.8),
                            ),
                    )),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  final result = await confirmarEliminacion(context: context, tipo: 0, titulo: widget.direccion.titulo
                      );
                  if (result) {
                    direccionesService.eliminarDireccion(
                        id: widget.direccion.id);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.black.withOpacity(.8),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          )
        ],
        toolbarHeight: 65,
        title: Text(
          '',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  padding: const EdgeInsets.all(5),
                  markers: markers,
                  initialCameraPosition: cameraPosition,
                  myLocationEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                    });
                    controller.setMapStyle(Statics.mapStyle);
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onCameraMove: (cameraPosition) {},
                ),
                Positioned(
                  bottom: 35,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.grey.withOpacity(.1), width: 1)),
                    child: Container(
                      width: width - 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        widget.direccion.titulo,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.7), fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
