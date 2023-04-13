import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class PaginaWeb extends StatelessWidget {
  const PaginaWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Overlay(
      initialEntries: [
        OverlayEntry(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    elevation: 1,
                    iconTheme: const IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    backgroundColor: Colors.black,
                    title: const Text(''),
                    actions: [
                      Center(
                        child: Row(
                          children: [
                            Text(
                              'Proximamente...',
                              style: GoogleFonts.quicksand(color: Colors.white),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              FontAwesomeIcons.googlePlay,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.appStore,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  drawer: Drawer(
                    backgroundColor: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Important: Remove any padding from the ListView.
                      children: [
                        Text(
                          'Proximamente...',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          Icons.surfing,
                          color: Colors.white,
                          size: 150,
                        )
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            height: height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/pub.jpeg'),
                                  fit: BoxFit.cover),
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(.8),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/path.svg',
                                      fit: BoxFit.cover,
                                      width: 180,
                                      height: 180,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      width: 250,
                                      height: 1,
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                    ),
                                    Text(
                                      'DELIVERY',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white, fontSize: 32),
                                    ),
                                    SizedBox(
                                      height: 70,
                                    ),
                                    Row(
                                      children: [
                                        Text('Solicita repartidores',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('- Ser mayor a 18 años',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  '- Identificacion oficial con CURP',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  '- Licencia de conducir vigente',
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Colors.white,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  '- Tarjeta de circulacion vigente',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('- Motocicleta propia',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                  '- Recompensa por comisiones',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('- Vales de gasolina',
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Colors.white,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('- Sueldo diario',
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Colors.white,
                                                      fontSize: 18)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.black,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _launchUrl(
                                        url:
                                            'https://www.facebook.com/profile.php?id=100088086092372');
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    _launchUrl(
                                        url:
                                            'https://www.instagram.com/loopsdelivery/');
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchWhatsAppUri();
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '© 2023 Loops',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
      ],
    );
  }

  launchWhatsAppUri() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+52-(474)1030509',
      text: "Hola, quisiera participar como repartidor en Loops!",
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launchUrl(link.asUri());
  }

  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
