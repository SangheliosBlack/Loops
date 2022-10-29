import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/eleccion_model.dart';
import 'package:delivery/models/estado_pedido_avanzado.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import 'package:pinput/pinput.dart';

class PedidoView extends StatelessWidget {
  final Venta venta;

  const PedidoView({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMEEEEd('es-MX')
        .add_jm()
        .format(venta.createdAt.toLocal());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Regresar',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 17),
        ),
        toolbarHeight: 65,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 25),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 60,
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: venta.pedidos[index].imagen,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(.15),
                                                BlendMode.color,
                                              ),
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) => Container(
                                        padding: const EdgeInsets.all(100),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.black,
                                        )),
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    }),
                              ),
                            );
                          },
                          itemCount: venta.pedidos.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 10,
                            );
                          })),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: GoogleFonts.quicksand(fontSize: 15),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$ ' + venta.total.toStringAsFixed(2),
                                      style: GoogleFonts.quicksand(
                                        fontSize: 25,
                                        color: Colors.black.withOpacity(.8),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 27),
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
                                            color: Colors.black.withOpacity(.8),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 0),
                                            decoration: BoxDecoration(
                                                color: venta
                                                            .metodoPago!
                                                            .charges
                                                            .data[0]
                                                            .paymentMethodDetails
                                                            .card
                                                            .brand ==
                                                        'visa'
                                                    ? const Color.fromRGBO(
                                                        232, 241, 254, 1)
                                                    : const Color.fromRGBO(
                                                        251, 231, 220, 1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
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
                                                  style: GoogleFonts.quicksand(
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
                            color: Colors.black.withOpacity(.8), fontSize: 35),
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            fontSize: 18, color: Colors.blue),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: const Color.fromRGBO(41, 199, 184, 1)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EstadoWidget extends StatelessWidget {
  final PedidoProducto pedido;
  const EstadoWidget({Key? key, required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextEditingController controller = TextEditingController();
    controller.text = pedido.codigoCliente;
    var listado = calcularListado(pedido: pedido);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey.withOpacity(.1))),
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
                      _InnerTimeline2(sub: listado[index].sub)
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
              connectorBuilder: (_, index, ___) => SolidLineConnector(
                  color: listado[index].complete
                      ? const Color.fromRGBO(41, 199, 184, 1)
                      : const Color.fromRGBO(41, 199, 184, .1)),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Repartidor',
                style: GoogleFonts.quicksand(fontSize: 45),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      pedido.repartidor.nombre.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          pedido.repartidor.profilePhotoKey ??
                                              '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(.15),
                                                  BlendMode.color,
                                                ),
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) => Container(
                                          padding: const EdgeInsets.all(100),
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
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Center(child: Icon(Icons.face))),
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
                                pedido.repartidor.nombre.isNotEmpty
                                    ? pedido.repartidor.nombre
                                    : 'Pendiente',
                                style: GoogleFonts.quicksand(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                          pedido.repartidor.nombre.isNotEmpty
                              ? Row(
                                  children: [
                                    Text(
                                      pedido.repartidor.nombre.isNotEmpty
                                          ? pedido.repartidor.dialCode
                                          : 'Pendiente',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      pedido.repartidor.nombre.isNotEmpty
                                          ? pedido.repartidor.numeroCelular
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
                  pedido.repartidor.numeroCelular.isNotEmpty
                      ? GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var number = pedido.repartidor.numeroCelular;
                            FlutterPhoneDirectCaller.callNumber(number)
                                .then((value) {
                              if (value == null || value == false) {
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
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.blue)),
                            child: Text(
                              'Llamar',
                              style: GoogleFonts.quicksand(color: Colors.blue),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Instrucciones de Entrega',
                style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(.8), fontSize: 35),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          pedido.direccionCliente.titulo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        ),
                      ),
                    ],
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Para poder recibir tu pedido debes facilitar el siguiente codigo al rapartidor para poder recibirlo, en caso de no brindarlo, el repartidor no podra hacer entrega del mismo',
                    style: GoogleFonts.quicksand(color: Colors.grey),
                  ),
                  Text(
                    'Tu codigo es :',
                    style: GoogleFonts.quicksand(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Pinput(
                    enabled: false,
                    controller: controller,
                    readOnly: true,
                    defaultPinTheme: PinTheme(
                        width: width / 4,
                        height: (width / 4) - 20,
                        textStyle: GoogleFonts.quicksand(
                            color: const Color.fromRGBO(41, 199, 184, 1),
                            fontSize: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromRGBO(41, 199, 184, .1))),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Detalles',
                style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(.8), fontSize: 35),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
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
                  'C',
                  style: GoogleFonts.quicksand(color: Colors.black),
                ),
                const SizedBox(
                  width: 26,
                ),
              ],
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: Colors.grey.withOpacity(.1))),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => ItemPedidoWidget(
              producto: pedido.productos[index],
            ),
            itemCount: pedido.productos.length,
            separatorBuilder: (BuildContext context, int index) => Container(
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
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                '* Cargos extra',
                style: GoogleFonts.quicksand(color: Colors.blue),
              ),
            ),
          ],
        )
      ],
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
                  : DateTime(0000, 0, 0, 0, 0)),
          Sub(
              estado: pedido.entregadoRepartidor,
              titulo: 'Repartidor en domicilio',
              time: pedido.entregadoRepartidor
                  ? pedido.entregadoRepartidorTiempo
                  : DateTime(0000, 0, 0, 0, 0))
        ],
        complete: pedido.entregadoRepartidor));

    listado.add(EstadoPedidoAvanzado(
        titulo: 'Cliente',
        sub: [
          Sub(
              estado: pedido.entregadoRepartidor,
              titulo: 'Entregado al cliente',
              time: pedido.entregadoRepartidor
                  ? pedido.entregadoRepartidorTiempo
                  : DateTime(0000, 0, 0, 0, 0)),
          Sub(
              estado: pedido.entregadoRepartidor,
              titulo: 'Repartidor calificado',
              time: pedido.entregadoRepartidor
                  ? pedido.entregadoRepartidorTiempo
                  : DateTime(0000, 0, 0, 0, 0))
        ],
        complete: pedido.entregadoRepartidor));

    return listado;
  }
}

