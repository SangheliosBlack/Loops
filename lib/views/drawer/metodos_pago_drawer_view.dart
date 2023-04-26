import 'package:delivery/global/styles.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/helpers/confirmar_eliminacion.dart';
import 'package:delivery/models/tarjeta_model.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/stripe_service.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/views/extras/nuevo_metodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:delivery/extensions/extensions.dart';

class MetodosPagoView extends StatefulWidget {
  const MetodosPagoView({Key? key}) : super(key: key);

  @override
  MetodosPagoViewState createState() => MetodosPagoViewState();
}

class MetodosPagoViewState extends State<MetodosPagoView> {
  @override
  Widget build(BuildContext context) {
    final tarjetasService = Provider.of<TarjetasService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(top: 0, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 40, left: 25, right: 25, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monedero virtual',
                            style: GoogleFonts.quicksand(fontSize: 20)),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$',
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.playfairDisplay(
                                            fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    '000.',
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.quicksand(fontSize: 60),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    '00',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 4),
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, .8),
                                  content: Text(
                                    'Proximamente...',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                    ),
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Icon(
                                  Icons.more_vert,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'Mis tarjetas',
                      style: GoogleFonts.quicksand(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 225,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 20),
                      children: [
                        cardAdd(context, tarjetasService),
                        SizedBox(
                            height: 185,
                            child:
                                listaTarjetas(tarjetasService.listaTarjetas)),
                      ],
                    ),
                  ),
                  /*Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Ultimas compras',
                              style: Styles.letterCustom(15, false, .7),
                            ),
                          ),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  boughtItem(),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey.withOpacity(.0),
                                      ),
                              itemCount: 10)
                        ],
                      )),*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView listaTarjetas(List<Tarjeta>? data) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) =>
            card(context, data[index]),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 15),
        itemCount: data!.length);
  }

  Widget boughtItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: Styles.containerCustom(100),
                  child: const Icon(
                    Icons.moped_outlined,
                    size: 30,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Concepto movimiento',
                    style: GoogleFonts.quicksand(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '11:31am • Mar 18',
                    style:
                        GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Text(
            '\$148.00',
            style: GoogleFonts.quicksand(fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget cardAdd(BuildContext context, TarjetasService tarjetasService) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AgregarNuevoMetodo()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15, top: 30),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(.2)),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        width: 70,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget card(
    BuildContext context,
    Tarjeta datum,
  ) {
    final customerService = Provider.of<StripeService>(context);
    final tarjetaService = Provider.of<TarjetasService>(context);
    final authService = Provider.of<AuthService>(context);
    final stripeService = Provider.of<StripeService>(context);
    double width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: datum.id == customerService.tarjetaPredeterminada ? 1 : 0,
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
                Positioned.fill(
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 7, bottom: 115),
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      itemHeight: 57,
                      elevation: 0,
                      iconSize: 0,
                      onChanged: (boton) async {
                        if (boton == 'Predeterminado') {
                          calculandoAlerta(context);
                          final confirm =
                              await stripeService.metodoPredeterminado(
                                  id: datum.id,
                                  customer: authService.usuario.customerID);
                          if(context.mounted) Navigator.pop(context);
                          if (confirm == false) {
                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromRGBO(253, 95, 122, 1),
                              content: Text(
                                'Error desconocido ...',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                ),
                              ),
                            );

                            if(context.mounted){
                              ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            }
                          }
                        } else if (boton == 'Eliminar') {
                          final eliminar = await confirmarEliminacion(
                              context: context,
                              tipo: 1,
                              titulo:
                                  'Tarjeta ${(datum.card.brand).capitalize()} con terminacion ${datum.card.last4}');
                          if (eliminar) {
                            if(context.mounted) calculandoAlerta(context);
                            if (stripeService.tarjetaPredeterminada ==
                                datum.id) {
                              stripeService.tarjetaPredeterminada = '';
                            }
                            final confirm = await tarjetaService
                                .eliminarMetodoPago(id: datum.id);

                            if (confirm == false) {
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 4),
                                backgroundColor:
                                    const Color.fromRGBO(253, 95, 122, 1),
                                content: Text(
                                  'Error desconocido ...',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );

                              if(context.mounted){
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              }
                            }

                            if(context.mounted) Navigator.pop(context);
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(15),
                      underline: Container(),
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      hint: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.6),
                            borderRadius: BorderRadius.circular(7)),
                        child: Icon(
                          Icons.more_vert,
                          color: datum.card.brand == 'visa'
                              ? Colors.blue
                              : Colors.orange,
                          size: 25,
                        ),
                      ),
                      items: <dynamic>[
                        {'titulo': 'Predeterminado', 'icono': Icons.favorite},
                        {'titulo': 'Eliminar', 'icono': Icons.delete},
                        {'titulo': 'Cerrar', 'icono': Icons.close},
                      ].map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value['titulo'],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value['titulo'],
                                style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: datum.card.brand == 'visa'
                                        ? const Color.fromRGBO(232, 241, 254, 1)
                                        : const Color.fromRGBO(
                                            251, 231, 220, 1),
                                  ),
                                  child: Icon(
                                    (value['icono']),
                                    color: datum.card.brand == 'visa'
                                        ? Colors.blue
                                        : Colors.orange,
                                    size: 15,
                                  ))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget fondo(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffF3F5F6),
      ),
      Container(
        decoration: const BoxDecoration(
            color: Color(0xffF3F5F6),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        width: double.infinity,
        height: 310,
      )
    ]);
  }

  Widget starts() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Row(
        children: [
          start(),
          start(),
          start(),
          start(),
          start(),
        ],
      ),
    );
  }

  Icon start() {
    return const Icon(
      Icons.star,
      size: 13,
      color: Colors.white,
    );
  }

  void agregarNuevoMetodo(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.white,
        builder: (builder) {
          return const Text('♥9dasdasdasdas');
        });
  }

  void movePage(PageController controller, double page) {
    controller.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
