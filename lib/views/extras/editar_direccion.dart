import 'package:delivery/global/enviroment.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/extras_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EditarDireccionView extends StatelessWidget {
  final int index;

  const EditarDireccionView({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    return MostarPantalla(
        indexMain: index,
        latitud: direccionesService.direcciones[index].coordenadas.latitud,
        longitud: direccionesService.direcciones[index].coordenadas.longitud,
        icono: direccionesService.direcciones[index].icono,
        descripcion: direccionesService.direcciones[index].descripcion,
        id: direccionesService.direcciones[index].id);
  }
}

class MostarPantalla extends StatefulWidget {
  final double latitud;
  final double longitud;
  final String descripcion;
  final int icono;
  final String id;
  final int indexMain;

  const MostarPantalla(
      {Key? key,
      required this.latitud,
      required this.longitud,
      required this.icono,
      required this.indexMain,
      required this.descripcion,
      required this.id})
      : super(key: key);

  @override
  State<MostarPantalla> createState() => _MostarPantallaState();
}

class _MostarPantallaState extends State<MostarPantalla> {
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
        position: LatLng(widget.latitud, widget.longitud),
        infoWindow: const InfoWindow(title: 'Ubicacion de envio')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final cameraPosition = CameraPosition(
        zoom: 16, target: LatLng(widget.latitud, widget.longitud));
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ]),
          child: AppBar(
            toolbarHeight: 65,
            title: Text(
              'Editar direccion',
              textAlign: TextAlign.start,
              style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Editar ',
                              style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(.7)),
                            ),
                            const Icon(
                              Icons.edit_outlined,
                              color: Color.fromRGBO(62, 204, 191, 1),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Eliminar',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.delete_outline,
                              color: Color.fromRGBO(255, 103, 50, 1),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                cambiarIcono(context, widget.icono, widget.indexMain);
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(9),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(41, 199, 184, 1),
                                shape: BoxShape.circle),
                            child: Icon(
                              IconData(widget.icono,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.white,
                              size: 18,
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cambiar avatar',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              'Facilidad a tus pedidos',
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(.4),
                                  fontSize: 11),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      (Icons.arrow_forward),
                      color: Color(0xffCDCDCD),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GoogleMap(
                        compassEnabled: false,
                        mapToolbarEnabled: false,
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
                          width: width - 110,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Text(
                            widget.descripcion,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(253, 95, 122, .1)),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(253, 95, 122, 1),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  cambiarTitulo(BuildContext context, int indexMain) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        builder: (builder) {
          return ChangueTitle(id: widget.id, index: indexMain);
        });
  }

  cambiarIcono(BuildContext context, int iconoFav, int indexMain) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        context: context,
        builder: (builder) {
          return SizedBox(
            height: 174,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selecciona un avatar',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffF7F7F7)),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xffB2B2B2),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: 110,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => item(
                            context,
                            Statics.listAvatars[index]['icono'],
                            iconoFav,
                            indexMain),
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 15),
                        itemCount: Statics.listAvatars.length)),
              ],
            ),
          );
        });
  }

  Widget item(BuildContext context, int icono, int iconofav, int index) {
    final direccionesService = Provider.of<DireccionesService>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await ExtrasService().actualizarDireccionIcono(widget.id, icono);
            await direccionesService.cambiarDireccionIcono(icono, index);
            Navigator.pop(context);
          },
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: icono == direccionesService.direcciones[index].icono
                    ? const Color.fromRGBO(62, 204, 191, 1)
                    : Theme.of(context).primaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Icon(
                IconData(icono, fontFamily: 'MaterialIcons'),
                color: icono == direccionesService.direcciones[index].icono
                    ? const Color.fromRGBO(234, 248, 248, 1)
                    : Colors.white,
              )),
        ),
        const SizedBox(height: 10),
        AnimatedOpacity(
          opacity: icono == direccionesService.direcciones[index].icono ? 1 : 0,
          duration: const Duration(seconds: 1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 103, 50, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Actual',
              style: GoogleFonts.quicksand(
                  color: const Color.fromRGBO(255, 240, 235, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}

class ChangueTitle extends StatefulWidget {
  final String id;
  final int index;
  const ChangueTitle({Key? key, required this.id, required this.index})
      : super(key: key);

  @override
  _ChangueTitleState createState() => _ChangueTitleState();
}

class _ChangueTitleState extends State<ChangueTitle> {
  bool isVoid = true;
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nuevo titulo',
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xffF7F7F7)),
                child: const Icon(
                  Icons.close,
                  color: Color(0xffB2B2B2),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: editController,
          onChanged: (value) {
            if (value.trim().isEmpty) {
              if (mounted) {
                setState(() {
                  isVoid = true;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  isVoid = false;
                });
              }
            }
          },
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
          autocorrect: false,
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF7F7F7),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              hintStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              hintText: 'Titulo'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: isVoid
                ? null
                : () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(const Duration(milliseconds: 500));
                    Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: Text(
              'Cambiar',
              style: GoogleFonts.quicksand(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
