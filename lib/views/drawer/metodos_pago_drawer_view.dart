import 'package:delivery/global/styles.dart';
import 'package:delivery/models/tarjeta_model.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:delivery/views/extras/nuevo_metodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MetodosPagoView extends StatefulWidget {
  const MetodosPagoView({Key? key}) : super(key: key);

  @override
  _MetodosPagoViewState createState() => _MetodosPagoViewState();
}

class _MetodosPagoViewState extends State<MetodosPagoView> {
  @override
  Widget build(BuildContext context) {
    final tarjetasService = Provider.of<TarjetasService>(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.05),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 0),
              ),
            ]),
            child: AppBar(
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
        body: Stack(
          children: [
            fondo(context),
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
                          Text(
                            'Monedero virtual',
                            style: Styles.letterCustom(15, false, .7),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      '\$',
                                      textAlign: TextAlign.end,
                                      style:
                                          Styles.letterCustom(30, false, 0.3),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      '000.',
                                      textAlign: TextAlign.end,
                                      style: Styles.letterCustom(50, false, 1),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      '00',
                                      style: Styles.letterCustom(30, false, 1),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        const Color.fromRGBO(62, 204, 191, 1),
                                    content: Text(
                                      'Proximamente...',
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold),
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
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 30,
                                    color: Colors.black.withOpacity(.3),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 25, bottom: 15),
                      child: Text(
                        'Mis tarjetas',
                        style: Styles.letterCustom(15, false, .7),
                      ),
                    ),
                    SizedBox(
                      height: 170,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 20),
                        children: [
                          cardAdd(context, tarjetasService),
                          SizedBox(
                              height: 170,
                              child:
                                  listaTarjetas(tarjetasService.listaTarjetas)),
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                'Ultimas compras',
                                style: Styles.letterCustom(15),
                              ),
                            ),
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        boughtItem(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          width: double.infinity,
                                          height: 1,
                                          color: Colors.grey.withOpacity(.1),
                                        ),
                                itemCount: 10)
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView listaTarjetas(List<Tarjeta>? data) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) =>
            card(context, data![index]),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 15),
        itemCount: data!.length);
  }

  Row boughtItem() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: Styles.containerCustom(100),
                  child: const Icon(
                    Icons.moped,
                    size: 30,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Concepto movimiento',
                    style: Styles.letterCustom(14, true, .8),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Yesterday 9:08 AM',
                    style: Styles.letterCustom(11, false, .5),
                  )
                ],
              )
            ],
          ),
        ),
        Text(
          '\$ 148.99',
          style: Styles.letterCustom(15, true, .8),
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
        /*tarjetasService.newCreditCard
        (id.id!);
        StripeServiceCustom().getTarjetas();

        if (mounted) {
          setState(() {});
        }*/
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 70,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(42, 200, 185, 1),
        ),
      ),
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
                    SizedBox(
                      width: 143,
                      child: DropdownButton(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        alignment: Alignment.centerRight,
                        iconSize: 0,
                        onChanged: (dasdas) {},
                        borderRadius: BorderRadius.circular(20),
                        underline: Container(),
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        hint: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        items: <dynamic>[
                          {'titulo': 'Predeterminado', 'icono': Icons.favorite},
                          {'titulo': 'Editar', 'icono': Icons.edit},
                          {'titulo': 'Eliminar', 'icono': Icons.delete},
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value['titulo'],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value['titulo'],
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xffF3F5F6)),
                                    child: Icon(
                                      (value['icono']),
                                      color: Colors.grey,
                                      size: 15,
                                    ))
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
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
