import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/ventas_service.dart';
import 'package:delivery/views/extras/pedido_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MisPedidosView extends StatefulWidget {
  const MisPedidosView({Key? key}) : super(key: key);

  @override
  State<MisPedidosView> createState() => _MisPedidosViewState();
}

class _MisPedidosViewState extends State<MisPedidosView> {
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
            : RefreshIndicator(
                strokeWidth: 3,
                onRefresh: () async {
                  pedidosService.recargarPedidos();
                },
                child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 30),
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, int index) => PedidoWidgetFold(
                        venta: pedidosService.listaOrdenesLocal[index]),
                    separatorBuilder: (_, __) => Divider(
                          color: Colors.grey.withOpacity(.2),
                        ),
                    itemCount: pedidosService.listaOrdenesLocal.length),
              ),
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
    String formattedDate = DateFormat.yMMMMEEEEd('es-MX')
        .add_jm()
        .format(venta.createdAt.toLocal());

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
                                    fontSize: 13,
                                    color:
                                        const Color.fromRGBO(41, 199, 184, 1))),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(
                                          137, 226, 137, 1)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 27),
                                  child: Text(
                                    '\$',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text('Efectivo',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 15,
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
                                              color:
                                                  Colors.black.withOpacity(1),
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
          ],
        ),
      ),
    );
  }

  
}
