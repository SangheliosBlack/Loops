import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MisDireccionesView extends StatelessWidget {
  const MisDireccionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    final sugerencia = Provider.of<PermissionStatusProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Mis direcciones',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(
              color: Colors.black.withOpacity(.8), fontSize: 17),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (sugerencia.listaSugerencias.isEmpty) {
                calculandoAlerta(context);
                try {
                  if (sugerencia.listaSugerencias.isEmpty) {
                    await sugerencia.ubicacionActual();
                  }
                  if(context.mounted){
                    final resultado = await showSearch(
                      context: context, delegate: SearchDestination());
                  if (resultado!.cancelo == false) {
                    if(context.mounted) retornoBusqueda(resultado, direccionesService, context);
                  }
                  }
                } catch (e) {
                  debugPrint('Ningun lugar seleccionado');
                }
                if(context.mounted) Navigator.pop(context);
              } else {
                try {
                  final resultado = await showSearch(
                      context: context, delegate: SearchDestination());
                  if (resultado!.cancelo == false) {
                    if(context.mounted) retornoBusqueda(resultado, direccionesService, context);
                  }
                } catch (e) {
                  debugPrint('Ningun lugar seleccionado');
                }
              }
            },
            child: Container(
                height: 80,
                width: 45,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0))),
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
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          reverse: true,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return DireccionBuildWidget(
              direccion: direccionesService.direcciones[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Divider(
                  color: Colors.grey.withOpacity(.10),
                ),
              ),
          itemCount: direccionesService.direcciones.length),
    );
  }

  void retornoBusqueda(SearchResult result,
      DireccionesService direccionesService, BuildContext context) async {
    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String titulo = result.titulo;
    final double latitud = result.latitud;
    final double longitud = result.longitud;
    final String id = result.placeId;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        id: id, latitud: latitud, longitud: longitud, titulo: titulo);
    if (nuevaDireccion) {
      if(context.mounted) Navigator.pop(context);
    } else {
      /**IMPLEMENTAR ALGO ERROR*/
    }
  }
}
