import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/views/punto_venta/pedido_detalles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VentaPantalla extends StatefulWidget {
  const VentaPantalla({Key? key}) : super(key: key);

  @override
  State<VentaPantalla> createState() => _VentaPantallaState();
}

class _VentaPantallaState extends State<VentaPantalla>
    with AutomaticKeepAliveClientMixin {
  final controller = TextEditingController();
  final controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final authService = Provider.of<AuthService>(context);
    final bluetoothService = Provider.of<BluetoothProvider>(context);
    final socioService = Provider.of<SocioService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Articulos',
                        style: GoogleFonts.quicksand(
                            color: Colors.black, fontSize: 35),
                      ),
                      GestureDetector(
                        onTap: () async {
                          mostrarCarga(context);
                          await authService.eliminarCesta();
                          socioService.modificarEntregadoCliente(dinero: '0');
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                'Eliminar todo',
                                style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(Icons.delete_outline),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(.2),
                    height: 2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'Cantidad',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 13),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Descripcion',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8), fontSize: 13),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimatedSize(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(seconds: 1),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) => Row(
                              children: [
                                authService.usuario.cesta.productos[index]
                                            .precio <
                                        0
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () async {
                                          if (authService.usuario.cesta
                                                  .productos[index].cantidad ==
                                              1) {
                                            mostrarCarga(context);
                                            await authService
                                                .eliminarProductoCesta(
                                                    pos: index);
                                            Navigator.pop(context);
                                            final snackBar = SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      0, 0, 0, 1),
                                              content: Text(
                                                '${authService.usuario.cesta.productos[index].nombre} eliminado',
                                                style: GoogleFonts.quicksand(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            mostrarCarga(context);
                                            await authService.actulizarCantidad(
                                                cantidad: (authService
                                                            .usuario
                                                            .cesta
                                                            .productos[index]
                                                            .cantidad -
                                                        1)
                                                    .toInt(),
                                                index: index);

                                            authService.calcularPromociones(
                                                eliminar: true,
                                                promociones: socioService
                                                    .tienda.promociones,
                                                producto: authService.usuario
                                                    .cesta.productos[index]);

                                            Navigator.pop(context);
                                          }
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: authService
                                                            .usuario
                                                            .cesta
                                                            .productos[index]
                                                            .cantidad ==
                                                        1
                                                    ? Colors.red
                                                    : Colors.blueGrey
                                                        .withOpacity(.1),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Icon(
                                              Icons.remove,
                                              color: authService
                                                          .usuario
                                                          .cesta
                                                          .productos[index]
                                                          .cantidad ==
                                                      1
                                                  ? Colors.white
                                                  : Colors.grey,
                                            )),
                                      ),
                                SizedBox(
                                  width: 50,
                                  child: Center(
                                    child: Text(
                                      authService.usuario.cesta.productos[index]
                                          .cantidad
                                          .toString(),
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black.withOpacity(.8),
                                          fontSize: 25),
                                    ),
                                  ),
                                ),
                                authService.usuario.cesta.productos[index]
                                            .precio <
                                        0
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () async {
                                          mostrarCarga(context);
                                          await authService.actulizarCantidad(
                                              cantidad: (authService
                                                          .usuario
                                                          .cesta
                                                          .productos[index]
                                                          .cantidad +
                                                      1)
                                                  .toInt(),
                                              index: index);
                                          authService.calcularPromociones(
                                              promociones: socioService
                                                  .tienda.promociones,
                                              producto: authService.usuario
                                                  .cesta.productos[index]);
                                          Navigator.pop(context);
                                        },
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey
                                                    .withOpacity(.1),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.grey,
                                            )),
                                      ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(.1))),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(.2))),
                                            child: const Icon(Icons.image)),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${authService.usuario.cesta.productos[index].nombre}  ${authService.usuario.cesta.productos[index].descripcion}',
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.quicksand(
                                                color: Colors.black
                                                    .withOpacity(.8)),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$ ${authService.usuario.cesta.productos[index].precio.toStringAsFixed(2)}',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.blueGrey,
                                              fontSize: 25),
                                        ),
                                        authService.usuario.cesta
                                                    .productos[index].precio <
                                                0
                                            ? const SizedBox(
                                                width: 35,
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                authService.usuario.cesta.productos[index]
                                            .precio <
                                        0
                                    ? Container()
                                    : GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          mostrarCarga(context);

                                          await authService
                                              .eliminarProductoCesta(
                                                  pos: index);
                                          socioService
                                              .modificarEntregadoCliente(
                                                  dinero: '0');
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: const Icon(
                                                Icons.delete_outline)))
                              ],
                            ),
                        itemCount: authService.usuario.cesta.productos.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                              height: 15,
                            )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(.2),
                    height: 2,
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL :    ',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8),
                              fontSize: 25),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: const BoxDecoration(color: Colors.black),
                          child: Text(
                            '\$ ${authService.calcularTotal().toStringAsFixed(2)}',
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
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10)),
                            style: GoogleFonts.quicksand(
                                color: Colors.blueGrey, fontSize: 25),
                            onFieldSubmitted: (valor1) async {
                              String valor = valor1.substring(1);
                              valor.trim();
                              final valor2 = valor.replaceAll(',', '');
                              if (num.parse(valor2) <
                                  authService.calcularTotal()) {
                                socioService.modificarEntregadoCliente(
                                    dinero: valor2);
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 2),
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, 1),
                                  content: Text(
                                    'Monto insuficiente',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                    ),
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                socioService.modificarEntregadoCliente(
                                    dinero: valor2);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    child: authService.usuario.cesta.apartado
                        ? SizedBox(
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
                                          socioService.entregado) {
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
                          )
                        : Container(),
                  ),
                  Builder(builder: (context) {
                    String precio = controller2.text.replaceAll('\$', '');
                    precio = precio.replaceAll(' ', '');
                    precio = precio.replaceAll(',', '');
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 0),
                      width: double.infinity,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'CAMBIO :    ',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontSize: 25),
                            ),
                            Container(
                              width: 145,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                '\$   ${authService.usuario.cesta.apartado ? socioService.entregado - (controller2.text.isEmpty ? 0.00 : num.parse(precio)) : socioService.entregado - authService.calcularTotal() > 0 ? (socioService.entregado - authService.calcularTotal()).toStringAsFixed(2) : 0}',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.quicksand(
                                    fontSize: 25, color: Colors.blueGrey),
                              ),
                            )
                          ]),
                    );
                  }),
                  GestureDetector(
                    onTap: socioService.entregado <
                                authService.calcularTotal() ||
                            authService.usuario.cesta.apartado
                        ? () {
                            authService.estadoApartado();
                            socioService.modificarEntregadoCliente(dinero: '0');
                            controller.clear();
                          }
                        : () {
                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                              content: Text(
                                'Operacion denegada',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                ),
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Radio(
                            value: true,
                            activeColor: const Color.fromRGBO(41, 199, 184, 1),
                            groupValue: authService.usuario.cesta.apartado,
                            onChanged: (value) {}),
                        Text(
                          'Sistema de apartado 15 dias',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: authService.usuario.cesta.apartado == false &&
                            socioService.entregado < authService.calcularTotal()
                        ? () {
                            displayTextInputDialog(context);
                          }
                        : authService.usuario.cesta.apartado &&
                                controller2.text.isEmpty
                            ? null
                            : authService.usuario.cesta.productos.isNotEmpty
                                ? () async {
                                    mostrarCarga(context);

                                    final data = await authService.crearPedido(
                                        abono: authService
                                                .usuario.cesta.apartado
                                            ? controller2.text
                                            : authService.usuario.cesta.total
                                                .toString(),
                                        apartado:
                                            authService.usuario.cesta.apartado,
                                        liquidado:
                                            !authService.usuario.cesta.apartado,
                                        envio: 0,
                                        direccion: Direccion(
                                            id: '',
                                            coordenadas:
                                                Coordenadas(lat: 0, lng: 0, id: 'd'),
                                            predeterminado: false,
                                            titulo: ''),
                                        customer: '',
                                        tiendaRopa: true, listadoEnviosValores: []);

                                    socioService.editarMultiplesCantidades(
                                        venta: data!);

                                    controller.clear();
                                    if (bluetoothService.isConnected) {
                                      starPrint(
                                          entregado:
                                              socioService.entregado.toString(),
                                          liquidado: !authService
                                              .usuario.cesta.apartado,
                                          abono:
                                              authService.usuario.cesta.apartado
                                                  ? controller2.text.trim()
                                                  : data.total.toString(),
                                          bluetoothProvider: bluetoothService,
                                          producto: data.pedidos[0],
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
                                    authService.estadoApartado2();
                                    socioService.modificarEntregadoCliente2(
                                        dinero: '0');
                                    Navigator.pop(context);
                                  }
                                : null,
                    child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(authService
                                        .usuario.cesta.apartado &&
                                    controller2.text.isEmpty
                                ? .1
                                : authService.usuario.cesta.productos.isNotEmpty
                                    ? 1
                                    : .1),
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            'Finalizar',
                            style: GoogleFonts.quicksand(
                                color: Colors.white, fontSize: 30),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> displayTextInputDialog(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Monto insuficiente, modifique o active el sistema de apartado',
              style: GoogleFonts.quicksand(color: Colors.black.withOpacity(.8)),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(41, 199, 184, 1)),
                onPressed: () {
                  authService.estadoApartado();
                  controller2.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  'Sistema de apartado',
                  style: GoogleFonts.quicksand(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.quicksand(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
