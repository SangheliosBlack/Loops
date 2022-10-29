import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/local_storage.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/punto_venta/calendario.dart';
import 'package:delivery/views/punto_venta/punto_venta_main.dart';
import 'package:delivery/views/socio/editar_tienda_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';

class SocioDashBoardView extends StatefulWidget {
  const SocioDashBoardView({Key? key}) : super(key: key);

  @override
  State<SocioDashBoardView> createState() => _SocioDashBoardViewState();
}

String tiendaUrl = '';

class _SocioDashBoardViewState extends State<SocioDashBoardView>
    with AutomaticKeepAliveClientMixin {
  String filter = '';

  @override
  void initState() {
    super.initState();
    final socioService = Provider.of<SocioService>(context, listen: false);

    socioService.obtenerPedidos(
        tienda: tiendaUrl,
        filter: filter,
        token: LocalStorage.prefs.getString('token2') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final _controller = WeSlideController();
    final tiendasService = Provider.of<TiendasService>(context);
    final authServiceService = Provider.of<AuthService>(context);
    super.build(context);
    final socioService = Provider.of<SocioService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: tiendasService.getTienda(tienda: tiendaUrl),
        builder: (BuildContext context, AsyncSnapshot<Tienda?> snapshot) {
          var tienda = snapshot.data;

          return Container(
            margin: EdgeInsets.only(
                top: authServiceService.puntoVentaStatus ==
                        PuntoVenta.isAvailable
                    ? 20
                    : 0),
            child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: snapshot.hasData
                    ? WeSlide(
                        parallax: true,
                        hideAppBar: true,
                        hideFooter: false,
                        backgroundColor: Colors.white,
                        panelBorderRadiusBegin: 35.0,
                        panelBorderRadiusEnd: 35.0,
                        panelMinSize: 0,
                        panelMaxSize: 270,
                        parallaxOffset: 0.3,
                        isDismissible: true,
                        appBarHeight: 60.0,
                        footerHeight: 60.0,
                        panelWidth: width,
                        controller: _controller,
                        appBar: AppBar(
                          toolbarHeight: 150,
                          automaticallyImplyLeading: false,
                          leadingWidth: 200,
                          centerTitle: false,
                          titleSpacing: 0,
                          actions: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarTiendaView(
                                              tienda: tienda!,
                                            )),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  child: const Icon(
                                    FontAwesomeIcons.gear,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ))
                          ],
                          title: Container(
                            padding: const EdgeInsets.only(left: 25),
                            child: Column(
                              children: [
                                authServiceService.puntoVentaStatus ==
                                        PuntoVenta.isAvailable
                                    ? Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: tienda!.online
                                                    ? Colors.green
                                                    : Colors.red,
                                                shape: BoxShape.circle),
                                          ),
                                          Text(
                                            tienda.online
                                                ? 'Contectado'
                                                : 'Desconectado',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          )
                                        ],
                                      )
                                    : Container(),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: authServiceService.puntoVentaStatus ==
                                          PuntoVenta.isAvailable
                                      ? () {
                                          showAlertDialog(context, true);
                                        }
                                      : () {
                                          _controller.show();
                                        },
                                  child: Row(children: [
                                    Text(
                                      tienda!.nombre,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.expand_more,
                                      color:
                                          authServiceService.puntoVentaStatus ==
                                                  PuntoVenta.isAvailable
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          leading: null,
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        body: Column(
                          children: [
                            snapshot.connectionState == ConnectionState.waiting
                                ? Column(
                                    children: const [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      LinearProgressIndicator(
                                        minHeight: 1,
                                        backgroundColor:
                                            Color.fromRGBO(234, 248, 248, 0),
                                        color: Color.fromRGBO(62, 204, 191, 1),
                                      ),
                                    ],
                                  )
                                : Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              bottom: 90, top: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 0),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AnimatedSize(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 0),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        20),
                                                                decoration: BoxDecoration(
                                                                    color: const Color
                                                                            .fromRGBO(
                                                                        41,
                                                                        199,
                                                                        184,
                                                                        1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25)),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      filter ==
                                                                              ''
                                                                          ? 'Hoy'
                                                                          : filter,
                                                                      style: GoogleFonts.quicksand(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    GestureDetector(
                                                                      behavior:
                                                                          HitTestBehavior
                                                                              .translucent,
                                                                      onTap: filter ==
                                                                              ''
                                                                          ? null
                                                                          : () {
                                                                              setState(() {
                                                                                filter = '';
                                                                                socioService.eliminarData();
                                                                                socioService.obtenerPedidos(tienda: tiendaUrl, filter: filter, token: LocalStorage.prefs.getString('token2') ?? '');
                                                                              });
                                                                            },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(3),
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.white.withOpacity(filter == ''
                                                                                ? .2
                                                                                : .5),
                                                                            borderRadius:
                                                                                BorderRadius.circular(100)),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              18,
                                                                          color: Color.fromRGBO(
                                                                              41,
                                                                              199,
                                                                              184,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                _navigateAndDisplaySelection(
                                                                    context:
                                                                        context,
                                                                    socioService:
                                                                        socioService);
                                                              },
                                                              child: Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .calendar_month,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Fecha',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  color: Colors
                                                                      .black),
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
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            const Icon(
                                                              Icons.expand_more,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 35),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Estado',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            const Icon(
                                                              Icons.expand_more,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Divider(
                                                  color: Colors.grey
                                                      .withOpacity(.1),
                                                ),
                                              ),
                                              AnimatedSize(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                child: !socioService
                                                        .ventasCargadas
                                                    ? SizedBox(
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 1,
                                                                color: Colors
                                                                    .white,
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            51,
                                                                            53,
                                                                            54,
                                                                            1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : socioService
                                                                .ventasCargadas &&
                                                            socioService
                                                                .ventaCache
                                                                .venta
                                                                .isEmpty
                                                        ? RefreshIndicator(
                                                            triggerMode:
                                                                RefreshIndicatorTriggerMode
                                                                    .anywhere,
                                                            onRefresh:
                                                                () async {
                                                              socioService
                                                                  .eliminarData();
                                                              socioService.obtenerPedidos(
                                                                  tienda:
                                                                      tiendaUrl,
                                                                  filter:
                                                                      filter,
                                                                  token: LocalStorage
                                                                          .prefs
                                                                          .getString(
                                                                              'token2') ??
                                                                      '');
                                                            },
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        15),
                                                                width: double
                                                                    .infinity,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 25,
                                                                        left:
                                                                            25,
                                                                        right:
                                                                            25),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .search_off,
                                                                      size: 65,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      'Sin resultados',
                                                                      style: GoogleFonts.quicksand(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              RefreshIndicator(
                                                                onRefresh:
                                                                    () async {
                                                                  socioService
                                                                      .eliminarData();
                                                                  socioService.obtenerPedidos(
                                                                      tienda:
                                                                          tiendaUrl,
                                                                      filter:
                                                                          filter,
                                                                      token: LocalStorage
                                                                              .prefs
                                                                              .getString('token2') ??
                                                                          '');
                                                                },
                                                                child:
                                                                    SingleChildScrollView(
                                                                  physics:
                                                                      const AlwaysScrollableScrollPhysics(),
                                                                  child: ListView
                                                                      .separated(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  25,
                                                                              vertical:
                                                                                  5),
                                                                          itemCount: socioService
                                                                              .ventaCache
                                                                              .venta
                                                                              .length,
                                                                          shrinkWrap:
                                                                              true,
                                                                          separatorBuilder: (BuildContext context,
                                                                              int
                                                                                  index) {
                                                                            return Container(
                                                                              margin: const EdgeInsets.symmetric(vertical: 4),
                                                                              child: Divider(
                                                                                color: Colors.grey.withOpacity(.1),
                                                                              ),
                                                                            );
                                                                          },
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return PedidoVentaWidget(
                                                                              pedido: socioService.ventaCache.venta[index],
                                                                              showActions: false,
                                                                              confirmar: false,
                                                                            );
                                                                          }),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        panel: Container(
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _controller.hide();
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.expand_less),
                                    Text(
                                      'Cerrar',
                                      style: GoogleFonts.quicksand(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 135,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: authServiceService
                                      .usuario.negocios.length,
                                  itemBuilder: (_, int index) {
                                    var tiendaPrev = authServiceService
                                        .usuario.negocios[index];

                                    return tiendaUrl != tiendaPrev.uid
                                        ? GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              if (mounted) {
                                                setState(() {
                                                  tiendaUrl = tiendaPrev.uid;
                                                  filter = '';
                                                  socioService.eliminarData();
                                                  socioService.obtenerPedidos(
                                                      tienda: tiendaUrl,
                                                      filter: filter,
                                                      token: LocalStorage.prefs
                                                              .getString(
                                                                  'token2') ??
                                                          '');
                                                });
                                                _controller.hide();
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  .1))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: tiendaPrev
                                                              .imagenPerfil,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    colorFilter:
                                                                        ColorFilter
                                                                            .mode(
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .15),
                                                                      BlendMode
                                                                          .color,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          100),
                                                                  child:
                                                                      const CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        1,
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return const Icon(
                                                                Icons.error);
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  tiendaPrev.nombre,
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container();
                                  },
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        panelHeader: GestureDetector(
                          onTap: () {
                            _controller.show();
                          },
                          child: Container(
                            height: 90.0,
                            color: Colors.white,
                            child: const Center(child: Text("Slide to Up ☝️")),
                          ),
                        ),
                      )
                    : Column(
                        children: const [
                          LinearProgressIndicator(
                            minHeight: 1,
                            backgroundColor: Color.fromRGBO(234, 248, 248, 0),
                            color: Color.fromRGBO(62, 204, 191, 1),
                          ),
                        ],
                      )),
          );
        },
      ),
    );
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
        tienda: tiendaUrl,
        filter: filter,
        token: LocalStorage.prefs.getString('token2') ?? '');
  }

  showAlertDialog(BuildContext context, bool state) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        state ? 'Desconectar' : 'Conectar',
        style: GoogleFonts.quicksand(color: state ? Colors.red : Colors.green),
      ),
      onPressed: () {},
    );
    Widget cancelButton = TextButton(
      child: Text(
        "Cancelar",
        style: GoogleFonts.quicksand(color: Colors.grey),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Icon(state ? Icons.cloud_off_outlined : Icons.cloud_upload_outlined,
              color: state ? Colors.red : Colors.green),
          const SizedBox(
            width: 10,
          ),
          Text(state ? 'Desconectar de la red' : 'Conectar a la red ',
              style: GoogleFonts.quicksand()),
        ],
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
