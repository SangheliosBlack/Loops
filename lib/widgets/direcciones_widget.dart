import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/views/extras/editar_direccion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DireccionBuildWidget extends StatelessWidget {
  final Direccion direccion;
  final bool show;
  final bool isChangue;

  const DireccionBuildWidget({
    Key? key,
    required this.direccion,
    this.isChangue = false,
    this.show = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final direccionesService = Provider.of<DireccionesService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isChangue) {
          Navigator.pop(context);
          authService.cambiarDireccionCesta(
              direccion: direccion,
              direcciones: direccionesService.direcciones);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarDireccionView(
                      direccion: direccion,
                    )),
          );
        }
      },
      child: show
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      width: 25,
                      height: 25,
                      child: Icon(
                        Icons.place_outlined,
                        color: Colors.red,
                        size: 16,
                      )),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          direccion.titulo.split(',')[0],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            )
          : Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: double.infinity,
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 35,
                          height: 35,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(.2)),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.place_outlined,
                            color: Colors.black,
                            size: 22,
                          )),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              direccion.titulo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      isChangue
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.only(left: 12),
                              child: Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey.withOpacity(.4), size: 20))
                    ],
                  ),
                ),
                Positioned(
                  left: 68,
                  top: -5,
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: direccion.predeterminado ? 1 : 0,
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            'Predeterminado',
                            style: GoogleFonts.quicksand(
                                fontSize: 12,
                                color: const Color.fromRGBO(253, 95, 122, 1)),
                          ))),
                )
              ],
            ),
    );
  }
}
