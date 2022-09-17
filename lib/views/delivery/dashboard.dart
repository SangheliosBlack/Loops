import 'dart:ui';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/helpers/widgets_to_markers.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/repartidor_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/views/delivery/done.dart';
import 'package:delivery/views/delivery/mis_viajes.dart';
import 'package:delivery/views/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DashBoardViewRepartidor extends StatefulWidget {
  const DashBoardViewRepartidor({Key? key}) : super(key: key);

  @override
  State<DashBoardViewRepartidor> createState() =>
      _DashBoardViewRepartidorState();
}

class _DashBoardViewRepartidorState extends State<DashBoardViewRepartidor>
    with WidgetsBindingObserver {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAjkUX-gwGEOkyOWgqxi7VxXJHK1ZOJMxY";

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('repartidor-callback', (payload) {});
    _complementosMapa();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mapController.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _onEditing = false;
    final authProvider = Provider.of<AuthService>(context);
    final repartidorService = Provider.of<RepartidorProvider>(context);
    const cameraPosition =
        CameraPosition(zoom: 15, target: LatLng(21.3586042, -101.9333911));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: GoogleMap(
                      padding: const EdgeInsets.all(10),
                      compassEnabled: true,
                      mapToolbarEnabled: true,
                      initialCameraPosition: cameraPosition,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          controller.setMapStyle(Statics.mapStyle2);
                          mapController = controller;
                        });
                      },
                      markers: Set<Marker>.of(markers.values),
                      polylines: Set<Polyline>.of(polylines.values),
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      onCameraMove: (cameraPosition) {},
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: SizedBox(
                    width: width,
                    child: Hero(
                      tag: 'money',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MisViajesView()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.black),
                              child: Text(
                                repartidorService.listaEnvios.isEmpty
                                    ? 'MXN 0.00'
                                    : 'MXN ${repartidorService.listaEnvios.fold<num>(0, (previousValue, element) => element.entregadoCliente ? element.envio : 0 + previousValue).toStringAsFixed(2)}',
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditarPerfil()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ], color: Colors.white, shape: BoxShape.circle),
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.menu),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 15),
                    width: width,
                    child: Column(
                      children: [
                        authProvider.usuario.onlineRepartidor
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          const Color.fromRGBO(41, 199, 184, 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(29),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1, color: Colors.white)),
                                        child: Text('INICIAR',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: authProvider.usuario.transito
                                  ? Builder(builder: (context) {
                                      int valor = repartidorService.listaEnvios
                                          .indexWhere((element) =>
                                              !element.entregadoCliente);
                                      final nombre = repartidorService
                                          .listaEnvios[valor].usuario.nombre
                                          .split(' ');
                                      return AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child:
                                            repartidorService.listaEnvios[valor]
                                                    .entregadoRepartidor
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                nombre[0] +
                                                                    ' ' +
                                                                    nombre[1]
                                                                        [0],
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                        fontSize:
                                                                            22,
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .translucent,
                                                                onTap:
                                                                    () async {
                                                                  FlutterPhoneDirectCaller
                                                                          .callNumber(
                                                                              '4741030509')
                                                                      .then(
                                                                          (value) {
                                                                    try {
                                                                      if (value!) {
                                                                        final snackBar =
                                                                            SnackBar(
                                                                          duration:
                                                                              const Duration(seconds: 2),
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          content:
                                                                              Text(
                                                                            'Permiso denegado, caracteristica limitada.',
                                                                            style:
                                                                                GoogleFonts.quicksand(),
                                                                          ),
                                                                        );

                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                      }
                                                                    } catch (e) {}
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          15),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.blue)),
                                                                  child: Text(
                                                                    'Llamar',
                                                                    style: GoogleFonts
                                                                        .quicksand(
                                                                            color:
                                                                                Colors.blue),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(.2))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .place_outlined,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  repartidorService
                                                                      .listaEnvios[
                                                                          valor]
                                                                      .direccionCliente
                                                                      .titulo,
                                                                  style: GoogleFonts.quicksand(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .8),
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          VerificationCode(
                                                              itemSize: (width -
                                                                      90) /
                                                                  4,
                                                              underlineWidth: 1,
                                                              textStyle: GoogleFonts.quicksand(
                                                                  fontSize:
                                                                      20.0,
                                                                  color:
                                                                      const Color.fromRGBO(
                                                                          41,
                                                                          199,
                                                                          184,
                                                                          1)),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              underlineColor:
                                                                  Colors.blue,
                                                              length: 4,
                                                              cursorColor:
                                                                  Colors.blue,
                                                              digitsOnly: true,
                                                              onCompleted: (String
                                                                  value) async {
                                                                mostrarCarga(
                                                                    context);
                                                                await Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            1));
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const DoneDeliveryView()),
                                                                );
                                                              },
                                                              onEditing:
                                                                  (bool value) {
                                                                setState(() {
                                                                  _onEditing =
                                                                      value;
                                                                });
                                                                if (!_onEditing) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                }
                                                              }),
                                                          Text(
                                                            '*Codigo de cliente',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    color: Colors
                                                                        .blueGrey),
                                                          )
                                                        ]),
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                repartidorService
                                                                    .listaEnvios[
                                                                        valor]
                                                                    .tienda,
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                        fontSize:
                                                                            22,
                                                                        color: Colors
                                                                            .blue),
                                                              ),
                                                              GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .translucent,
                                                                onTap:
                                                                    () async {
                                                                  FlutterPhoneDirectCaller
                                                                          .callNumber(
                                                                              '4741030509')
                                                                      .then(
                                                                          (value) {
                                                                    try {
                                                                      if (value!) {
                                                                        final snackBar =
                                                                            SnackBar(
                                                                          duration:
                                                                              const Duration(seconds: 2),
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          content:
                                                                              Text(
                                                                            'Permiso denegado, caracteristica limitada.',
                                                                            style:
                                                                                GoogleFonts.quicksand(),
                                                                          ),
                                                                        );

                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackBar);
                                                                      }
                                                                    } catch (e) {}
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          15),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.blue)),
                                                                  child: Text(
                                                                    'Llamar',
                                                                    style: GoogleFonts
                                                                        .quicksand(
                                                                            color:
                                                                                Colors.blue),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(.2))),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .place_outlined,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  repartidorService
                                                                      .listaEnvios[
                                                                          valor]
                                                                      .direccionNegocio
                                                                      .titulo,
                                                                  style: GoogleFonts.quicksand(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .8),
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            width: width,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  repartidorService
                                                                      .listaEnvios[
                                                                          valor]
                                                                      .codigoRepartidor,
                                                                  style: GoogleFonts.quicksand(
                                                                      fontSize:
                                                                          40,
                                                                      color: Colors
                                                                          .blue),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          ConfirmationSlider(
                                                            width: width - 70,
                                                            height: 60,
                                                            stickToEnd: false,
                                                            shadow: BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 0),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2)),
                                                            iconColor:
                                                                Colors.black,
                                                            text: 'Confirmar',
                                                            foregroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    41,
                                                                    199,
                                                                    184,
                                                                    1),
                                                            textStyle: GoogleFonts
                                                                .quicksand(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8)),
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundColorEnd:
                                                                const Color
                                                                        .fromRGBO(
                                                                    41,
                                                                    199,
                                                                    184,
                                                                    1),
                                                            onConfirmation: () {
                                                              mapController.animateCamera(CameraUpdate.newLatLngZoom(
                                                                  LatLng(
                                                                      repartidorService
                                                                          .listaEnvios[
                                                                              valor]
                                                                          .direccionCliente
                                                                          .coordenadas
                                                                          .lat
                                                                          .toDouble(),
                                                                      repartidorService
                                                                          .listaEnvios[
                                                                              valor]
                                                                          .direccionCliente
                                                                          .coordenadas
                                                                          .lng
                                                                          .toDouble()),
                                                                  14));
                                                              repartidorService
                                                                  .confirmarEntrega();
                                                            },
                                                          ),
                                                        ]),
                                                  ),
                                      );
                                    })
                                  : Builder(builder: (context) {
                                      int valor = repartidorService.listaEnvios
                                          .indexWhere((element) =>
                                              !element.entregadoCliente);
                                      return valor != -1
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25,
                                                            right: 25,
                                                            bottom: 25,
                                                            top: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Colors.white),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Nueva orden!',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          padding: const EdgeInsets.all(
                                                                              10),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.05),
                                                                                spreadRadius: 5,
                                                                                blurRadius: 5,
                                                                                offset: const Offset(0, 0), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.attach_money,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                Colors.blueGrey.withOpacity(.5),
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          '\$ ${repartidorService.listaEnvios[valor].envio.toStringAsFixed(2)}',
                                                                          style:
                                                                              GoogleFonts.quicksand(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                16,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          15),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          padding: const EdgeInsets.all(
                                                                              10),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.05),
                                                                                spreadRadius: 5,
                                                                                blurRadius: 5,
                                                                                offset: const Offset(0, 0), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.moped,
                                                                            color:
                                                                                Colors.blueGrey.withOpacity(.5),
                                                                            size:
                                                                                18,
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          repartidorService
                                                                              .listaEnvios[
                                                                                  valor]
                                                                              .ruta
                                                                              .distance
                                                                              .text,
                                                                          style:
                                                                              GoogleFonts.quicksand(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                16,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          15),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          padding: const EdgeInsets.all(
                                                                              10),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.05),
                                                                                spreadRadius: 5,
                                                                                blurRadius: 5,
                                                                                offset: const Offset(0, 0), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.schedule,
                                                                            color:
                                                                                Colors.blueGrey.withOpacity(.5),
                                                                            size:
                                                                                18,
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          repartidorService
                                                                              .listaEnvios[
                                                                                  valor]
                                                                              .ruta
                                                                              .duration
                                                                              .text,
                                                                          style:
                                                                              GoogleFonts.quicksand(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                16,
                                                                          ))
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 60,
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(right: 10),
                                                                          width:
                                                                              12,
                                                                          height:
                                                                              12,
                                                                          decoration: const BoxDecoration(
                                                                              color: Color.fromRGBO(0, 147, 255, 1),
                                                                              shape: BoxShape.circle),
                                                                        ),
                                                                        Text(
                                                                            'Inicio',
                                                                            style:
                                                                                GoogleFonts.quicksand(color: Colors.black)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 60,
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(right: 10),
                                                                          width:
                                                                              12,
                                                                          height:
                                                                              12,
                                                                          decoration: const BoxDecoration(
                                                                              color: Color.fromRGBO(63, 225, 127, 1),
                                                                              shape: BoxShape.circle),
                                                                        ),
                                                                        Text(
                                                                            'Fin',
                                                                            style:
                                                                                GoogleFonts.quicksand(color: Colors.black)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          width: width,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                          ),
                                                          child:
                                                              ConfirmationSlider(
                                                            height: 60,
                                                            stickToEnd: false,
                                                            shadow: BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 0),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .2)),
                                                            iconColor:
                                                                Colors.black,
                                                            text: 'Confirmar',
                                                            foregroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    41,
                                                                    199,
                                                                    184,
                                                                    1),
                                                            textStyle: GoogleFonts
                                                                .quicksand(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8)),
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundColorEnd:
                                                                const Color
                                                                        .fromRGBO(
                                                                    41,
                                                                    199,
                                                                    184,
                                                                    1),
                                                            onConfirmation:
                                                                () async {
                                                              mostrarCarga(
                                                                  context);
                                                              int valor = repartidorService
                                                                  .listaEnvios
                                                                  .indexWhere(
                                                                      (element) =>
                                                                          !element
                                                                              .entregadoCliente);
                                                              mapController.animateCamera(CameraUpdate.newLatLngZoom(
                                                                  LatLng(
                                                                      repartidorService
                                                                          .listaEnvios[
                                                                              valor]
                                                                          .direccionNegocio
                                                                          .coordenadas
                                                                          .lat
                                                                          .toDouble(),
                                                                      repartidorService
                                                                          .listaEnvios[
                                                                              valor]
                                                                          .direccionNegocio
                                                                          .coordenadas
                                                                          .lng
                                                                          .toDouble()),
                                                                  14));
                                                              final estado =
                                                                  await authProvider
                                                                      .transitoUsuario();
                                                              print(estado);
                                                              if (estado) {
                                                                Navigator.pop(
                                                                    context);
                                                                final snackBar =
                                                                    SnackBar(
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              4),
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          .8),
                                                                  content: Text(
                                                                    'Viaje aceptado!',
                                                                    style: GoogleFonts
                                                                        .quicksand(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                );

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                final snackBar =
                                                                    SnackBar(
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          .8),
                                                                  content: Text(
                                                                    'Error al aceptar viaje',
                                                                    style: GoogleFonts
                                                                        .quicksand(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                );

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 35,
                                                      horizontal: 25),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  authProvider.usuario
                                                          .onlineRepartidor
                                                      ? Text(
                                                          'Buscando',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize: 21),
                                                        )
                                                      : Text(
                                                          'Estas desconectado',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize: 21),
                                                        ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  authProvider.usuario
                                                          .onlineRepartidor
                                                      ? const JumpingDots(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      300),
                                                          color: Colors.black,
                                                          radius: 7,
                                                          numberOfDots: 3,
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            );
                                    }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _complementosMapa() async {
    final repartidorService =
        Provider.of<RepartidorProvider>(context, listen: false);
    final listado = await repartidorService.cargarPedidosMomento();
    if (listado.isNotEmpty) {
      int valor = listado.indexWhere((element) => !element.entregadoCliente);
      _agregarMarcadores(envio: repartidorService.listaEnvios[valor]);
      await Future.delayed(const Duration(milliseconds: 500));
      mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(
                  repartidorService
                          .listaEnvios[valor].ruta.bounds.southwest.lat -
                      0.028,
                  repartidorService
                      .listaEnvios[valor].ruta.bounds.southwest.lng),
              northeast: LatLng(
                  repartidorService
                          .listaEnvios[valor].ruta.bounds.northeast.lat +
                      .015,
                  repartidorService
                      .listaEnvios[valor].ruta.bounds.northeast.lng)),
          10));
    }
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 4,
        polylineId: id,
        endCap: Cap.roundCap,
        color: Colors.black,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline({required PedidoProducto envio}) async {
    Future.delayed(const Duration(milliseconds: 100));
    List<PointLatLng> result =
        polylinePoints.decodePolyline(envio.ruta.overviewPolyline.points);
    for (var point in result) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    _addPolyLine();
  }

  _agregarMarcadores({required PedidoProducto envio}) async {
    final nombre = envio.usuario.nombre.split(' ');
    final inicioMarker = await getStartCustomMarker(
        text: envio.tienda + '\n' + envio.direccionNegocio.titulo, type: true);
    final finMarker = await getStartCustomMarker(
        text: nombre[0] + '\n' + envio.direccionCliente.titulo, type: false);

    _addMarker(
        LatLng(envio.direccionNegocio.coordenadas.lat.toDouble(),
            envio.direccionNegocio.coordenadas.lng.toDouble()),
        "origin",
        inicioMarker);

    /// destination marker
    _addMarker(
        LatLng(envio.direccionCliente.coordenadas.lat.toDouble(),
            envio.direccionCliente.coordenadas.lng.toDouble()),
        "destination",
        finMarker);
    _getPolyline(envio: envio);
  }
}
