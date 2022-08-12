import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:we_slide/we_slide.dart';

class DashBoardViewRepartidor extends StatefulWidget {
  const DashBoardViewRepartidor({Key? key}) : super(key: key);

  @override
  State<DashBoardViewRepartidor> createState() =>
      _DashBoardViewRepartidorState();
}

class _DashBoardViewRepartidorState extends State<DashBoardViewRepartidor>
    with WidgetsBindingObserver {
  late GoogleMapController mapController;
  final _controller = WeSlideController();

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('repartidor-callback', (payload) {
      _controller.show();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      mapController.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    const cameraPosition =
        CameraPosition(zoom: 13, target: LatLng(21.3586042, -101.9333911));
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: WeSlide(
          parallax: true,
          hideAppBar: true,
          transformScale: false,
          hideFooter: false,
          backgroundColor: Colors.white,
          panelBorderRadiusBegin: 35.0,
          panelBorderRadiusEnd: 35.0,
          panelMinSize: 0,
          panelMaxSize: 424,
          isUpSlide: false,
          parallaxOffset: 0.3,
          isDismissible: false,
          blurColor: Colors.white,
          overlayColor: Colors.white,
          appBarHeight: 80.0,
          footerHeight: 60.0,
          blur: true,
          blurSigma: 50,
          panelWidth: width,
          controller: _controller,
          hidePanelHeader: true,
          transformScaleBegin: 0,
          transformScaleEnd: 0,
          panel: NewTripWidget(
            controller: _controller,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 75, left: 25, right: 25, bottom: 20),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Image(
                                    image: NetworkImage(
                                        'https://i.pinimg.com/564x/90/77/6a/90776a65574898e775b136dd310f40df.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buen dia',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.grey.withOpacity(.8)),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          authProvider.usuario.nombre,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 25,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.solidStar,
                                        size: 13,
                                        color: Color.fromRGBO(41, 199, 184, 1),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '4.9',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.grey.withOpacity(.8)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.show();
                        },
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.black,
                        ),
                      )
                    ]),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                width: width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(.1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.0),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '5',
                              style: GoogleFonts.quicksand(fontSize: 30),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Viajes completados',
                              style: GoogleFonts.quicksand(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(.1)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.0),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$155.00',
                              style: GoogleFonts.quicksand(
                                  fontSize: 30, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Ganancia',
                              style: GoogleFonts.quicksand(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Viaje pendiente en espera',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white, fontSize: 20)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          'Tienes un viaje en espera sin confirmar, atiende el envio, evita sanciones y la espera en la cola de baja prioridad',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromRGBO(35, 177, 233, 1))),
                            child: Text(
                              'Ver detalles',
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(35, 177, 233, 1)),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      padding: const EdgeInsets.all(10),
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      initialCameraPosition: cameraPosition,
                      myLocationEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onCameraMove: (cameraPosition) {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewTripWidget extends StatelessWidget {
  final WeSlideController controller;

  const NewTripWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width,
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Color.fromRGBO(21, 21, 24, 1)),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(63, 63, 65, 1)),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva orden disponible',
                        style: GoogleFonts.quicksand(
                            fontSize: 13,
                            color: const Color.fromRGBO(35, 177, 233, 1)),
                      ),
                      const SizedBox(height: 5),
                      Text('· A54D4A3D',
                          style: GoogleFonts.quicksand(color: Colors.white))
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Nueva orden disponible',
                        style: GoogleFonts.quicksand(
                            color: const Color.fromRGBO(21, 21, 24, 1)),
                      ),
                      const SizedBox(height: 5),
                      Text('Junio 15 , 2020 | 02:30 PM',
                          style: GoogleFonts.quicksand(color: Colors.white))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inicio',
                          style: GoogleFonts.quicksand(
                              fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                            'Nuestra señora de la asuncion #40, Laureles del campanario',
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.quicksand(color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Fin',
                              style: GoogleFonts.quicksand(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                            'Nuestra señora de la asuncion #40, Laureles del campanario',
                            style: GoogleFonts.quicksand(color: Colors.white))
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: Colors.grey.withOpacity(.2),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Detalles',
                    style: GoogleFonts.quicksand(color: Colors.grey),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Julio Villagrana',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$15.00',
                  style: GoogleFonts.quicksand(
                      color: const Color.fromRGBO(41, 199, 184, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                Text('*Ganancia total',
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      color: Colors.grey,
                    ))
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ConfirmationSlider(
                height: 60,
                stickToEnd: false,
                shadow: BoxShadow(color: Colors.black.withOpacity(1)),
                iconColor: Colors.black,
                text: 'Confirmar',
                foregroundColor: const Color.fromRGBO(41, 199, 184, 1),
                textStyle:
                    GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
                backgroundColor: Colors.white,
                backgroundColorEnd: const Color.fromRGBO(41, 199, 184, 1),
                onConfirmation: () {
                  controller.hide();
                },
              ),
            )
          ]),
        )
      ],
    );
  }
}
