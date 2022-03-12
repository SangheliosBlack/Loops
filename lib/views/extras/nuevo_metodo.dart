// ignore_for_file: prefer_const_constructors

import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/service/tarjetas.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgregarNuevoMetodo extends StatefulWidget {
  const AgregarNuevoMetodo({Key? key}) : super(key: key);

  @override
  State<AgregarNuevoMetodo> createState() => _AgregarNuevoMetodoState();
}

class _AgregarNuevoMetodoState extends State<AgregarNuevoMetodo> {
  int pagina = 0;

  bool cero = false;
  bool uno = false;
  bool tres = false;

  bool send = false;

  String valorUno = "";
  String valorDos = "";
  String valorTres = "";

  bool confirmar = false;

  @override
  Widget build(BuildContext context) {
    PageController controller2 = PageController();
    final tarjetaService = Provider.of<TarjetasService>(context);
    return WillPopScope(
      onWillPop: () async {
        if (send) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3F5F6),
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
              title: Text(
                'Nuevo metodo',
                textAlign: TextAlign.start,
                style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              toolbarHeight: 65,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                        width: double.infinity,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Stack(children: [
                          Positioned(
                            left: 17,
                            bottom: 70,
                            child: Text(valorUno,
                                style: GoogleFonts.inconsolata(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Positioned(
                            bottom: 100,
                            left: 20,
                            child: Text(
                              'NUMERO DE TARJETA',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.withOpacity(.6)),
                            ),
                          ),
                          Positioned(
                              right: 20,
                              top: 10,
                              child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: checkBrand(valorUno) != 0
                                      ? checkBrand(valorUno) == 1
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
                                            )
                                      : const Text(''))),
                          Positioned(
                              bottom: 18,
                              left: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VENCE EL',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.withOpacity(.6)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    valorDos,
                                    style: GoogleFonts.inconsolata(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          Positioned(
                              bottom: 18,
                              left: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CCV',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.withOpacity(.6)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    valorTres,
                                    style: GoogleFonts.inconsolata(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                        ])),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Ingresa tu tarjeta',
                style: GoogleFonts.quicksand(
                    color: const Color(0xff444752),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 114,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller2,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Numero de tarjeta',
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 15),
                              )),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              autofocus: true,
                              initialValue: valorUno,
                              textInputAction: TextInputAction.next,
                              enableInteractiveSelection: false,
                              inputFormatters: [
                                CreditCardNumberInputFormatter(),
                                LengthLimitingTextInputFormatter(19),
                              ],
                              onChanged: (valor) {
                                if (mounted) {
                                  setState(() {
                                    valorUno = valor;
                                  });
                                }
                              },
                              onEditingComplete: () {
                                if (cero) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (mounted) {
                                    setState(() {
                                      pagina = 1;
                                    });
                                  }
                                  controller2.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                }
                              },
                              validator: (valor) {
                                final String newValue =
                                    valor!.replaceAll(" ", "");
                                if (checkBrandExist(newValue)) {
                                  if (newValue.length >= 16) {
                                    cero = true;
                                    return null;
                                  } else {
                                    cero = false;
                                    return "Numero incompleto";
                                  }
                                } else {
                                  cero = false;
                                  return "Tarjeta no valida";
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: GoogleFonts.quicksand(
                                  color: const Color(0xff444652),
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: '#### #### #### ####',
                                  hintStyle:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                  helperText:
                                      '16 digitos tal como aparecen en su tarjeta',
                                  helperStyle: GoogleFonts.quicksand(
                                      color: const Color(0xff444752),
                                      fontWeight: FontWeight.w600),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1))),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'Fecha de vencimiento',
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 15),
                                )),
                            TextFormField(
                              initialValue: valorDos,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (valor) {
                                if (checkDate(valor!)) {
                                  uno = true;
                                  return null;
                                } else {
                                  uno = false;
                                  return "Campo invalido";
                                }
                              },
                              enableInteractiveSelection: false,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                CreditCardExpirationDateFormatter(),
                              ],
                              onChanged: (valor) {
                                if (mounted) {
                                  setState(() {
                                    valorDos = valor;
                                  });
                                }
                              },
                              onEditingComplete: () {
                                if (uno) {
                                  if (mounted) {
                                    setState(() {
                                      pagina = 2;
                                    });
                                  }
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  controller2.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                }
                              },
                              style: GoogleFonts.quicksand(
                                  color: const Color(0xff444652),
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: '00/00',
                                  helperText:
                                      'Fecha de vencimiento tal como aparecen en su tarjeta',
                                  helperStyle: GoogleFonts.quicksand(
                                      color: const Color(0xff444752),
                                      fontWeight: FontWeight.w600),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text('Codigo de seguridad',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 15))),
                            TextFormField(
                              validator: (valor) {
                                if (checkCvv(valor!)) {
                                  tres = true;
                                  return null;
                                } else {
                                  tres = false;
                                  return "Campo invalido";
                                }
                              },
                              onChanged: (valor) {
                                if (mounted) {
                                  setState(() {
                                    valorTres = valor;
                                  });
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              enableInteractiveSelection: false,
                              initialValue: valorTres,
                              inputFormatters: [CreditCardCvcInputFormatter()],
                              style: GoogleFonts.quicksand(
                                  color: const Color(0xff444652),
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: '000',
                                  helperText: 'Codigo de seguridad 3-4 digitos',
                                  helperStyle: GoogleFonts.quicksand(
                                      color: const Color(0xff444752),
                                      fontWeight: FontWeight.w600),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(.2),
                                          width: 1))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: pagina >= 1
                          ? send
                              ? 0
                              : 1
                          : 0,
                      child: GestureDetector(
                        onTap: pagina >= 1
                            ? !send
                                ? () async {
                                    if (mounted) {
                                      setState(() {
                                        pagina = pagina - 1;
                                      });
                                    }
                                    controller2.animateToPage(pagina,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut);
                                  }
                                : null
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: const EdgeInsets.only(right: 10, top: 20),
                          width: 110,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.withOpacity(.2)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Anterior',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Colors.grey.withOpacity(.6),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: pagina != 2
                          ? () async {
                              if (pagina == 0) {
                                if (cero) {
                                  if (mounted) {
                                    setState(() {
                                      pagina = pagina + 1;
                                    });
                                  }
                                  controller2.animateToPage(pagina,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                }
                              } else if (pagina == 1) {
                                if (uno) {
                                  if (mounted) {
                                    setState(() {
                                      pagina = pagina + 1;
                                    });
                                  }
                                  controller2.animateToPage(pagina,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                }
                              }
                            }
                          : checkCvv(valorTres) && !send
                              ? () async {
                                  calculandoAlerta(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  setState(() {
                                    send = true;
                                  });
                                  final bool tarjeta =
                                      await tarjetaService.newPaymentMethod(
                                          card: valorUno.replaceAll(" ", ""),
                                          cardExpMonth: valorDos.split('/')[0],
                                          cardExpYear: valorDos.split('/')[1],
                                          cardCvc: valorTres);
                                  if (tarjeta) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {}
                                }
                              : null,
                      child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(
                              horizontal: send ? 0 : 15, vertical: 10),
                          margin: const EdgeInsets.only(right: 25, top: 10),
                          width: send ? 45 : 110,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color.fromRGBO(41, 199, 184, 1)
                                    .withOpacity(pagina != 2
                                        ? 1
                                        : checkCvv(valorTres)
                                            ? 1
                                            : .5),
                                const Color.fromRGBO(41, 199, 184, 1)
                                    .withOpacity(pagina != 2
                                        ? 1
                                        : checkCvv(valorTres)
                                            ? 1
                                            : .5)
                              ]),
                              borderRadius:
                                  BorderRadius.circular(send ? 100 : 10)),
                          duration: const Duration(milliseconds: 400),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: send
                                ? SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white))
                                : Center(
                                    child: Text(
                                      pagina == 2 && checkCvv(valorTres)
                                          ? 'Guardar'
                                          : 'Siguiente',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          )),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool checkDate(String valor) {
    RegExp exp = RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$");

    if (exp.hasMatch(valor)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkCvv(String valor) {
    RegExp exp = RegExp(r"^[0-9]{3,4}$");

    if (exp.hasMatch(valor)) {
      return true;
    } else {
      return false;
    }
  }

  int checkBrand(String valor) {
    final String nuevoValor = valor.replaceAll(" ", "");

    RegExp visaExp = RegExp(
      r"^4[0-9]{6,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp masterCardExp = RegExp(
      r"^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp americanExp = RegExp(
      r"^3[47][0-9]{5,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp discoveryExp = RegExp(
      r"^6(?:011|5[0-9]{2})[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    if (visaExp.hasMatch(nuevoValor)) {
      return 1;
    }

    if (masterCardExp.hasMatch(nuevoValor)) {
      return 2;
    }

    if (americanExp.hasMatch(nuevoValor)) {
      return 3;
    }

    if (discoveryExp.hasMatch(nuevoValor)) {
      return 4;
    }

    return 0;
  }

  bool checkBrandExist(String valor) {
    final String nuevoValor = valor.replaceAll(" ", "");

    RegExp visaExp = RegExp(
      r"^4[0-9]{6,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp masterCardExp = RegExp(
      r"^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp americanExp = RegExp(
      r"^3[47][0-9]{5,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp discoveryExp = RegExp(
      r"^6(?:011|5[0-9]{2})[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    if (visaExp.hasMatch(nuevoValor) ||
        masterCardExp.hasMatch(nuevoValor) ||
        americanExp.hasMatch(nuevoValor) ||
        discoveryExp.hasMatch(nuevoValor)) {
      return true;
    } else {
      return false;
    }
  }
}
