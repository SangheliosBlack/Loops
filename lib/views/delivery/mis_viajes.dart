import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/views/delivery/viaje_detalles.dart';
import 'package:delivery/views/punto_venta/calendario.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MisViajesView extends StatefulWidget {
  const MisViajesView({Key? key}) : super(key: key);

  @override
  State<MisViajesView> createState() => _MisViajesViewState();
}

class _MisViajesViewState extends State<MisViajesView> {
  @override
  void initState() {
    super.initState();
    final socioService = Provider.of<SocioService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    socioService.obtenerEnvios(filter: '', repartidor: authService.usuario.uid);
  }

  String filter = '';
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socioService = Provider.of<SocioService>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(.1))),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            filter = '';
                            socioService.eliminarData();
                            socioService.obtenerEnvios(
                                filter: filter,
                                repartidor: authService.usuario.uid);
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 35,
                          decoration: BoxDecoration(
                              color: filter == ''
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(1)
                                  : Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          child: Center(
                            child: Text(
                              'Hoy',
                              style: GoogleFonts.quicksand(
                                color:
                                    filter != '' ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _navigateAndDisplaySelection(
                              context: context,
                              socioService: socioService,
                              authService: authService);
                        },
                        child: Container(
                          width: 50,
                          height: 35,
                          decoration: BoxDecoration(
                              color: filter != ''
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(1)
                                  : Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          child: Center(
                            child: Icon(
                              Icons.calendar_month,
                              color: filter == '' ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            'Historial',
            style: GoogleFonts.quicksand(color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            socioService.eliminarData();
            socioService.obtenerEnvios(
                filter: filter, repartidor: authService.usuario.uid);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Generado ${filter != '' ? filter : "Hoy"}',
                          style: GoogleFonts.quicksand(
                              color: Colors.black.withOpacity(.8)),
                        ),
                        Hero(
                          tag: 'money',
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15, top: 15),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black),
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                socioService.ventasCargadas &&
                                        socioService.ventaCache.venta.isNotEmpty
                                    ? 'MXN ${socioService.ventaCache.ganancia.toStringAsFixed(2)}'
                                    : 'MXN 0.00',
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                    child: AnimatedSize(
                        duration: const Duration(milliseconds: 600),
                        child: Builder(builder: (context) {
                          if (!socioService.ventasCargadas) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  minHeight: 1,
                                  color: Colors.transparent,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(1),
                                ),
                              ],
                            );
                          }
                          if (socioService.ventasCargadas &&
                              socioService.ventaCache.venta.isNotEmpty) {
                            return ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 25),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (_, int index) => ViajeWidget(
                                index: index,
                                pedidoProducto:
                                    socioService.ventaCache.venta[index],
                              ),
                              itemCount: socioService.ventaCache.venta.length,
                              separatorBuilder: (_, __) => const SizedBox(
                                height: 15,
                              ),
                            );
                          } else {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No hay resultados',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black.withOpacity(.8)),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                        }))),
              ],
            ),
          ),
        ));
  }

  Future<void> _navigateAndDisplaySelection(
      {required BuildContext context,
      required SocioService socioService,
      required AuthService authService}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarioWidget()),
    );

    if (result == null) return;

    if (!mounted) return;

    setState(() {
      filter = result;
    });
    socioService.eliminarData();
    socioService.obtenerEnvios(
        filter: filter, repartidor: authService.usuario.uid);
  }
}

class ViajeWidget extends StatelessWidget {
  final PedidoProducto pedidoProducto;
  final int index;
  const ViajeWidget({
    Key? key,
    required this.index,
    required this.pedidoProducto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMEd('es-MX')
        .add_jm()
        .format(pedidoProducto.createdAt.toLocal());
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViajesDetallesView(
                    index: index,
                    envio: pedidoProducto,
                  )),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(.05))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Orden No. # ${index + 1}',
                style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                formattedDate,
                style: GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: pedidoProducto.id,
                        child: pedidoProducto.entregadoCliente
                            ? Icon(Icons.verified,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(1))
                            : const Icon(Icons.verified,
                                color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        pedidoProducto.entregadoCliente
                            ? 'Completado'
                            : 'Pendiente',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.8)),
                      ),
                    ],
                  ),
                ],
              )
            ]),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        shape: BoxShape.circle),
                    child: const Icon(
                      Icons.arrow_upward,
                      size: 15,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '\$ ${pedidoProducto.envio.toStringAsFixed(2)}',
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
