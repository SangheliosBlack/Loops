import 'package:delivery/global/styles.dart';
import 'package:delivery/models/tarjeta_model.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MetodoPredeterminado extends StatelessWidget {
  const MetodoPredeterminado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarjetasService = Provider.of<TarjetasService>(context);
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[100]),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[500],
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      'Selecciona un metodo de pago',
                      style: GoogleFonts.quicksand(
                          fontSize: 20, color: Colors.black.withOpacity(.8)),
                    ),
                  ],
                )),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 190,
              child: ListView.separated(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      card(context, tarjetasService.listaTarjetas[index]),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 15),
                  itemCount: tarjetasService.listaTarjetas.length),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ],
    );
  }

  Widget card(
    BuildContext context,
    Tarjeta datum,
  ) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width - 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              datum.card.brand == 'visa'
                  ? const Color.fromRGBO(46, 161, 207, 1)
                  : const Color.fromRGBO(66, 64, 65, 1),
              datum.card.brand == 'visa'
                  ? const Color.fromRGBO(32, 95, 165, 1)
                  : const Color.fromRGBO(3, 1, 2, 1)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
      child: Stack(
        children: [
          Positioned(
            bottom: 13,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Valido hasta',
                  style:
                      GoogleFonts.quicksand(color: Colors.white, fontSize: 8),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text('${datum.card.expMonth}/${datum.card.expYear}',
                    style: Styles.letterCustom(15, true, -0.1)),
              ],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ultimos 4 digitos',
                    style:
                        GoogleFonts.quicksand(color: Colors.white, fontSize: 8),
                  ),
                  Row(
                    children: [
                      Text(
                        datum.card.last4,
                        style: GoogleFonts.sairaCondensed(
                            color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ],
              )),
          Positioned(
              bottom: 10,
              right: 10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: datum.card.brand == 'visa' ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: 25,
                    width: 50,
                    child: SvgPicture.asset(
                      'assets/images/visa_color.svg',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              )),
          Positioned(
              left: 15,
              top: 15,
              child: SizedBox(
                width: width - 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: datum.card.brand == 'visa'
                            ? SizedBox(
                                width: 70,
                                child: SvgPicture.asset(
                                  'assets/images/visa.svg',
                                  height: 50,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              )
                            : SizedBox(
                                width: 70,
                                child: SvgPicture.asset(
                                  'assets/images/mc.svg',
                                  height: 50,
                                  width: 50,
                                ),
                              )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
