import 'package:delivery/models/direccion.dart';
import 'package:delivery/views/extras/editar_direccion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DireccionBuildWidget extends StatelessWidget {
  final Direccion direccion;
  final bool onlyShow;

  const DireccionBuildWidget({
    Key? key,
    required this.onlyShow,
    required this.direccion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditarDireccionView(
                    direccion: direccion,
                  )),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
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
                  Container(
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
                  opacity: onlyShow
                      ? 0
                      : direccion.predeterminado
                          ? 1
                          : 0,
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
      ),
    );
  }
}
