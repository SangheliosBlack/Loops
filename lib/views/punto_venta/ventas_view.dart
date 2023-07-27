import 'package:delivery/service/local_storage.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/views/punto_venta/calendario.dart';
import 'package:delivery/views/punto_venta/punto_venta_main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VentasView extends StatefulWidget {
  const VentasView({Key? key}) : super(key: key);

  @override
  State<VentasView> createState() => _VentasViewState();
}

class _VentasViewState extends State<VentasView>
    with AutomaticKeepAliveClientMixin {
  String filter = '';
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final socioService = Provider.of<SocioService>(context);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 199, 184, 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Text(
                                filter == '' ? 'Hoy' : filter,
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 12),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: filter == ''
                                    ? null
                                    : () {
                                        setState(() {
                                          filter = '';
                                          socioService.eliminarData();
                                          socioService.obtenerPedidos(
                                              tiendaRopa: true,
                                              filter: filter,
                                              token: LocalStorage.prefs
                                                      .getString('token2') ??
                                                  '');
                                        });
                                      },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(filter == '' ? .2 : .5),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Color.fromRGBO(41, 199, 184, 1),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _navigateAndDisplaySelection(
                                context: context, socioService: socioService);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Fecha',
                        style: GoogleFonts.quicksand(color: Colors.black),
                      ),
                      const Icon(
                        Icons.expand_more,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Monto',
                            style: GoogleFonts.quicksand(color: Colors.black),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      const SizedBox(width: 35),
                      Row(
                        children: [
                          Text(
                            'Estado',
                            style: GoogleFonts.quicksand(color: Colors.black),
                          ),
                          const Icon(
                            Icons.expand_more,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Divider(
                color: Colors.grey.withOpacity(.1),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 500),
                            child: !socioService.ventasCargadas
                                ? const SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: Colors.white,
                                            backgroundColor:
                                                Color.fromRGBO(51, 53, 54, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : socioService.ventasCargadas &&
                                        socioService.ventaCache.venta.isEmpty
                                    ? RefreshIndicator(
                                        triggerMode: RefreshIndicatorTriggerMode
                                            .anywhere,
                                        onRefresh: () async {
                                          socioService.eliminarData();
                                          socioService.obtenerPedidos(
                                              tiendaRopa: true,
                                              filter: filter,
                                              token: LocalStorage.prefs
                                                      .getString('token2') ??
                                                  '');
                                        },
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                top: 25, left: 25, right: 25),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.search_off,
                                                  size: 65,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Sin resultados',
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RefreshIndicator(
                                              onRefresh: () async {
                                                socioService.eliminarData();
                                                socioService.obtenerPedidos(
                                                    tiendaRopa: true,
                                                    filter: filter,
                                                    token: LocalStorage.prefs
                                                            .getString(
                                                                'token2') ??
                                                        '');
                                              },
                                              child: SingleChildScrollView(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                child: ListView.separated(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 5),
                                                    itemCount: socioService
                                                        .ventaCache
                                                        .venta
                                                        .length,
                                                    shrinkWrap: true,
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4),
                                                        child: Divider(
                                                          color: Colors.grey
                                                              .withOpacity(.1),
                                                        ),
                                                      );
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return PedidoVentaWidget(
                                                        pedido: socioService
                                                            .ventaCache
                                                            .venta[index],
                                                        showActions: true,
                                                        confirmar: true,
                                                      );
                                                    }),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 10,
                                                  blurRadius: 12,
                                                  offset: const Offset(0,
                                                      -1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 25),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 0),
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey
                                                          .withOpacity(.2))),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'TOTAL :',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                    ),
                                                    Text(
                                                        '\$ ${socioService.ventaCache.ganancia.toStringAsFixed(2)}',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontSize: 30,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .8))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _navigateAndDisplaySelection(
      {required BuildContext context,
      required SocioService socioService}) async {
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
    socioService.obtenerPedidos(
        tiendaRopa: true,
        filter: filter,
        token: LocalStorage.prefs.getString('token2') ?? '');
  }

  @override
  bool get wantKeepAlive => true;
}
