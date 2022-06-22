import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/eleccion_model.dart';
import 'package:delivery/models/estado_pedido.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PedidoView extends StatelessWidget {
  final Venta venta;

  const PedidoView({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMMEEEEd('es-MX').add_jm().format(venta.createdAt);
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
                                child: Image(
                                  image: CachedNetworkImageProvider(
                                      venta.pedidos[index].imagen),
                                  fit: BoxFit.cover,
                                ),
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
                                          fontSize: 13, color: Colors.grey)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(top: 15, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Cantidad',
                              style: GoogleFonts.quicksand(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\$ ${venta.total}',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Metodo de pago',
                              style: GoogleFonts.quicksand(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              venta.efectivo
                                  ? 'Efectivo'
                                  : '${venta.metodoPago!.charges.data[0].paymentMethodDetails.card.brand == "mastercard" ? "Mastercard" : "Visa"} ${venta.metodoPago?.charges.data[0].paymentMethodDetails.card.last4}',
                              style: GoogleFonts.quicksand(
                                  color: Colors.black.withOpacity(.8),
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Estado',
                              style: GoogleFonts.quicksand(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _checkEstadoPedido(ventas: venta.pedidos),
                              style: GoogleFonts.quicksand(
                                  color: const Color.fromRGBO(41, 199, 184, 1),
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
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
                    padding: const EdgeInsets.all(15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '\$ ${venta.total.toStringAsFixed(2)}',
                              style: GoogleFonts.quicksand(
                                  fontSize: 18, fontWeight: FontWeight.w600),
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

  String _checkEstadoPedido({required List<PedidoProducto> ventas}) {
    var estado =
        EstadoPedido(preparado: 0, enviado: 0, entregado: 0, pagado: 0);

    for (var element in ventas) {
      if (element.preparado) {
        estado.preparado++;
      }
      if (element.enviado) {
        estado.enviado++;
      }
      if (element.entregado) {
        estado.entregado++;
      }
      if (element.pagado) {
        estado.pagado++;
      }
    }

    if (estado.entregado > 0) {
      if (estado.entregado >= ventas.length) {
        return 'Entregado';
      } else {
        return 'Entregado!';
      }
    }
    if (estado.enviado > 0) {
      if (estado.enviado >= ventas.length) {
        return 'Enviado';
      } else {
        return 'Enviado!';
      }
    }
    if (estado.preparado > 0) {
      if (estado.preparado >= ventas.length) {
        return 'Preparado';
      } else {
        return 'Preparado !';
      }
    }
    if (estado.pagado > 0) {
      return 'Pagado';
    } else {
      return 'Pago pendiente';
    }
  }
}

class EstadoWidget extends StatelessWidget {
  final PedidoProducto pedido;
  const EstadoWidget({Key? key, required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(pedido.tienda,
                        style: GoogleFonts.quicksand(
                            fontSize: 18, color: Colors.black))),
                const Expanded(child: Divider()),
              ],
            )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(41, 199, 184, 1),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.attach_money,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Pagado',
                    style: GoogleFonts.quicksand(
                        fontSize: 13, color: Colors.black.withOpacity(.8)),
                  )
                ],
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 2,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(41, 199, 184, 1)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      41, 199, 184, pedido.preparado ? 1 : .1)),
                            ),
                          ),
                        ],
                      ))),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: pedido.preparado
                            ? const Color.fromRGBO(41, 199, 184, 1)
                            : Colors.grey.withOpacity(.2),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.outdoor_grill_outlined,
                      size: 18,
                      color: pedido.preparado ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Preparado',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: pedido.preparado
                          ? Colors.black.withOpacity(.8)
                          : Colors.grey,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      41, 199, 184, pedido.preparado ? 1 : 0)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      41,
                                      199,
                                      184,
                                      pedido.preparado
                                          ? pedido.enviado
                                              ? 1
                                              : .1
                                          : 0)),
                            ),
                          ),
                        ],
                      ))),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: pedido.enviado
                            ? const Color.fromRGBO(41, 199, 184, 1)
                            : Colors.grey.withOpacity(.2),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.moped_outlined,
                      size: 18,
                      color: pedido.enviado ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Enviado',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: pedido.enviado
                          ? Colors.black.withOpacity(.8)
                          : Colors.grey,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      41, 199, 184, pedido.enviado ? 1 : 0)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(
                                      41,
                                      199,
                                      184,
                                      pedido.enviado
                                          ? pedido.entregado
                                              ? 1
                                              : .1
                                          : 0)),
                            ),
                          ),
                        ],
                      ))),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: pedido.entregado
                            ? const Color.fromRGBO(41, 199, 184, 1)
                            : Colors.grey.withOpacity(.2),
                        shape: BoxShape.circle),
                    child: Icon(
                      Icons.done_all,
                      size: 18,
                      color: pedido.entregado ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text('Entregado',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: pedido.entregado
                            ? Colors.black.withOpacity(.8)
                            : Colors.grey,
                      ))
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 35,
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
                  'Cantidad',
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
        )
      ],
    );
  }

  EstadoPedido calcularEnvio({required Venta venta}) {
    return EstadoPedido(
        preparado: venta.pedidos
            .map((e) => e.preparado ? 1 : 0)
            .reduce((value, element) => value + element),
        enviado: venta.pedidos
            .map((e) => e.enviado ? 1 : 0)
            .reduce((value, element) => value + element),
        entregado: venta.pedidos
            .map((e) => e.entregado ? 1 : 0)
            .reduce((value, element) => value + element),
        pagado: venta.pedidos
            .map((e) => e.pagado ? 1 : 0)
            .reduce((value, element) => value + element));
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
            Text(
              '- ${producto.nombre}',
              style: GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  '\$ ${producto.precio.toStringAsFixed(2)}',
                  style:
                      GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(
                  width: 65,
                ),
                Text(
                  producto.cantidad.toString(),
                  style:
                      GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
                ),
              ],
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
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Text(
                  '   ${elecciones(producto: producto)[index].titulo}',
                  style: GoogleFonts.quicksand(
                      color: Colors.black.withOpacity(.5), fontSize: 15),
                ),
                const Spacer(),
                Text(
                  elecciones(producto: producto)[index].valor
                      ? '+ \$ ${elecciones(producto: producto)[index].precio.toStringAsFixed(2)}'
                      : '',
                  style: GoogleFonts.quicksand(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  width: 65,
                ),
                Text(
                  elecciones(producto: producto)[index].valor
                      ? producto.cantidad.toString()
                      : '',
                  style:
                      GoogleFonts.quicksand(color: Colors.black, fontSize: 15),
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
