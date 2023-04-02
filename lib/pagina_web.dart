import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginaWeb extends StatelessWidget {
  const PaginaWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Overlay(
      initialEntries: [
        OverlayEntry(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    elevation: .3,
                    iconTheme: const IconThemeData(
                      color: Colors.black, //change your color here
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(''),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.apple,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Descargar',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.android,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Descargar',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  drawer: Drawer(
                    child: Column(
                      // Important: Remove any padding from the ListView.
                      children: [
                        Container(
                          height: height - 25,
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Iniciar sesion',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 25, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Registrate',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 25, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Crear una cuenta de negocios',
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Convertirse en repartidor',
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 9),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.apple,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Descargar',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 9),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.android,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Descargar',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 90,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Loops',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 60),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.only(top: 25),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 3),
                                              spreadRadius: -3,
                                              blurRadius: 5,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, .1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.place,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Text(
                                                'Lagos de Moreno, Jalisco',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      margin:
                                          const EdgeInsets.only(top: 25, left: 10),
                                      decoration: BoxDecoration(
                                          color:
                                              const Color.fromRGBO(62, 204, 191, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Buscar',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Color.fromRGBO(62, 204, 191, 1),
                                    ),
                                     SizedBox(
                                      width: 10,
                                    ),
                                     Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Color.fromRGBO(62, 204, 191, 1),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '• Politica de privacidad',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        '© 2023 Loops',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      ],
    );
  }
}
