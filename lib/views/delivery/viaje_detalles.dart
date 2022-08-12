import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViajesDetallesView extends StatelessWidget {
  const ViajesDetallesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Stack(
          children: [
            Container(
              height: 300,
              width: width,
              color: const Color.fromRGBO(237, 241, 244, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified,
                    color: Color.fromRGBO(41, 199, 184, 1),
                    size: 60,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Orden de envio',
                    style: GoogleFonts.quicksand(
                        fontSize: 25, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Orden No. #SADS54 - Junio 15, 2020 | 3:01 PM',
                    style: GoogleFonts.quicksand(
                        fontSize: 14, color: Colors.black),
                  )
                ],
              ),
            ),
            const Positioned(top: 55, left: 25, child:  Icon(Icons.close))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Cliente detalles',
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontSize: 15)),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const SizedBox(
                          width: 45,
                          height: 45,
                          child: Image(
                              image: NetworkImage(
                                  'https://cdn.dribbble.com/users/1449854/avatars/normal/b1d1e7d443c5553addccf1d9c9eccde3.jpeg?1653643549')),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Julio Villagrana',
                          style: GoogleFonts.quicksand(
                              color: Colors.black, fontSize: 20)),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.grey.withOpacity(.2),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Envio',
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontSize: 15)),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            'Calle Andador 439, Paseos de La Montaña, Lagos de Moreno, Jal.',
                            style: GoogleFonts.quicksand(
                                color: Colors.black, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.grey.withOpacity(.2),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Articulos ordenados',
                      style: GoogleFonts.quicksand(
                          color: Colors.grey, fontSize: 15)),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' •  Nombre del articulo',
                        style: GoogleFonts.quicksand(fontSize: 14),
                      ),
                      Text(
                        'x1 = \$ 15.23',
                        style: GoogleFonts.quicksand(fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.grey.withOpacity(.2),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Total depositado',
                style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(.8), fontSize: 15),
              ),
              Text(
                '\$ 25.66',
                style: GoogleFonts.quicksand(
                    color: const Color.fromRGBO(41, 199, 184, 1), fontSize: 55),
              )
            ],
          ),
        )
      ]),
    );
  }
}
