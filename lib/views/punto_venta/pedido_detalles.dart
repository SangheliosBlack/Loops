// ignore_for_file: empty_catches
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/helpers/ticket.dart';
import 'package:delivery/models/estado_pedido_avanzado.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/views/extras/pedido_view.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class DetallesPedido extends StatefulWidget {
  final bool confirmar;
  final PedidoProducto pedido;
  final bool showActions;
  const DetallesPedido(
      {Key? key,
      required this.pedido,
      required this.showActions,
      required this.confirmar})
      : super(key: key);

  @override
  State<DetallesPedido> createState() => _DetallesPedidoState();
}

class _DetallesPedidoState extends State<DetallesPedido> {
  String clave = '';

  @override
  void initState() {
    super.initState();
    final socioService = Provider.of<SocioService>(context, listen: false);
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      if (!widget.pedido.confirmado && widget.confirmar) {
        await socioService.confirmacionPedido(
            id: widget.pedido.idVenta, venta: widget.pedido.id);
        final snackBar = SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.blue,
          content: Row(
            children: [
              const Icon(
                Icons.verified,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                'Pedido confirmado',
                style: GoogleFonts.quicksand(color: Colors.white),
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMEEEEd('es-MX')
        .add_jm()
        .format(widget.pedido.createdAt.toLocal());
    DateTime formattedDate2 =
        widget.pedido.createdAt.toLocal().add(const Duration(minutes: 20));

    String formattedDatex = DateFormat.jm('es-MX').format(formattedDate2);

    List<String> nombre = widget.pedido.usuario.nombre.split(' ');
    final bluetoothService = Provider.of<BluetoothProvider>(context);
    final socioService = Provider.of<SocioService>(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));

    double width = MediaQuery.of(context).size.width;

    bool _onEditing = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 113,
        leading: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Regresar',
                      style: GoogleFonts.quicksand(
                          fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Text(
                      nombre[0],
                      style: GoogleFonts.quicksand(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Fecha de inicio : $formattedDate',
                    style:
                        GoogleFonts.quicksand(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '+ \$ ${widget.pedido.total.toStringAsFixed(2)}',
                    style: GoogleFonts.quicksand(fontSize: 45),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comision x nombre',
                        style: GoogleFonts.quicksand(
                            fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '- \$ 10.52',
                        style: GoogleFonts.quicksand(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'IVA (8%)',
                  //       style: GoogleFonts.quicksand(
                  //           fontSize: 15, color: Colors.grey),
                  //     ),
                  //     Text(
                  //       '- \$ 9.35',
                  //       style: GoogleFonts.quicksand(fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 3,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'ISR (2%)',
                  //       style: GoogleFonts.quicksand(
                  //           fontSize: 15, color: Colors.grey),
                  //     ),
                  //     const SizedBox(
                  //       width: 15,
                  //     ),
                  //     Text(
                  //       '- \$ 1.23',
                  //       style: GoogleFonts.quicksand(fontSize: 18),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 3,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total depositado:',
                        style: GoogleFonts.quicksand(
                            fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '\$ 102.23',
                        style: GoogleFonts.quicksand(
                            fontSize: 18, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    widget.showActions
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (() {
                              if (bluetoothService.isConnected) {
                                starPrint(
                                    bluetoothProvider: bluetoothService,
                                    producto: widget.pedido,
                                    context: context);
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
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.blue)),
                              child: Text(
                                'Imprimir ticket',
                                style:
                                    GoogleFonts.quicksand(color: Colors.blue),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: Colors.grey.withOpacity(.2))),
                    //   child: Text(
                    //     'Imprimir comanda',
                    //     style: GoogleFonts.quicksand(),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                var listado = calcularListado(pedido: widget.pedido);
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(.1))),
                      child: FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          color: const Color(0xff989898),
                          indicatorTheme: const IndicatorThemeData(
                            position: 0,
                            size: 20.0,
                          ),
                          connectorTheme: const ConnectorThemeData(
                            thickness: 1,
                          ),
                        ),
                        builder: TimelineTileBuilder.connected(
                          connectionDirection: ConnectionDirection.before,
                          itemCount: listado.length,
                          contentsBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    listado[index].titulo,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 17,
                                        color: Colors.black.withOpacity(.8),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  _InnerTimeline(sub: listado[index].sub)
                                ],
                              ),
                            );
                          },
                          indicatorBuilder: (_, index) {
                            if (listado[index].complete) {
                              return const DotIndicator(
                                color: Color.fromRGBO(41, 199, 184, 1),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              );
                            } else {
                              return const OutlinedDotIndicator(
                                borderWidth: 1,
                                color: Color.fromRGBO(41, 199, 184, .1),
                              );
                            }
                          },
                          connectorBuilder: (_, index, ___) =>
                              SolidLineConnector(
                                  color: listado[index].complete
                                      ? const Color.fromRGBO(41, 199, 184, 1)
                                      : const Color.fromRGBO(41, 199, 184, .1)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repartidor',
                      style: GoogleFonts.quicksand(fontSize: 45),
                    ),
                    Row(
                      children: [
                        Text(
                          'Recoleccion aproximada',
                          style: GoogleFonts.quicksand(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.blue)),
                          child: Text(
                            formattedDatex,
                            style: GoogleFonts.quicksand(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            widget.pedido.repartidor.nombre.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: widget.pedido.repartidor
                                                    .profilePhotoKey ??
                                                '',
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.black
                                                            .withOpacity(.15),
                                                        BlendMode.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            placeholder: (context, url) =>
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            100),
                                                    child:
                                                        const CircularProgressIndicator(
                                                      strokeWidth: 1,
                                                      color: Colors.black,
                                                    )),
                                            errorWidget: (context, url, error) {
                                              return const Icon(Icons.error);
                                            })))
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child:
                                        const Center(child: Icon(Icons.face))),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      widget.pedido.repartidor.nombre.isNotEmpty
                                          ? widget.pedido.repartidor.nombre
                                          : 'Pendiente',
                                      style:
                                          GoogleFonts.quicksand(fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                                widget.pedido.repartidor.nombre.isNotEmpty
                                    ? Row(
                                        children: [
                                          Text(
                                            widget.pedido.repartidor.nombre
                                                    .isNotEmpty
                                                ? widget
                                                    .pedido.repartidor.dialCode
                                                : 'Pendiente',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.pedido.repartidor.nombre
                                                    .isNotEmpty
                                                ? widget.pedido.repartidor
                                                    .numeroCelular
                                                : 'Pendiente',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                        widget.pedido.repartidor.numeroCelular.isNotEmpty
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  var number =
                                      widget.pedido.repartidor.numeroCelular;
                                  FlutterPhoneDirectCaller.callNumber(number)
                                      .then((value) {
                                    try {
                                      if (value!) {
                                        final snackBar = SnackBar(
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            'Permiso denegado, caracteristica limitada.',
                                            style: GoogleFonts.quicksand(),
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } catch (e) {}
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.blue)),
                                  child: Text(
                                    'Llamar',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.blue),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.showActions
                        ? AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            child: !widget.pedido.entregadoRepartidor
                                ? Column(
                                    children: [
                                      VerificationCode(
                                          itemSize: (width - 90) / 4,
                                          underlineWidth: 1,
                                          textStyle: GoogleFonts.quicksand(
                                              fontSize: 20.0,
                                              color: const Color.fromRGBO(
                                                  41, 199, 184, 1)),
                                          keyboardType: TextInputType.number,
                                          underlineColor: Colors.blue,
                                          length: 4,
                                          cursorColor: Colors.blue,
                                          digitsOnly: true,
                                          onCompleted: (String value) async {
                                            if (value ==
                                                widget
                                                    .pedido.codigoRepartidor) {
                                              mostrarCarga(context);

                                              final estado = await socioService
                                                  .confirmarCodigoRepartidor(
                                                      idSubventa:
                                                          widget.pedido.id,
                                                      idVenta: widget
                                                          .pedido.idVenta);

                                              Navigator.pop(context);
                                              if (estado) {
                                                showModalBottomSheet(
                                                    barrierColor: Colors.black
                                                        .withOpacity(.2),
                                                    elevation: 1,
                                                    context: context,
                                                    builder: (context) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.verified,
                                                            color:
                                                                Color.fromRGBO(
                                                                    41,
                                                                    199,
                                                                    184,
                                                                    1),
                                                            size: 110,
                                                          ),
                                                          Text(
                                                            'Codigo confirmado!',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        25),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              'Entregar pedido a repartidor',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          15)),
                                                          GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .translucent,
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 25,
                                                                        left:
                                                                            25,
                                                                        right:
                                                                            25),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                .2))),
                                                                width: double
                                                                    .infinity,
                                                                child: Center(
                                                                  child: Text(
                                                                      'Continuar',
                                                                      style: GoogleFonts.quicksand(
                                                                          color:
                                                                              Colors.black)),
                                                                )),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                final snackBar = SnackBar(
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  backgroundColor: Colors.black,
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        'Error al confirmar',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            } else {
                                              final snackBar = SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor: Colors.black,
                                                content: Row(
                                                  children: [
                                                    Text(
                                                      'Codigo incorrecto',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          },
                                          onEditing: (bool value) {
                                            setState(() {
                                              _onEditing = value;
                                            });
                                            if (!_onEditing) {
                                              FocusScope.of(context).unfocus();
                                            }
                                          }),
                                      Text(
                                        '* El repartidor debe facilitar un codigo de 4 digitos para poder entregar el pedido, de lo contrario no podra seguir con el proceso.',
                                        style: GoogleFonts.quicksand(
                                            color: Colors.grey, fontSize: 13),
                                      )
                                    ],
                                  )
                                : Container(),
                          )
                        : Container()
                  ],
                ),
              ),
              Text(
                'Pedido',
                style: GoogleFonts.quicksand(fontSize: 45),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Producto',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Precio',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Cant',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 65),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(.1))),
                child: ListView.separated(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) =>
                      ItemPedidoWidget(
                    producto: widget.pedido.productos[index],
                  ),
                  itemCount: widget.pedido.productos.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(.2),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<EstadoPedidoAvanzado> calcularListado({required PedidoProducto pedido}) {
    List<EstadoPedidoAvanzado> listado = [];

    listado.add(EstadoPedidoAvanzado(
        titulo: 'Proceso de pedido',
        sub: [
          Sub(
              estado: true,
              titulo: 'Creacion del pedido',
              time: pedido.createdAt),
          Sub(
              estado: pedido.confirmado,
              titulo: 'Confirmado por ${pedido.tienda}',
              time: pedido.confirmado
                  ? pedido.confirmacionTiempo
                  : DateTime(0000, 0, 0, 0, 0))
        ],
        complete: pedido.confirmado ? true : false));

    listado.add(EstadoPedidoAvanzado(
        titulo: 'Envio',
        sub: [
          Sub(
              estado: pedido.entregadoRepartidor,
              titulo: 'Entregado al repartidor',
              time: pedido.entregadoRepartidor
                  ? pedido.entregadoRepartidorTiempo
                  : DateTime(0000, 0, 0, 0, 0))
        ],
        complete: pedido.entregadoRepartidor));

    return listado;
  }

  bool isEdgeIndex(int index) {
    return index == 0 || index == 23 + 1;
  }

  
}

Future<void> starPrint(
    {required BluetoothProvider bluetoothProvider,
    required PedidoProducto producto,
    required BuildContext context}) async {
  mostrarCarga(context);

  const PaperSize paper = PaperSize.mm58;
  final profile = await CapabilityProfile.load();

  final PosPrintResult resul = await bluetoothProvider.printerBluetoothManager
      .printTicket(await testTicket(paper, profile, producto));

  var estado = '';

  if (resul == PosPrintResult.printInProgress) {}

  switch (resul) {
    case PosPrintResult.printInProgress:
      estado = 'Impresion en progreso';
      break;
    case PosPrintResult.printerNotSelected:
      estado = 'Impresora no selecciondo';
      break;
    case PosPrintResult.scanInProgress:
      estado = 'Escaneo en progreso';
      break;
    case PosPrintResult.success:
      estado = 'Impresion realizada';
      break;
    case PosPrintResult.ticketEmpty:
      estado = 'Impresora sin papel';
      break;
    case PosPrintResult.timeout:
      estado = 'Tiempo de espera agotado';
      break;
    default:
  }

  Navigator.pop(context);

  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.black,
    content: Row(
      children: [
        Text(
          estado,
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
Future<void> starPrint2(
    {required BluetoothProvider bluetoothProvider,
    required BuildContext context}) async {
  mostrarCarga(context);

  const PaperSize paper = PaperSize.mm58;
  final profile = await CapabilityProfile.load();

  final PosPrintResult resul = await bluetoothProvider.printerBluetoothManager
      .printTicket(await testTicket2(paper, profile));

  var estado = '';

  if (resul == PosPrintResult.printInProgress) {}

  switch (resul) {
    case PosPrintResult.printInProgress:
      estado = 'Impresion en progreso';
      break;
    case PosPrintResult.printerNotSelected:
      estado = 'Impresora no selecciondo';
      break;
    case PosPrintResult.scanInProgress:
      estado = 'Escaneo en progreso';
      break;
    case PosPrintResult.success:
      estado = 'Impresion realizada';
      break;
    case PosPrintResult.ticketEmpty:
      estado = 'Impresora sin papel';
      break;
    case PosPrintResult.timeout:
      estado = 'Tiempo de espera agotado';
      break;
    default:
  }

  Navigator.pop(context);

  final snackBar = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.black,
    content: Row(
      children: [
        Text(
          estado,
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.sub,
  });

  final List<Sub> sub;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == sub.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) => !isEdgeIndex(index)
              ? Indicator.outlined(
                  borderWidth: 1.0,
                  color: sub[index - 1].estado
                      ? const Color.fromRGBO(41, 199, 184, 1)
                      : Colors.grey,
                )
              : null,
          startConnectorBuilder: (_, index) =>
              Connector.solidLine(color: Colors.grey.withOpacity(.2)),
          endConnectorBuilder: (_, index) =>
              Connector.solidLine(color: Colors.grey.withOpacity(.2)),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }
            String formattedDate =
                DateFormat.jm('es-MX').format(sub[index - 1].time.toLocal());
            var other = DateTime(0000, 0, 0, 0, 1);

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sub[index - 1].time.compareTo(other) > 0
                        ? formattedDate +
                            '   ' +
                            sub[index - 1].titulo.toString()
                        : '--:--   ' + sub[index - 1].titulo.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.quicksand(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: sub.length + 2,
        ),
      ),
    );
  }
}
