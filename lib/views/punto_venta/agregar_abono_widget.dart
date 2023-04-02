import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/views/punto_venta/pedido_detalles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/abono.dart';

class AgregarAbonoWidget extends StatefulWidget {
  const AgregarAbonoWidget({Key? key, required this.pedido}) : super(key: key);

  final PedidoProducto pedido;

  @override
  State<AgregarAbonoWidget> createState() => _AgregarAbonoWidgetState();
}

class _AgregarAbonoWidgetState extends State<AgregarAbonoWidget> {
  final controller = TextEditingController();
  final controller2 = TextEditingController();

  String valorNuevoAbono = '0';

  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothProvider>(context);
    final socioService = Provider.of<SocioService>(context);
    return Container(
      height: 370,
      margin: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('Agregar abono',
                style:
                    GoogleFonts.quicksand(color: Colors.black, fontSize: 35)),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'RESTANTE :    ',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 25),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Text(
                          '\$ ${(widget.pedido.total - calcularAbonos(abonos: widget.pedido.abonos)).toStringAsFixed(2)}',
                          style: GoogleFonts.quicksand(
                              fontSize: 25, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'RECIBI :    ',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 25),
                      ),
                      SizedBox(
                        width: 130,
                        child: TextFormField(
                          enableSuggestions: false,
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              locale: 'ko',
                              decimalDigits: 2,
                              symbol: '\$ ',
                            ),
                          ],
                          textAlign: TextAlign.right,
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10)),
                          style: GoogleFonts.quicksand(
                              color: Colors.blueGrey, fontSize: 25),
                          onChanged: (valor1) {
                            String valor = valor1.substring(1);
                            valor.trim();
                            final valor2 = valor.replaceAll(',', '');
                            if (num.parse(valor2) >=
                                (widget.pedido.total -
                                    calcularAbonos(
                                        abonos: widget.pedido.abonos))) {
                              setState(() {
                                if (mounted) {
                                  valorNuevoAbono = valor2;
                                }
                              });
                            } else {
                              setState(() {
                                if (mounted) {
                                  valorNuevoAbono = '0';
                                }
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'ABONO :    ',
                            style: GoogleFonts.quicksand(
                                color: Colors.black.withOpacity(.8),
                                fontSize: 25),
                          ),
                          SizedBox(
                            width: 130,
                            child: TextFormField(
                              enableSuggestions: false,
                              inputFormatters: [
                                CurrencyTextInputFormatter(
                                  locale: 'ko',
                                  decimalDigits: 2,
                                  symbol: '\$ ',
                                ),
                              ],
                              textAlign: TextAlign.right,
                              controller: controller2,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10)),
                              style: GoogleFonts.quicksand(
                                  color: Colors.blueGrey, fontSize: 25),
                              onFieldSubmitted: (valor1) async {
                                String valor = valor1.substring(1);
                                valor.trim();
                                if (num.parse(valor) >
                                    widget.pedido.total -
                                        calcularAbonos(
                                            abonos: widget.pedido.abonos)) {
                                  final snackBar = SnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    content: Text(
                                      'Accion incorrecta',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ),
                    )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'CAMBIO :    ',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 25),
                      ),
                      Builder(builder: (context) {
                        String abono = controller2.text.replaceAll('\$', '');
                        abono = abono.replaceAll(' ', '');
                        abono = abono.replaceAll(',', '');
                        if (abono.isEmpty) {
                          abono = '0.0';
                        }
                        return Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Text(
                            '\$  ${valorNuevoAbono == "0" ? 0.toStringAsFixed(2) : (num.parse(valorNuevoAbono) - num.parse(abono)).toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.quicksand(
                                fontSize: 25, color: Colors.blueGrey),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  String abono = controller2.text.replaceAll('\$', '');
                  abono = abono.replaceAll(' ', '');
                  abono = abono.replaceAll(',', '');
                  if (abono.isEmpty) {
                    abono = '0.0';
                  }
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (num.parse(abono) <=
                                (widget.pedido.total -
                                    num.parse(calcularAbonos(
                                            abonos: widget.pedido.abonos)
                                        .toString())) &&
                            abono != '0.0'
                        ? () async {
                            mostrarCarga(context);
                            await socioService.recalcularAbonos(
                                cantidad: abono,
                                ventaId: widget.pedido.idVenta,
                                liquidado: num.parse(abono) >=
                                    (widget.pedido.total -
                                        calcularAbonos(
                                            abonos: widget.pedido.abonos)));
                            FocusManager.instance.primaryFocus?.unfocus();

                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            if (bluetoothService.isConnected) {
                              starPrint(
                                  newDate: true,
                                  entregado: valorNuevoAbono,
                                  abono: abono,
                                  bluetoothProvider: bluetoothService,
                                  producto: widget.pedido,
                                  context: context,
                                  tiendaRopa: true);
                            } else {
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.black,
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.print_disabled,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Impresora no conectada',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null),
                    child: Builder(builder: (context) {
                      String abono = controller2.text.replaceAll('\$', '');
                      abono = abono.replaceAll(' ', '');
                      abono = abono.replaceAll(',', '');
                      if (abono.isEmpty) {
                        abono = '0.0';
                      }
                      return Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  (num.parse(abono) <=
                                          (widget.pedido.total -
                                              num.parse(calcularAbonos(
                                                      abonos:
                                                          widget.pedido.abonos)
                                                  .toString()))
                                      ? 1
                                      : .1)),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              (num.parse(abono) <=
                                      (widget.pedido.total -
                                          num.parse(calcularAbonos(
                                                  abonos: widget.pedido.abonos)
                                              .toString()))
                                  ? 'Agregar'
                                  : 'Agregar y liquidar'),
                              style: GoogleFonts.quicksand(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ));
                    }),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  num calcularAbonos({required List<Abono> abonos}) {
    var valores = abonos.fold<num>(
        0, (previousValue, element) => previousValue + element.cantidad);
    return valores;
  }
}
