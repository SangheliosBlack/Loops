import 'package:delivery/models/tienda.dart';
import 'package:delivery/views/tienda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_stack/image_stack.dart';

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
    List<String> images = [
      "https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=Jio9uxV3F3IAX-ZGbw5&_nc_ht=scontent.fagu2-1.fna&oh=00_AT8jnSP5KzDKB301UlZgJFBnvn9bhzzVOinb743obtxuVA&oe=6259B46A",
      "https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=Jio9uxV3F3IAX-ZGbw5&_nc_ht=scontent.fagu2-1.fna&oh=00_AT8jnSP5KzDKB301UlZgJFBnvn9bhzzVOinb743obtxuVA&oe=6259B46A",
      "https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=Jio9uxV3F3IAX-ZGbw5&_nc_ht=scontent.fagu2-1.fna&oh=00_AT8jnSP5KzDKB301UlZgJFBnvn9bhzzVOinb743obtxuVA&oe=6259B46A",
      "https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=Jio9uxV3F3IAX-ZGbw5&_nc_ht=scontent.fagu2-1.fna&oh=00_AT8jnSP5KzDKB301UlZgJFBnvn9bhzzVOinb743obtxuVA&oe=6259B46A"
    ];
    double width = MediaQuery.of(context).size.width;
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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.00),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            width: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12, right: 1),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth,
                            height: 240,
                            child: const Image(
                              image: NetworkImage(
                                  'https://images.otstatic.com/prod1/32412251/3/huge.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.black.withOpacity(.6),
                                Colors.white.withOpacity(.4),
                              ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -15,
                      child: SizedBox(
                          height: 235,
                          width: small ? width - 40 : 241,
                          child: const HeaderWave())),
                  /*Positioned(
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
                ),*/
                  Positioned(
                    top: 125,
                    left: 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tienda.nombre,
                          style: GoogleFonts.playfairDisplay(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                        Text(
                          'Restaurante',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                          initialRating: 3.5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          ),
                          itemSize: 13,
                          unratedColor: Colors.grey,
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '2.4 km Centro, Lagos de Moreno ',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.moped_sharp,
                                size: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '\$ 12',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey, fontSize: 11),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '|',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ),
                              const Icon(
                                Icons.schedule,
                                size: 15,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '15 - 30 min',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ImageStack(
                            imageList: images,
                            totalCount: images.length,
                            imageRadius: 25,
                            imageCount: 4,
                            imageBorderWidth: 1,
                            showTotalCount: true,
                            extraCountBorderColor: Colors.white,
                            extraCountTextStyle:
                                GoogleFonts.quicksand(color: Colors.grey),
                            backgroundColor: Colors.white,
                            imageBorderColor: Colors.grey.withOpacity(.2),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HeaderWave extends StatelessWidget {
  const HeaderWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ignore: sized_box_for_whitespace
        Container(
          height: 270,
          width: double.infinity,
          child: CustomPaint(
            painter: _HeaderWavePainter(),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promedio',
                style: GoogleFonts.quicksand(fontSize: 11, color: Colors.grey),
              ),
              Text(
                '4,9',
                style: GoogleFonts.playfairDisplay(
                    height: .9,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(47, 47, 47, .9)),
              ),
            ],
          ),
        )
      ],
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
    lapiz.strokeWidth = 5;

    final path0 = Path();

    // Dibujar con el path y el lapiz
    path0.moveTo(0, size.height * 0.6714286);
    path0.quadraticBezierTo(size.width * 0.1250000, size.height * 0.5717857,
        size.width * 0.5008333, size.height * 0.6414286);
    path0.quadraticBezierTo(size.width * 0.8335417, size.height * 0.6792857,
        size.width * 0.9983333, size.height * 0.6);

    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);

    canvas.drawPath(path0, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
