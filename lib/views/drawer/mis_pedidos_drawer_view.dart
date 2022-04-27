import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MisPedidosView extends StatelessWidget {
  const MisPedidosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Mis ordenes',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(41, 199, 184, 1),
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'En curso',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        )),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Completado',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        )),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Cancelado',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        )),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Reclamo',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
