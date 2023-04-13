import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/views/socio/editar_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EditarTiendaView extends StatefulWidget {
  final Tienda tienda;

  const EditarTiendaView({Key? key, required this.tienda}) : super(key: key);

  @override
  State<EditarTiendaView> createState() => _EditarTiendaViewState();
}

class _EditarTiendaViewState extends State<EditarTiendaView> {
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
        visible: true,
        draggable: false,
        markerId: const MarkerId('SomeId'),
        position: LatLng(widget.tienda.coordenadas.latitud,
            widget.tienda.coordenadas.longitud),
        infoWindow: const InfoWindow(title: 'Ubicacion')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final pushProvider = PushNotificationProvider();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 320,
                    width: width,
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Hero(
                      tag: '${widget.tienda.imagenPerfil}+socio',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.tienda.fotografias,
                            imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(.15),
                                        BlendMode.color,
                                      ),
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                ),
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error);
                            }),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: const Offset(0, 0),
                                  ),
                                ], color: Colors.white, shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          widget.tienda.imagenPerfil),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(0, 224, 242, 1)),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Text(
                          widget.tienda.nombre,
                          style: GoogleFonts.quicksand(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              ItemConfiguracion(
                                color: const Color.fromRGBO(159, 227, 254, 1),
                                titulo: 'Productos',
                                subTitulo: widget.tienda.listaProductos.length
                                    .toString(),
                                funcion: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditarMenuView(
                                            tienda: widget.tienda,
                                          )),
                                ),
                                icono: Icons.shopping_bag_outlined,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.grey.withOpacity(.1)),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.place_outlined,
                                            size: 20,
                                            color:
                                                Colors.black.withOpacity(.6)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(1),
                                              shape: BoxShape.circle),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Allende 475, Centro, 47400 Lagos de Moreno, Jal.',
                                            maxLines: 3,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 15,
                                                color: Colors.black
                                                    .withOpacity(.7)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ItemConfiguracion(
                                color: const Color.fromRGBO(253, 236, 171, 1),
                                titulo: 'Disponibilidad',
                                subTitulo: 'Disponible',
                                funcion: () => null,
                                icono: Icons.delivery_dining_outlined,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ItemConfiguracion(
                                color: const Color.fromRGBO(156, 181, 254, 1),
                                titulo: 'Equipo',
                                subTitulo: 'Proximamente',
                                funcion: () => null,
                                icono: Icons.person_outline,
                              ),
                              const SizedBox(height: 15),
                              ItemConfiguracion(
                                color: const Color.fromRGBO(253, 157, 203, 1),
                                titulo: 'Horario',
                                subTitulo:
                                    '${DateFormat('hh:mm').format(widget.tienda.horario.apertura)} - ${DateFormat('hh:mm').format(widget.tienda.horario.cierre)}',
                                funcion: () => null,
                                icono: Icons.schedule_outlined,
                              ),
                              const SizedBox(height: 15),
                              FutureBuilder(
                                future:
                                    pushProvider.firebaseMessaging.getToken(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String?> snapshot) {
                                  if (snapshot.hasData) {
                                    return ItemConfiguracion(
                                      isRed: widget.tienda.puntoVenta.isEmpty
                                          ? true
                                          : false,
                                      color: const Color.fromRGBO(
                                          253, 236, 171, 1),
                                      titulo: 'Punto Venta',
                                      subTitulo:
                                          widget.tienda.puntoVenta.isEmpty
                                              ? 'No configurado'
                                              : 'Configurado',
                                      funcion: () =>
                                          openDialog(string: snapshot.data!),
                                      icono: Icons.storefront_outlined,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 25, top: 10, bottom: 10),
                width: double.infinity,
                child: Text(
                  'Miembro desde 2/11/16 ❤️',
                  textAlign: TextAlign.end,
                  style:
                      GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }

  Future openDialog({required String string}) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            elevation: 0,
            title: Text(string, style: GoogleFonts.quicksand()),
            actions: [
              TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: string));
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.black,
                      content: Text(
                        'Copiado en portapapeles',
                        style: GoogleFonts.quicksand(color: Colors.white),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text(
                    'Copiar',
                    style: GoogleFonts.quicksand(
                        color: Colors.grey.withOpacity(1)),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: GoogleFonts.quicksand(),
                  ))
            ],
          ));
}

