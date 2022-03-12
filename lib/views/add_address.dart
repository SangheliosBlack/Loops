// ignore_for_file: unnecessary_this, prefer_const_constructors, unnecessary_new, avoid_unnecessary_containers, curly_braces_in_flow_control_structures

import 'package:animate_do/animate_do.dart';
import 'package:delivery/bloc/bloc/busqueda_bloc.dart';
import 'package:delivery/bloc/mapa/mapa_bloc.dart';
import 'package:delivery/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: library_prefixes
import 'package:polyline_do/polyline_do.dart' as Poly;
import 'package:provider/provider.dart';

class AddAdreessMapView extends StatefulWidget {
  const AddAdreessMapView({Key? key}) : super(key: key);

  @override
  _AddAdreessMapViewState createState() => _AddAdreessMapViewState();
}

class _AddAdreessMapViewState extends State<AddAdreessMapView> {
  final trafficService = TrafficService();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MiUbicacionBloc>(context, listen: false)
        .iniciarSeguimiento();
  }

  @override
  void dispose() {
    trafficService.killAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<MiUbicacionBloc>(context, listen: false)
            .cancelarSeguimiento();
        return true;
      },
      child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: (_, state) => crearPantalla(state, direccionesService),
      ),
    );
  }

  void retornoBusqueda(
      SearchResult result, DireccionesService direccionesService) async {
    if (result.cancelo) return;

    if (result.manual) {
      final manual = BlocProvider.of<BusquedaBloc>(context, listen: false);
      manual.add(OnActivarMarcadorManual());
    }

    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String texto = result.nombreDestino;
    final String descripcion = result.descripcion;
    final latitud = result.position.latitude;
    final longitud = result.position.longitude;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        texto, descripcion, latitud, longitud,false);
    if (nuevaDireccion) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      /**IMPLEMENTAR ALGO ERROR*/
    }
  }

  Widget crearPantalla(
      MiUbicacionState state, DireccionesService direccionesService) {
    double width = MediaQuery.of(context).size.width;

    if (!state.existeUbicacion)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ],
      );

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    mapaBloc.add(OnNuevaUbicacion(state.ubicacion!));
    final cameraPosition =
        new CameraPosition(zoom: 14, target: const LatLng(21.3543029, -101.9377804));
    return Container(
      child: Stack(
        children: [
          BlocBuilder<MapaBloc, MapaState>(builder: (context, _) {
            return GoogleMap(
              initialCameraPosition: cameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: mapaBloc.initMapa,
              onCameraMove: (cameraPosition) {
                mapaBloc.add(OnMovioMapa(cameraPosition.target));
              },
              polylines: mapaBloc.state.polylines.values.toSet(),
            );
          }),
          BlocBuilder<BusquedaBloc, BusquedaState>(builder: (context, state2) {
            if (state2.seleccionManual) {
              return Container();
            } else {
              return Positioned(
                top: 25,
                child: FadeInDown(
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () async {
                      /*final proximidad =
                          BlocProvider.of<MiUbicacionBloc>(context)
                              .state
                              .ubicacion;*/
                      final resultado = await showSearch(
                          context: context,
                          delegate: SearchDestination());
                      if (resultado == null) {
                        return;
                      } else {
                        this.retornoBusqueda(resultado, direccionesService);
                      }
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      width: width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              '${state.existeUbicacion ? state.ubicacion : 'Cargando...'}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.5),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.search,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
          Positioned(
              bottom: 25,
              right: 15,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final destino = state.ubicacion;
                      mapaBloc.moverCamara(destino!);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.gps_fixed)),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add)),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.remove)),
                ],
              )),
          const BuilMarcadorManual()
        ],
      ),
    );
  }
}

class BuilMarcadorManual extends StatelessWidget {
  const BuilMarcadorManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(builder: (context, state) {
      if (state.seleccionManual) {
        return const _BuilMarcadorManul();
      } else {
        return Container();
      }
    });
  }
}

class _BuilMarcadorManul extends StatelessWidget {
  const _BuilMarcadorManul({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 25,
          child: FadeInLeft(
            duration: const Duration(milliseconds: 150),
            child: GestureDetector(
              onTap: () {
                final manual =
                    BlocProvider.of<BusquedaBloc>(context, listen: false);
                manual.add(OnDesactivarMarcadorManual());
              },
              child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back)),
            ),
          ),
        ),
        Center(
            child: Transform.translate(
          offset: const Offset(0, -12),
          child: BounceInDown(
            from: 200,
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )),
        Positioned(
          bottom: 47,
          left: 25,
          child: FadeIn(
            child: GestureDetector(
              onTap: () {
                calcularDestino(context);
              },
              child: Container(
                height: 40,
                width: width - 80,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    'Confirmar ubicacion',
                    style: GoogleFonts.quicksand(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = TrafficService();
    final inicio = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    final trafficResponse = await trafficService.getCoordsInicioYFin(
        inicio, mapaBloc.state.ubicacionCentral);

    final geometry = trafficResponse.routes[0].geometry;
    final duracion = trafficResponse.routes[0].duration;
    final distancia = trafficResponse.routes[0].distance;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;

    final List<LatLng> rutaCoordenadas =
        points.map((point) => LatLng(point[0], point[1])).toList();

    mapaBloc
        .add(OnCrearRutaInicioDestino(rutaCoordenadas, distancia, duracion));

    Navigator.of(context).pop();
    final manual = BlocProvider.of<BusquedaBloc>(context, listen: false);
    manual.add(OnDesactivarMarcadorManual());
  }
}
