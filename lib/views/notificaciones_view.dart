import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.search))
        ],
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
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              'Eliminar',
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
          ],
        ),
      ),
      child: Container(
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
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 17, right: 4),
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(249, 250, 252, 1)),
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 5, color: Colors.white),
                          color: Colors.grey.withOpacity(.3),
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.moped_sharp,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                ],
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
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nombre app · Lunes, 4:15 PM ',
                        style: GoogleFonts.quicksand(
                            fontSize: 13, color: Colors.black.withOpacity(.3)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
