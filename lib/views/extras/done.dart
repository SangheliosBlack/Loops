import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/views/extras/pedido_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DoneView extends StatelessWidget {
  final Venta venta;
  const DoneView({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMEEEEd('es-MX')
        .add_jm()
        .format(venta.createdAt.toLocal());
    double width = MediaQuery.of(context).size.width;
    PageController controller =
        PageController(viewportFraction: 1, initialPage: 0);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  venta.pedidos.length > 1
                      ? Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: venta.pedidos.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              activeDotColor: Colors.black.withOpacity(.8),
                              dotColor: Colors.black.withOpacity(.2),
                            ),
                          ),
                        )
                      : Container(),
                  AnimatedContainer(
                    margin: const EdgeInsets.only(top: 35),
                    width: width - 35,
                    height: width - 35,
                    padding: const EdgeInsets.all(40),
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            color: Colors.black.withOpacity(.2), width: .5)),
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(30),
                      duration: const Duration(milliseconds: 1000),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                              color: Colors.black.withOpacity(.4), width: .5)),
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(10),
                        duration: const Duration(milliseconds: 1000),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            border: Border.all(
                                color: Colors.black.withOpacity(.8), width: 1)),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 280,
                              child: PageView.builder(
                                physics: const BouncingScrollPhysics(),
                                controller: controller,
                                itemCount: venta.pedidos.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          venta.pedidos[index].imagen),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                              color: Colors.black,
                            )),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Resumen de orden',
                                style: GoogleFonts.quicksand(
                                    fontSize: 25, color: Colors.black),
                              ),
                            ),
                            const Expanded(
                                child: Divider(
                              color: Colors.black,
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (venta.pedidos
                                                  .map((e) => e.tienda)
                                                  .toString())
                                              .replaceAll('(', '')
                                              .replaceAll(')', '')
                                              .replaceAll(',', ' | '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(formattedDate,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 13,
                                                color: const Color.fromRGBO(
                                                    41, 199, 184, 1))),
                                      ],
                                    ),
                                    Text(
                                      'Orden ID:  ${venta.id}',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.grey.withOpacity(.8),
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cantidad',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$ ' +
                                                venta.total.toStringAsFixed(2),
                                            style: GoogleFonts.quicksand(
                                              fontSize: 25,
                                              color:
                                                  Colors.black.withOpacity(.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Metodo de pago',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  venta.efectivo
                                      ? Row(
                                          children: [
                                            Container(
                                              width: 65,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromRGBO(
                                                      137, 226, 137, 1)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 27),
                                              child: Text(
                                                '\$',
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('Efectivo',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 17,
                                                  color: Colors.black
                                                      .withOpacity(.8),
                                                ))
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 65,
                                                  height: 45,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 0),
                                                  decoration: BoxDecoration(
                                                      color: venta
                                                                  .metodoPago!
                                                                  .charges
                                                                  .data[0]
                                                                  .paymentMethodDetails
                                                                  .card
                                                                  .brand ==
                                                              'visa'
                                                          ? const Color
                                                                  .fromRGBO(
                                                              232, 241, 254, 1)
                                                          : const Color
                                                                  .fromRGBO(
                                                              251, 231, 220, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        color:
                                                            Colors.transparent,
                                                        height: 55,
                                                        width: 55,
                                                        child: SvgPicture.asset(
                                                          venta
                                                                      .metodoPago!
                                                                      .charges
                                                                      .data[0]
                                                                      .paymentMethodDetails
                                                                      .card
                                                                      .brand ==
                                                                  'visa'
                                                              ? 'assets/images/visa_color.svg'
                                                              : 'assets/images/mc.svg',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        venta
                                                            .metodoPago!
                                                            .charges
                                                            .data[0]
                                                            .paymentMethodDetails
                                                            .card
                                                            .last4,
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontSize: 25,
                                                          color: Colors.black
                                                              .withOpacity(1),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Proceso',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 35),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, int index) =>
                              EstadoWidget(pedido: venta.pedidos[index]),
                          itemCount: venta.pedidos.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total orden',
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  Text(
                                    '\$ ${(venta.total - venta.servicio - (venta.envioPromo == 0 ? venta.envio : 0)).toStringAsFixed(2)}',
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Envio',
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  Text(
                                    '\$ ${venta.envio.toStringAsFixed(2)}',
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                  )
                                ],
                              ),
                              venta.envioPromo > 0
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Promocion envio',
                                              style: GoogleFonts.quicksand(),
                                            ),
                                            Text(
                                              '- \$ ${venta.envioPromo.toStringAsFixed(2)}',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Servicio',
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  Text(
                                    '\$  ${venta.servicio.toStringAsFixed(2)}',
                                    style: GoogleFonts.quicksand(fontSize: 18),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                color: Colors.black.withOpacity(.1),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total :',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                  Text(
                                    '\$ ${venta.total.toStringAsFixed(2)}',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 30,
                                        color: const Color.fromRGBO(
                                            41, 199, 184, 1)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 45),
                            width: width - 70,
                            height: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromRGBO(41, 199, 184, 1)),
                            child: Center(
                              child: Text(
                                'Continuar',
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
