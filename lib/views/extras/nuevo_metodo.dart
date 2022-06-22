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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            title: Text(
              'Nuevo metodo',
              textAlign: TextAlign.start,
              style: GoogleFonts.quicksand(color: Colors.black, fontSize: 17),
            ),
            toolbarHeight: 65,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  child: AnimatedContainer(
                      width: double.infinity,
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: checkBrand(valorUno) != 0
                            ? checkBrand(valorUno) == 1
                                ? const Color.fromRGBO(232, 241, 254, 1)
                                : const Color.fromRGBO(251, 231, 220, 1)
                            : Colors.white,
                      ),
                      duration: const Duration(seconds: 1),
                      child: Stack(children: [
                        Positioned(
                          left: 17,
                          bottom: 70,
                          child: Text(valorUno,
                              style: GoogleFonts.inconsolata(
                                color: checkBrand(valorUno) != 0
                                    ? checkBrand(valorUno) == 1
                                        ? Colors.blue
                                        : Colors.orange
                                    : Colors.transparent,
                                fontSize: 24,
                              )),
                        ),
                        Positioned(
                          bottom: 100,
                          left: 20,
                          child: Text(
                            'NUMERO EN LA TARJETA',
                            style: GoogleFonts.quicksand(
                                fontSize: 12,
                                color: checkBrand(valorUno) != 0
                                    ? checkBrand(valorUno) == 1
                                        ? Colors.blue
                                        : Colors.orange
                                    : Colors.transparent),
                          ),
                        ),
                        Positioned(
                            right: checkBrand(valorUno) == 1 ? 20 : 15,
                            top: checkBrand(valorUno) == 1 ? -5 : 0,
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: checkBrand(valorUno) != 0
                                    ? checkBrand(valorUno) == 1
                                        ? SizedBox(
                                            width: 90,
                                            child: SvgPicture.asset(
                                              'assets/images/visa_color.svg',
                                              height: 90,
                                              width: 90,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 85,
                                            child: SvgPicture.asset(
                                              'assets/images/mc.svg',
                                              height: 85,
                                              width: 85,
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
                                      fontSize: 12,
                                      color: checkBrand(valorUno) != 0
                                          ? checkBrand(valorUno) == 1
                                              ? Colors.blue
                                              : Colors.orange
                                          : Colors.transparent),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  valorDos,
                                  style: GoogleFonts.inconsolata(
                                    color: checkBrand(valorUno) != 0
                                        ? checkBrand(valorUno) == 1
                                            ? Colors.blue
                                            : Colors.orange
                                        : Colors.transparent,
                                    fontSize: 24,
                                  ),
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
                                      fontSize: 12,
                                      color: checkBrand(valorUno) != 0
                                          ? checkBrand(valorUno) == 1
                                              ? Colors.blue
                                              : Colors.orange
                                          : Colors.transparent),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  valorTres,
                                  style: GoogleFonts.inconsolata(
                                    color: checkBrand(valorUno) != 0
                                        ? checkBrand(valorUno) == 1
                                            ? Colors.blue
                                            : Colors.orange
                                        : Colors.transparent,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ))
                      ])),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Ingresa tu tarjeta',
                style: GoogleFonts.quicksand(
                    color: const Color(0xff444752), fontSize: 22),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
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
                                      color: Colors.grey, fontSize: 15),
                                )),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                initialValue: valorUno,
                                textInputAction: TextInputAction.next,
                                enableInteractiveSelection: false,
                                maxLength: 19,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CardNumberFormatter(),
                                ],
                                onChanged: (valor) {
                                  if (mounted) {
                                    setState(() {
                                      valorUno = valor;
                                    });
                                  }
                                },
                                onEditingComplete: () {
                                  // if (cero) {
                                  //   FocusManager.instance.primaryFocus
                                  //       ?.unfocus();
                                  //   if (mounted) {
                                  //     setState(() {
                                  //       pagina = 1;
                                  //     });
                                  //   }
                                  //   controller2.animateToPage(1,
                                  //       duration:
                                  //           const Duration(milliseconds: 200),
                                  //       curve: Curves.easeOut);
                                  // }
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
                                  color: Colors.black.withOpacity(.8),
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    errorStyle: GoogleFonts.quicksand(
                                        color: Colors.red),
                                    hintStyle: GoogleFonts.quicksand(
                                        color: Colors.grey),
                                    hintText: '0000 0000 0000 0000',
                                    helperText:
                                        '16 digitos tal como aparecen en su tarjeta',
                                    helperStyle: GoogleFonts.quicksand(
                                      color: Colors.grey,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
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
                                        color: Colors.grey, fontSize: 15),
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
                                  // if (uno) {
                                  //   if (mounted) {
                                  //     setState(() {
                                  //       pagina = 2;
                                  //     });
                                  //   }
                                  //   FocusManager.instance.primaryFocus
                                  //       ?.unfocus();
                                  //   controller2.animateToPage(2,
                                  //       duration:
                                  //           const Duration(milliseconds: 200),
                                  //       curve: Curves.easeOut);
                                  // }
                                },
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: '00/00',
                                    errorStyle: GoogleFonts.quicksand(
                                        color: Colors.red),
                                    helperText:
                                        'Fecha de vencimiento tal como aparecen en su tarjeta',
                                    hintStyle: GoogleFonts.quicksand(
                                        color: Colors.grey),
                                    helperStyle: GoogleFonts.quicksand(
                                      color: Colors.grey,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
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
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text('Codigo de seguridad',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.grey, fontSize: 15))),
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
                                inputFormatters: [
                                  CreditCardCvcInputFormatter()
                                ],
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: '000',
                                    errorStyle: GoogleFonts.quicksand(
                                        color: Colors.red),
                                    helperText:
                                        'Codigo de seguridad 3-4 digitos',
                                    hintStyle: GoogleFonts.quicksand(
                                        color: Colors.grey),
                                    helperStyle: GoogleFonts.quicksand(
                                      color: Colors.grey,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.red.withOpacity(1),
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.1),
                                            width: 1))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
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
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            width: 110,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(.2)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Anterior',
                                style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Colors.grey.withOpacity(.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: pagina != 2
                            ? () async {
                                FocusManager.instance.primaryFocus?.unfocus();
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
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      send = true;
                                    });
                                    final bool tarjeta =
                                        await tarjetaService.newPaymentMethod(
                                            card: valorUno.replaceAll(" ", ""),
                                            cardExpMonth:
                                                valorDos.split('/')[0],
                                            cardExpYear: valorDos.split('/')[1],
                                            cardCvc: valorTres);
                                    if (tarjeta) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      final snackBar = SnackBar(
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.black,
                                        content: Text(
                                          'Metodo creado con exito',
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      setState(() {
                                        send = false;
                                        Navigator.pop(context);
                                        final snackBar = SnackBar(
                                          duration: const Duration(seconds: 4),
                                          backgroundColor: const Color.fromRGBO(
                                              253, 95, 122, 1),
                                          content: Text(
                                            'Error Tarjeta invalida...',
                                            style: GoogleFonts.quicksand(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      });
                                    }
                                  }
                                : null,
                        child: AnimatedContainer(
                            padding: EdgeInsets.symmetric(
                                horizontal: send ? 0 : 15, vertical: 10),
                            margin: const EdgeInsets.only(right: 25, top: 10),
                            width: send ? 45 : 110,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.black.withOpacity(.8)),
                                borderRadius:
                                    BorderRadius.circular(send ? 100 : 10)),
                            duration: const Duration(milliseconds: 400),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 100),
                              child: send
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : Center(
                                      child: Text(
                                        pagina == 2 && checkCvv(valorTres)
                                            ? 'Guardar'
                                            : 'Siguiente',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
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

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
