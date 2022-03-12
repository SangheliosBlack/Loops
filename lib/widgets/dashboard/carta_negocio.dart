import 'package:delivery/models/tienda.dart';
import 'package:delivery/views/tienda.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartaNegocio extends StatelessWidget {
  final bool small;
  final Tienda tienda;
  final int index;

  const CartaNegocio(
      {Key? key,
      required this.index,
      required this.tienda,
      required this.small})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoreIndividual(
                    tienda: tienda,
                  )),
        );
      },
      child: SizedBox(
        width: 210,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const Image(
                    image: NetworkImage(
                        'https://images.otstatic.com/prod1/32412251/3/huge.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const HeaderWave(),
            Positioned(
              top: 0,
              child: SizedBox(
                width: 210,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Hero(
                          tag: index,
                          child: const SizedBox(
                            height: 45,
                            width: 45,
                            child: SizedBox(
                              height: double.infinity,
                              child: Image(
                                image: NetworkImage(
                                    'https://images.vexels.com/media/users/3/215185/raw/9975fac6938d6d19c33105e44655a3c8-diseno-de-logo-de-restaurante-cheff.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -0,
              child: Container(
                width: 190,
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(tienda.nombre,
                          style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Text('123 reviews - 12 min - ',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11,
                                  color: Colors.black.withOpacity(.6))),
                          const Icon(
                            Icons.moped_sharp,
                            size: 12,
                          ),
                          Text(' \$ 13.22',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11,
                                  color: Colors.black.withOpacity(.6))),
                        ],
                      ),
                      SizedBox(
                        width: 210,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromRGBO(62, 204, 191, 1)),
                              child: Text(
                                '5.5',
                                style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderWave extends StatelessWidget {
  const HeaderWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 1000,
      child: CustomPaint(
        painter: _HeaderWavePainter(),
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    // Propiedades
    lapiz.color = Colors.white;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 20;

    final path0 =  Path();

    // Dibujar con el path y el lapiz

    path0.quadraticBezierTo(
        size.width * 0.38, 1, size.width * 0.37, size.height * 0.13);

    path0.lineTo(size.width * 0.5, size.height * 0.18);
    path0.lineTo(size.width * 0.63, size.height * 0.13);

    path0.quadraticBezierTo(size.width * .62, 1, size.width, 0);

    canvas.drawPath(path0, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
