import 'package:delivery/models/estado_pedido.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/ventas_service.dart';
import 'package:delivery/views/extras/pedido_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MisPedidosView extends StatelessWidget {
  const MisPedidosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pedidosService = Provider.of<PedidosService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Mis ordenes',
          textAlign: TextAlign.start,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedSize(
        duration: const Duration(milliseconds: 800),
        child: pedidosService.listaOrdenesLocal.isEmpty
            ? FutureBuilder(
                future: pedidosService.listaOrdenes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Venta>> snapshot) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: snapshot.hasData && !snapshot.hasError
                          ? const Text('')
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                LinearProgressIndicator(
                                  minHeight: 1,
                                  backgroundColor:
                                      Color.fromRGBO(234, 248, 248, 0),
                                  color: Color.fromRGBO(62, 204, 191, 1),
                                )
                              ],
                            ));
                },
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 30),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, int index) => PedidoWidgetFold(
                    venta: pedidosService.listaOrdenesLocal[index]),
                separatorBuilder: (_, __) => Divider(
                      color: Colors.grey.withOpacity(.2),
                    ),
                itemCount: pedidosService.listaOrdenesLocal.length),
      ),
    );
  }
}

class PedidoWidgetFold extends StatelessWidget {
  final Venta venta;

  const PedidoWidgetFold({
    Key? key,
    required this.venta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMMEEEEd('es-MX').add_jm().format(venta.createdAt);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PedidoView(venta: venta)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
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
                                ),
                              ],
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
                              color: Colors.grey.withOpacity(.8), fontSize: 11),
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
                        '\$ ${venta.total.toStringAsFixed(2)}',
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
          ],
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
