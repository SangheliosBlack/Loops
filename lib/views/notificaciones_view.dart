import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        /*actions: [
          Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.search))
        ],*/
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Notificaciones',
            style: GoogleFonts.quicksand(
              color: Colors.black,
            )),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => const Notificacion(),
        itemCount: 10,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 0),
      ),
    );
  }
}

class Notificacion extends StatelessWidget {
  const Notificacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: Image(image: AssetImage('assets/images/repartidor.png')),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripcion de la notificacion aqui no importa',
                      style: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.8),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Nombre app · Lunes, 4:15 PM ',
                      style: GoogleFonts.quicksand(
                          fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
