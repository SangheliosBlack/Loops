import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: const Color(0xffF3F5F6),
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              const Notificacion(),
          itemCount: 10,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
        ),
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
            color: const Color.fromRGBO(233, 78, 78, 1),
            borderRadius: BorderRadius.circular(15)),
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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(.1))),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffF3F5F6)),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre de la notificacion',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.7),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.delivery_dining_outlined,
                              color: Color.fromRGBO(41, 199, 184, 1),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Descripcion de la notificacion',
                              style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(.3)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '9:12 AM',
                  textAlign: TextAlign.end,
                  style:
                      GoogleFonts.quicksand(color: Colors.grey.withOpacity(.7)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
