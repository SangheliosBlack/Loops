import 'package:delivery/global/enviroment.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/socio/editar_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditarTiendaView extends StatefulWidget {
  const EditarTiendaView({Key? key}) : super(key: key);

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
    final negocio = Provider.of<TiendasService>(context, listen: false);
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/pin.png",
    );

    markers.add(Marker(
        icon: markerbitmap,
        markerId: const MarkerId('SomeId'),
        position: LatLng(negocio.tienda.coordenadas.latitud,
            negocio.tienda.coordenadas.longitud),
        infoWindow: const InfoWindow(title: 'Ubicacion de envio')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tiendasService = Provider.of<TiendasService>(context, listen: true);
    final cameraPosition = CameraPosition(
        zoom: 16,
        target: LatLng(tiendasService.tienda.coordenadas.latitud,
            tiendasService.tienda.coordenadas.longitud));
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 245, 246, 1),
      
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
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
                      tag: tiendasService.tienda.uid,
                      child: const ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        child: Image(
                          image: NetworkImage(
                              'https://recetinas.com/wp-content/uploads/2019/10/pizza-rapida-en-el-microondas.jpg'),
                          fit: BoxFit.cover,
                        ),
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
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: const SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image(
                                      image: NetworkImage(
                                          'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 10,
                                            blurRadius: 5,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.photo_camera_outlined,
                                      size: 17,
                                      color: Theme.of(context).primaryColor,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 45, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 10,
                                  blurRadius: 5,
                                  offset: const Offset(0, 0),
                                ),
                              ], shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                Icons.arrow_back_outlined,
                                size: 17,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                        Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ], shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 17,
                              color: Theme.of(context).primaryColor,
                            )),
                      ],
                    ),
                  )
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
                              color: Color.fromRGBO(24, 119, 242, 1)),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Text(
                          tiendasService.tienda.nombre,
                          style: GoogleFonts.quicksand(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                                subTitulo: '10',
                                funcion: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditarMenuView()),
                                ),
                                icono: Icons.shopping_bag_outlined,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.place,
                                        size: 25,
                                        color:
                                            Color.fromRGBO(223, 155, 253, 1)),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  62, 204, 191, 1),
                                              shape: BoxShape.circle),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Allende 475, Centro, 47400 Lagos de Moreno, Jal.',
                                            maxLines: 3,
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black
                                                    .withOpacity(.7)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        width: 200,
                                        height: 225,
                                        child: GoogleMap(
                                          compassEnabled: false,
                                          mapToolbarEnabled: false,
                                          markers: markers,
                                          initialCameraPosition: cameraPosition,
                                          myLocationEnabled: false,
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            setState(() {
                                              mapController = controller;
                                            });
                                            controller
                                                .setMapStyle(Statics.mapStyle);
                                          },
                                          myLocationButtonEnabled: false,
                                          zoomControlsEnabled: false,
                                          onCameraMove: (cameraPosition) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                subTitulo: '10',
                                funcion: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditarMenuView()),
                                ),
                                icono: Icons.person_outline,
                              ),
                              const SizedBox(height: 15),
                              ItemConfiguracion(
                                color: const Color.fromRGBO(253, 157, 203, 1),
                                titulo: 'Horario',
                                subTitulo:
                                    '${DateFormat('hh:mm').format(tiendasService.tienda.horario.apertura)} - ${DateFormat('hh:mm').format(tiendasService.tienda.horario.cierre)}',
                                funcion: () =>
                                    cambiarHorario(context, tiendasService),
                                icono: Icons.schedule_outlined,
                              ),
                              const SizedBox(height: 15),
                              ItemConfiguracion(
                                color: const Color.fromRGBO(255, 179, 166, 1),
                                titulo: 'Aniversario',
                                subTitulo: DateFormat.yMEd('es_ES')
                                    .format(tiendasService.tienda.aniversario),
                                funcion: () => seleccionarFechaAniversario(
                                    context, tiendasService),
                                icono: Icons.cake_outlined,
                              ),
                              const SizedBox(height: 15),
                              ItemConfiguracion(
                                color: const Color.fromRGBO(252, 208, 159, 1),
                                titulo: 'Pagos',
                                subTitulo: '646013168600137175',
                                funcion: () => seleccionarFechaAniversario(
                                    context, tiendasService),
                                icono: Icons.account_balance_outlined,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    ItemConfiguracion(
                      color: const Color.fromRGBO(253, 236, 171, 1),
                      titulo: 'Disponibilidad',
                      subTitulo: 'Disponible',
                      funcion: () =>
                          seleccionarFechaAniversario(context, tiendasService),
                      icono: Icons.delivery_dining_outlined,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 25),
                width: double.infinity,
                child: Text(
                  'Miembro desde 2/11/16 ❤️',
                  textAlign: TextAlign.end,
                  style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemConfiguracion extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String titulo;
  final String subTitulo;
  final Function funcion;

  const ItemConfiguracion({
    Key? key,
    required this.color,
    required this.titulo,
    required this.subTitulo,
    required this.funcion,
    required this.icono,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        funcion();
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, size: 25, color: color),
            const SizedBox(height: 5),
            Text(
              titulo,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black.withOpacity(.7)),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(62, 204, 191, 1),
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

cambiarHorario(BuildContext context, TiendasService tiendasService) async {
  final TimeRange? result = await showTimeRangePicker(
    handlerColor: Colors.white,
    selectedColor: Colors.white,
    backgroundColor: Colors.white.withOpacity(.4),
    fromText: 'A partir de',
    toText: 'Hasta las',
    use24HourFormat: true,
    start: TimeOfDay(
        hour: int.parse(
            DateFormat('HH').format(tiendasService.tienda.horario.apertura)),
        minute: int.parse(
            DateFormat('mm').format(tiendasService.tienda.horario.apertura))),
    end: TimeOfDay(
        hour: int.parse(
            DateFormat('HH').format(tiendasService.tienda.horario.cierre)),
        minute: int.parse(
            DateFormat('mm').format(tiendasService.tienda.horario.cierre))),
    strokeColor: Colors.white,
    context: context,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.white,
            onPrimary: Colors.red,
            surface: Colors.white.withOpacity(.2),
            onSurface: Colors.white,
          ),
          backgroundColor: const Color(0xff9E89F2),
          dialogBackgroundColor: Theme.of(context).primaryColor.withOpacity(1),
        ),
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: child!),
      );
    },
  );
  if (result != null) {
    await tiendasService.cambiarHorarioTienda(
        id: tiendasService.tienda.uid,
        apertura: result.startTime.toString(),
        cierre: result.endTime.toString());
  }
}

seleccionarFechaAniversario(
    BuildContext context, TiendasService tiendasService) async {
  final initialDate = DateTime.now();
  final newDate = await showDatePicker(
    context: context,
    locale: const Locale('es', 'ES'),
    initialDate: initialDate,
    firstDate: DateTime(DateTime.now().year - 5),
    lastDate: DateTime(DateTime.now().year + 5),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            secondary: Colors.red,
            primary: Colors.white,
            onPrimary: Theme.of(context).primaryColor.withOpacity(1),
            surface: Colors.white.withOpacity(.2),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: Theme.of(context).primaryColor.withOpacity(1),
        ),
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Theme.of(context).primaryColor.withOpacity(1)),
            child: child!),
      );
    },
  );
  if (newDate != null) {
    await tiendasService.cambiarAniversario(
        id: tiendasService.tienda.uid, aniversario: newDate.toString());
  }
}
