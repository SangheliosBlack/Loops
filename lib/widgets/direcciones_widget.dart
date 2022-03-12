import 'package:delivery/service/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DireccionBuildWidget extends StatelessWidget {
  final bool predeterminado;
  final int index;
  final String titulo;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String uid;
  final int icono;
  final bool onlyShow;

  const DireccionBuildWidget(
      {Key? key,
      required this.index,
      required this.titulo,
      required this.descripcion,
      required this.latitud,
      required this.longitud,
      required this.icono,
      required this.uid,
      required this.onlyShow,
      required this.predeterminado})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigationService.navigateTo('/extras/editarDirecciones/$index');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: double.infinity,
              height: 95,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 65,
                      height: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(235, 248, 248, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        IconData(icono, fontFamily: 'MaterialIcons'),
                        color: const Color.fromRGBO(41, 199, 184, 1),
                        size: 30,
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey.withOpacity(.8)),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: onlyShow
                      ? 0
                      : predeterminado
                          ? 1
                          : 0,
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(253, 95, 122, 1)),
                      child: const Icon(
                        Icons.favorite,
                        size: 15,
                        color: Colors.white,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