class ItemConfiguracion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String subTitulo;
  final Function funcion;
  final bool isRed;

  const ItemConfiguracion(
      {Key? key,
      required this.color,
      required this.titulo,
      required this.subTitulo,
      required this.funcion,
      required this.icono,
      this.isRed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        funcion();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.withOpacity(.1)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, size: 20, color: Colors.black.withOpacity(.6)),
            const SizedBox(height: 5),
            Text(
              titulo,
              style: GoogleFonts.quicksand(
                  fontSize: 15, color: Colors.black.withOpacity(.7)),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                      color: isRed
                          ? Colors.red
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(1),
                      shape: BoxShape.circle),
                ),
                Text(
                  subTitulo,
                  style:
                      GoogleFonts.quicksand(fontSize: 13, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// cambiarHorario(BuildContext context, TiendasService tiendasService) async {
//   final TimeRange? result = await showTimeRangePicker(
//     handlerColor: Colors.white,
//     selectedColor: Colors.white,
//     backgroundColor: Colors.white.withOpacity(.4),
//     fromText: 'A partir de',
//     toText: 'Hasta las',
//     use24HourFormat: true,
//     start: TimeOfDay(
//         hour: int.parse(
//             DateFormat('HH').format(tiendasService.tienda.horario.apertura)),
//         minute: int.parse(
//             DateFormat('mm').format(tiendasService.tienda.horario.apertura))),
//     end: TimeOfDay(
//         hour: int.parse(
//             DateFormat('HH').format(tiendasService.tienda.horario.cierre)),
//         minute: int.parse(
//             DateFormat('mm').format(tiendasService.tienda.horario.cierre))),
//     strokeColor: Colors.white,
//     context: context,
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.dark().copyWith(
//           colorScheme: ColorScheme.dark(
//             primary: Colors.white,
//             onPrimary: Colors.red,
//             surface: Colors.white.withOpacity(.2),
//             onSurface: Colors.white,
//           ),
//           backgroundColor: const Color(0xff9E89F2),
//           dialogBackgroundColor: Theme.of(context).primaryColor.withOpacity(1),
//         ),
//         child: Container(
//             margin: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//             ),
//             child: child!),
//       );
//     },
//   );
//   if (result != null) {
//     await tiendasService.cambiarHorarioTienda(
//         id: tiendasService.tienda.uid,
//         apertura: result.startTime.toString(),
//         cierre: result.endTime.toString());
//   }
// }

// seleccionarFechaAniversario(
//     BuildContext context, TiendasService tiendasService) async {
//   final initialDate = DateTime.now();
//   final newDate = await showDatePicker(
//     context: context,
//     locale: const Locale('es', 'ES'),
//     initialDate: initialDate,
//     firstDate: DateTime(DateTime.now().year - 5),
//     lastDate: DateTime(DateTime.now().year + 5),
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.dark().copyWith(
//           colorScheme: ColorScheme.dark(
//             secondary: Colors.red,
//             primary: Colors.white,
//             onPrimary: Theme.of(context).primaryColor.withOpacity(1),
//             surface: Colors.white.withOpacity(.2),
//             onSurface: Colors.white,
//           ),
//           dialogBackgroundColor: Theme.of(context).primaryColor.withOpacity(1),
//         ),
//         child: Container(
//             margin: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10)),
//                 color: Theme.of(context).primaryColor.withOpacity(1)),
//             child: child!),
//       );
//     },
//   );
//   if (newDate != null) {
//     await tiendasService.cambiarAniversario(
//         id: tiendasService.tienda.uid, aniversario: newDate.toString());
//   }
// }
