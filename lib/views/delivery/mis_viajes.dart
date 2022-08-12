import 'package:delivery/views/delivery/viaje_detalles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MisViajesView extends StatelessWidget {
  const MisViajesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(.1))),
                  child: Row(
                    children: [
                      Text(
                        'Hoy',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: 35,
                        width: 1,
                        color: Colors.grey.withOpacity(.1),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ],
            )
          ],
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            'Historial',
            style: GoogleFonts.quicksand(color: Colors.black),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 15),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, int index) => const ViajeWidget(),
            itemCount: 15,
            separatorBuilder: (_, __) => const SizedBox(
              height: 15,
            ),
          ),
        ));
  }
}

class ViajeWidget extends StatelessWidget {
  const ViajeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViajesDetallesView()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(.1))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Orden No. #ASD54',
            style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            'Junio 14 ,2022 8:20 PM',
            style: GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified,
                    color: Color.fromRGBO(41, 199, 184, 1)
                    ,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Completado',
                    style: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.8)),
                  ),
                ],
              ),
              Text(
                '\$ 15.23',
                style: GoogleFonts.quicksand(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