class ItemPedidoWidget extends StatelessWidget {
  final Producto producto;

  const ItemPedidoWidget({
    Key? key,
    required this.producto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '- ${producto.nombre}',
                overflow: TextOverflow.visible,
                style: GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${producto.precio.toStringAsFixed(2)}',
                    style: GoogleFonts.quicksand(
                        color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        producto.cantidad.toString(),
                        style: GoogleFonts.quicksand(
                            color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 15),
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    elecciones(producto: producto)[index].titulo,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.5), fontSize: 15),
                  ),
                ),
                SizedBox(
                  child: Text(
                    elecciones(producto: producto)[index].valor
                        ? '+ \$ ${elecciones(producto: producto)[index].precio.toStringAsFixed(2)}'
                        : '',
                    style: GoogleFonts.quicksand(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      elecciones(producto: producto)[index].valor
                          ? producto.cantidad.toString()
                          : '',
                      style: GoogleFonts.quicksand(
                          color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: elecciones(producto: producto).length,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 3,
            );
          },
        ),
      ],
    );
  }

  List<EleccionModel> elecciones({required Producto producto}) {
    List<EleccionModel> listado = [];

    for (var i = 0; i < producto.opciones.length; i++) {
      try {
        var contador = 0;
        for (var element in producto.opciones[i].listado) {
          if (element.activo) {
            contador++;
            var eleccion = EleccionModel(
                titulo: element.tipo,
                precio: element.precio,
                valor: element.fijo || contador > producto.opciones[i].minimo
                    ? true
                    : false);
            listado.insert(0, eleccion);
          }
        }

        // ignore: empty_catches
      } catch (e) {}
    }

    listado.sort(((a, b) {
      if (b.valor) {
        return 1;
      }
      return -1;
    }));

    return listado;
  }
}

class _InnerTimeline2 extends StatelessWidget {
  const _InnerTimeline2({
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
