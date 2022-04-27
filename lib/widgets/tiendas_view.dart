
import 'package:delivery/global/styles.dart';
import 'package:delivery/service/drawer_service.dart';
import 'package:delivery/views/socio/editar_tienda_view.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TiendasView extends StatelessWidget {
  final String nombre;

  const TiendasView({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            color: const Color(0xffF3F5F6),
            height: height,
            padding: const EdgeInsets.only(top: 10, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              drawerAction.openDraw();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: Styles.containerCustom(),
                              child: Icon(
                                FontAwesomeIcons.bars,
                                size: 23,
                                color: Colors.black.withOpacity(.5),
                              ),
                            ),
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: Styles.containerCustom(),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Center(
                                      child: Icon(
                                    Icons.notifications,
                                    color: Colors.black.withOpacity(.4),
                                  )))),
                        ],
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 20,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).primaryColor),
                          child: Center(
                            child: Text(
                              '5',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  height: 35,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditarTiendaView()),
                          );
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Configuracion',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          padding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.rightLeft,
                                size: 13,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Mis tiendas',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Mi equipo',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    )),
                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 79,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      color: Colors.white, width: 3)),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                'Agregar',
                                style: GoogleFonts.quicksand(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Mis pedidos',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    )),
                /*AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                            height: 130,
                            margin: EdgeInsets.only(top: 10),
                            child: ListView.separated(
                              itemBuilder: (BuildContext context, int indx) =>
                                  itemDesc(context),
                              separatorBuilder: (BuildContext context, int index) =>
                                  SizedBox(width: 10),
                              itemCount: 5,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),*/
                const SizedBox(height: 10),
                Container(
                  height: 170,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 70,
                        color: Colors.black.withOpacity(.2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sin pedidos por ahora',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Ver mis productos',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                )
                /*AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              height: 220,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: pedidos(context)),
                        ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}






