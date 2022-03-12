import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MisDireccionesView extends StatelessWidget {
  const MisDireccionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
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
              'Mis direcciones',
              textAlign: TextAlign.start,
              style: GoogleFonts.quicksand(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  try {
                    final resultado = await showSearch(
                        context: context, delegate: SearchDestination());
                    if (resultado!.cancelo == false) {
                      retornoBusqueda(resultado, direccionesService, context);
                    }
                  } catch (e) {
                    debugPrint('Ningun lugar seleccionado');
                  }
                },
                child: Container(
                    height: 80,
                    width: 45,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(.2))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: const Center(
                            child: Icon(
                          Icons.add,
                          color: Colors.black,
                        )))),
              ),
            ],
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          reverse: true,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return DireccionBuildWidget(
              onlyShow: false,
              icono: direccionesService.direcciones[index].icono,
              uid: direccionesService.direcciones[index].id,
              index: index,
              titulo: direccionesService.direcciones[index].texto,
              descripcion: direccionesService.direcciones[index].descripcion,
              latitud:
                  direccionesService.direcciones[index].coordenadas.latitud,
              longitud:
                  direccionesService.direcciones[index].coordenadas.longitud,
              predeterminado: direccionesService.direcciones[index].predeterminado,
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 10,
              ),
          itemCount: direccionesService.direcciones.length),
    );
  }

  void retornoBusqueda(SearchResult result,
      DireccionesService direccionesService, BuildContext context) async {
    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String texto = result.nombreDestino;
    final String descripcion = result.descripcion;
    final latitud = result.position.latitude;
    final longitud = result.position.longitude;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        texto, descripcion, latitud, longitud, false);
    if (nuevaDireccion) {
      Navigator.pop(context);
    } else {
      /**IMPLEMENTAR ALGO ERROR*/
    }
  }
}
