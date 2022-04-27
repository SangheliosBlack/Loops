import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DireccionesSeleccion extends StatelessWidget {
  const DireccionesSeleccion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionesService = Provider.of<DireccionesService>(context);
    final authService = Provider.of<AuthService>(context);
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 25, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.expand_less,
                            color: Colors.black.withOpacity(.8),
                          ),
                          Text(
                            'Cancelar',
                            style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: Colors.black.withOpacity(.8)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
        SizedBox(
          height: 400,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
              reverse: false,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (authService.usuario.cesta.direccion.titulo ==
                    direccionesService.direcciones[index].titulo) {
                  return Container();
                } else {
                  if (obtenerFavorito(direccionesService.direcciones) == -1) {
                    return DireccionBuildWidget(
                        direccion: direccionesService.direcciones[index]);
                  } else {
                    if (direccionesService
                            .direcciones[
                                obtenerFavorito(direccionesService.direcciones)]
                            .titulo ==
                        direccionesService.direcciones[index].titulo) {
                      return Container();
                    } else {
                      return DireccionBuildWidget(
                          direccion: direccionesService.direcciones[index]);
                    }
                  }
                }
              },
              separatorBuilder: (BuildContext context, int index) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(
                      color: Colors.grey.withOpacity(0),
                    ),
                  ),
              itemCount: direccionesService.direcciones.length),
        ),
      ],
    );
  }

  obtenerFavorito(List<Direccion> direcciones) {
    final busqueda =
        direcciones.indexWhere((element) => element.predeterminado);
    return busqueda;
  }
}
