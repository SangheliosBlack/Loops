import 'package:delivery/models/tarjeta_model.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/stripe_service.dart';
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
    final authService = Provider.of<AuthService>(context);
    final stripeService = Provider.of<StripeService>(context);
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.expand_less,
                                color: Colors.black.withOpacity(.8),
                              ),
                              Text(
                                'Cancelar',
                                style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(.8)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: 225,
              child: ListView.separated(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (authService.usuario.cesta.tarjeta == '') {
                      if (stripeService.tarjetaPredeterminada ==
                          tarjetasService.listaTarjetas[index].id) {
                        return Container();
                      } else {
                        return card(
                            context, tarjetasService.listaTarjetas[index]);
                      }
                    } else {
                      if (stripeService.tarjetaPredeterminada ==
                              tarjetasService.listaTarjetas[index].id &&
                          authService.usuario.cesta.tarjeta == '') {
                        return Container();
                      } else {
                        return card(
                            context, tarjetasService.listaTarjetas[index]);
                      }
                    }
                  },
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
    final customerService = Provider.of<StripeService>(context);
    final authService = Provider.of<AuthService>(context);
    double width = MediaQuery.of(context).size.width;
    final stripeService = Provider.of<StripeService>(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
        authService.cambiarTarjetaCesta(
            id: datum.id,
            tarjetaPredeterminada: stripeService.tarjetaPredeterminada);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity:
                  datum.id == customerService.tarjetaPredeterminada ? 1 : 0,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: datum.card.brand == 'visa'
                            ? Colors.blue
                            : Colors.orange,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Predeterminada',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          color: datum.card.brand == 'visa'
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ))),
          Expanded(
            child: Container(
              width: width - 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    datum.card.brand == 'visa'
                        ? const Color.fromRGBO(232, 241, 254, 1)
                        : const Color.fromRGBO(251, 231, 220, 1),
                    datum.card.brand == 'visa'
                        ? const Color.fromRGBO(232, 241, 254, 1)
                        : const Color.fromRGBO(251, 231, 220, 1)
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 13,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Valido hasta',
                            style: GoogleFonts.quicksand(
                                color: datum.card.brand == 'visa'
                                    ? Colors.blue
                                    : Colors.orange,
                                fontSize: 12)),
                        const SizedBox(
                          height: 4,
                        ),
                        Text('${datum.card.expMonth}/${datum.card.expYear}',
                            style: GoogleFonts.sairaCondensed(
                                height: 1,
                                color: datum.card.brand == 'visa'
                                    ? Colors.blue
                                    : Colors.orange,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 13,
                      left: 15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ultimos 4 digitos',
                            style: GoogleFonts.quicksand(
                                color: datum.card.brand == 'visa'
                                    ? Colors.blue
                                    : Colors.orange,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Text(
                                datum.card.last4,
                                style: GoogleFonts.sairaCondensed(
                                    height: 1,
                                    color: datum.card.brand == 'visa'
                                        ? Colors.blue
                                        : Colors.orange,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      )),
                  Positioned(
                      right: 10,
                      top: datum.card.brand == 'visa' ? -5 : 10,
                      child: SizedBox(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: datum.card.brand == 'visa'
                                ? SizedBox(
                                    width: 80,
                                    child: SvgPicture.asset(
                                      'assets/images/visa_color.svg',
                                      height: 80,
                                      width: 80,
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
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
