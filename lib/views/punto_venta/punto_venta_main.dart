// ignore_for_file: avoid_print

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/helpers/mostrar_carga.dart';
import 'package:delivery/models/abono.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/venta_model_pro.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/search/search_prenda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/local_storage.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/service/tiendas_service.dart';
import 'package:delivery/views/extras/nuevo_producto_view.dart';
import 'package:delivery/views/extras/pedido_view.dart';
import 'package:delivery/views/punto_venta/calendario.dart';
import 'package:delivery/views/punto_venta/configuracion.dart';
import 'package:delivery/views/punto_venta/pedido_detalles.dart';
import 'package:delivery/views/punto_venta/venta_view.dart';
import 'package:delivery/views/punto_venta/ventas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'
    // ignore: library_prefixes
    as BarcodeScanner;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide Image;

class PuntoVentaMainView extends StatefulWidget {
  const PuntoVentaMainView({Key? key}) : super(key: key);

  @override
  State<PuntoVentaMainView> createState() => _PuntoVentaMainViewState();
}

class _PuntoVentaMainViewState extends State<PuntoVentaMainView> {
  @override
  void initState() {
    /***/
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((_) {
      _bluetoothScanDevicePermission(context: context).then((value) {
        final permissionService =
            Provider.of<BluetoothProvider>(context, listen: false);
        final socioService = Provider.of<SocioService>(context, listen: false);

        if (value == true && socioService.tienda.mac.isNotEmpty) {
          initPrinter(
              bluetoothProvider: permissionService, socioService: socioService);
        } else {}
      });
    });

    /***/

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('conectar-negocio', (data) => print(data));

    final pushProvider = PushNotificationProvider();
    final socioService = Provider.of<SocioService>(context, listen: false);
    final bluetoothProvider =
        Provider.of<BluetoothProvider>(context, listen: false);

    socioService.obtenerPedidos(
        filter: '',
        token: LocalStorage.prefs.getString('token2') ?? '',
        tiendaRopa: false);

    // pushProvider.initNotifications();

    // pushProvider.mensajes.listen((event) {
    //   FlutterRingtonePlayer.play(
    //       fromAsset: "assets/sounds/sonido.mp3",
    //       ios: const IosSound(1023),
    //       asAlarm: true,
    //       volume: 1);

    //   socioService.obtenerPedidos(
    //       filter: filter, token: LocalStorage.prefs.getString('token2') ?? '');
    //   starPrint(
    //       bluetoothProvider: bluetoothProvider,
    //       producto: event.pedido,
    //       context: context);
    // });
  }

  void initPrinter(
      {required BluetoothProvider bluetoothProvider,
      required SocioService socioService}) {
    bluetoothProvider.printerBluetoothManager
        .startScan(const Duration(seconds: 3));

    bluetoothProvider.printerBluetoothManager.scanResults.listen((event) {
      for (var element in event) {
        if (element.address == socioService.tienda.mac) {
          bluetoothProvider.printerBluetoothManager.selectPrinter(element);
          bluetoothProvider.conectarImpresora(printer: element);
        }
      }
    });
  }

  String filter = '';

  @override
  Widget build(BuildContext context) {
    final authServiceService = Provider.of<AuthService>(context);
    final bluetoothService = Provider.of<BluetoothProvider>(context);
    final generalActions = Provider.of<GeneralActions>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Builder(builder: (context) {
      final socioService = Provider.of<SocioService>(context);
      return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: socioService.loadStatus == LoadStatus.isInitialized
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: socioService.tienda.tiendaRopa ? 50 : 60,
                          bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !socioService.tienda.tiendaRopa
                                    ? Row(
                                        children: [
                                          AnimatedContainer(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color:
                                                    socioService.tienda.online
                                                        ? const Color.fromRGBO(
                                                            41, 199, 184, 1)
                                                        : Colors.red,
                                                shape: BoxShape.circle),
                                            duration: const Duration(
                                                milliseconds: 400),
                                          ),
                                          Text(
                                            socioService.tienda.online
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
                                  onTap: socioService.tienda.tiendaRopa
                                      ? null
                                      : authServiceService.puntoVentaStatus ==
                                              PuntoVenta.isAvailable
                                          ? () async {
                                              await showAlertDialog(
                                                  context,
                                                  socioService.tienda.online,
                                                  socioService);
                                            }
                                          : () {},
                                  child: Row(children: [
                                    Text(
                                      socioService.tienda.nombre,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    authServiceService.puntoVentaStatus ==
                                            PuntoVenta.isAvailable
                                        ? Icon(
                                            Icons.expand_more,
                                            color: authServiceService
                                                        .puntoVentaStatus ==
                                                    PuntoVenta.isAvailable
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        : Container(),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              if (bluetoothService.isEnabled &&
                                  bluetoothService.isGranted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ConfiguracionVentaView()),
                                );
                              } else {
                                print('sin permiso');
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                margin: const EdgeInsets.only(right: 25),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      margin: const EdgeInsets.only(right: 5),
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: bluetoothService.isConnected
                                              ? const Color.fromRGBO(
                                                  41, 199, 184, 1)
                                              : Colors.red,
                                          shape: BoxShape.circle),
                                      duration:
                                          const Duration(milliseconds: 400),
                                    ),
                                    const Icon(
                                      Icons.print,
                                      color: Colors.black,
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: !socioService.tienda.tiendaRopa
                          ? Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          AnimatedSize(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      41, 199, 184, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    filter == ''
                                                        ? 'Hoy'
                                                        : filter,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                  ),
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: filter == ''
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              filter = '';
                                                              socioService
                                                                  .eliminarData();
                                                              socioService.obtenerPedidos(
                                                                  filter:
                                                                      filter,
                                                                  token: LocalStorage
                                                                          .prefs
                                                                          .getString(
                                                                              'token2') ??
                                                                      '');
                                                            });
                                                          },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  filter == ''
                                                                      ? .2
                                                                      : .5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 18,
                                                        color: Color.fromRGBO(
                                                            41, 199, 184, 1),
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
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _navigateAndDisplaySelection(
                                                    context: context,
                                                    socioService: socioService);
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Fecha',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.black),
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
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.black),
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
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.black),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: AnimatedSize(
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
                                                              Expanded(
                                                                child:
                                                                    RefreshIndicator(
                                                                  onRefresh:
                                                                      () async {
                                                                    socioService
                                                                        .eliminarData();
                                                                    socioService.obtenerPedidos(
                                                                        filter:
                                                                            filter,
                                                                        token: LocalStorage.prefs.getString('token2') ??
                                                                            '');
                                                                  },
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    physics:
                                                                        const AlwaysScrollableScrollPhysics(),
                                                                    child: ListView.separated(
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                                                        itemCount: socioService.ventaCache.venta.length,
                                                                        shrinkWrap: true,
                                                                        separatorBuilder: (BuildContext context, int index) {
                                                                          return Container(
                                                                            margin:
                                                                                const EdgeInsets.symmetric(vertical: 4),
                                                                            child:
                                                                                Divider(
                                                                              color: Colors.grey.withOpacity(.1),
                                                                            ),
                                                                          );
                                                                        },
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return PedidoVentaWidget(
                                                                            tiendaRopa:
                                                                                false,
                                                                            pedido:
                                                                                socioService.ventaCache.venta[index],
                                                                            showActions:
                                                                                true,
                                                                            confirmar:
                                                                                true,
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.1),
                                                                      spreadRadius:
                                                                          10,
                                                                      blurRadius:
                                                                          12,
                                                                      offset: const Offset(
                                                                          0,
                                                                          -1), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        25,
                                                                    vertical:
                                                                        25),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Ventas',
                                                                          style:
                                                                              GoogleFonts.quicksand(color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          socioService
                                                                              .ventaCache
                                                                              .size
                                                                              .toString(),
                                                                          style:
                                                                              GoogleFonts.quicksand(color: Colors.black),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Pedidos completos',
                                                                          style:
                                                                              GoogleFonts.quicksand(color: Colors.black),
                                                                        ),
                                                                        Text(
                                                                          socioService
                                                                              .ventaCache
                                                                              .completados
                                                                              .toString(),
                                                                          style:
                                                                              GoogleFonts.quicksand(color: Colors.black),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10),
                                                                      width: double
                                                                          .infinity,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              7),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              25),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey.withOpacity(.2))),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text(
                                                                              'TOTAL :',
                                                                              style: GoogleFonts.quicksand(color: Colors.blueGrey, fontSize: 10),
                                                                            ),
                                                                            Text('\$ ${socioService.ventaCache.ganancia.toStringAsFixed(2)}',
                                                                                style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black.withOpacity(.8))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
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
                            )
                          //PUNTO VENTA KASS
                          : Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () async {
                                            try {
                                              final resultado =
                                                  await showSearch(
                                                      context: context,
                                                      delegate: SearchPrenda());
                                              if (!resultado!.cancelo) {
                                                calculandoAlerta(context);
                                                await authServiceService
                                                    .agregarProductoCesta(
                                                        skuOnly: true,
                                                        producto:
                                                            resultado.producto!,
                                                        cantidad: 1,
                                                        listado: [],
                                                        envio: 0);
                                                Navigator.pop(context);
                                                final snackBar = SnackBar(
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          41, 199, 184, 1),
                                                  content: Text(
                                                    '${resultado.producto!.nombre} x 1 agregado',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                //////
                                                generalActions
                                                    .controllerNavigate(0);
                                              }
                                            } catch (e) {
                                              debugPrint('Wrong');
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.blueGrey
                                                    .withOpacity(.1)),
                                            child: Row(
                                              children: const [
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   height: 50,
                                      //   width: 5,
                                      //   color: Colors.white,
                                      // ),
                                      // GestureDetector(
                                      //   behavior: HitTestBehavior.translucent,
                                      //   onTap: () {
                                      //     scanBarCode();
                                      //   },
                                      //   child: Container(
                                      //     margin:
                                      //         const EdgeInsets.only(right: 25),
                                      //     height: 50,
                                      //     padding: const EdgeInsets.symmetric(
                                      //         horizontal: 25),
                                      //     decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             const BorderRadius.only(
                                      //                 bottomRight:
                                      //                     Radius.circular(25),
                                      //                 topRight:
                                      //                     Radius.circular(25)),
                                      //         color: Colors.blueGrey
                                      //             .withOpacity(.1)),
                                      //     child: Row(
                                      //       children: const [
                                      //         Icon(
                                      //           FontAwesomeIcons.barcode,
                                      //           size: 18,
                                      //           color: Colors.grey,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 15),
                                    height: 50,
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            generalActions
                                                .controllerNavigate(0);
                                          },
                                          child: AnimatedContainer(
                                            margin: const EdgeInsets.only(
                                                right: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: generalActions
                                                            .paginaActual ==
                                                        0
                                                    ? Colors.black
                                                    : Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(.1))),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Row(
                                              children: [
                                                Text(
                                                  authServiceService.usuario
                                                      .cesta.productos.length
                                                      .toString(),
                                                  style: GoogleFonts.quicksand(
                                                      color: generalActions
                                                                  .paginaActual ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                const SizedBox(width: 5),
                                                Icon(Icons.shopping_bag,
                                                    color: generalActions
                                                                .paginaActual ==
                                                            0
                                                        ? Colors.white
                                                        : Colors.black),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Venta',
                                                  style: GoogleFonts.quicksand(
                                                      color: generalActions
                                                                  .paginaActual ==
                                                              0
                                                          ? Colors.white
                                                          : Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            generalActions
                                                .controllerNavigate(1);
                                          },
                                          child: AnimatedContainer(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: generalActions
                                                            .paginaActual ==
                                                        1
                                                    ? Colors.black
                                                    : Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(.1))),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Row(
                                              children: [
                                                Icon(Icons.trending_up,
                                                    color: generalActions
                                                                .paginaActual ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.black),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Resumen',
                                                  style: GoogleFonts.quicksand(
                                                      color: generalActions
                                                                  .paginaActual ==
                                                              1
                                                          ? Colors.white
                                                          : Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            generalActions
                                                .controllerNavigate(2);
                                          },
                                          child: AnimatedContainer(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: generalActions
                                                            .paginaActual ==
                                                        2
                                                    ? Colors.black
                                                    : Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(.1))),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Row(
                                              children: [
                                                Icon(Icons.inventory,
                                                    color: generalActions
                                                                .paginaActual ==
                                                            2
                                                        ? Colors.white
                                                        : Colors.black),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Inventario',
                                                  style: GoogleFonts.quicksand(
                                                      color: generalActions
                                                                  .paginaActual ==
                                                              2
                                                          ? Colors.white
                                                          : Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            generalActions
                                                .controllerNavigate(3);
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  generalActions.paginaActual ==
                                                          3
                                                      ? Colors.black
                                                      : Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey
                                                      .withOpacity(.1)),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.pending,
                                                    color: generalActions
                                                                .paginaActual ==
                                                            3
                                                        ? Colors.white
                                                        : Colors.black),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Apartados',
                                                  style: GoogleFonts.quicksand(
                                                      color: generalActions
                                                                  .paginaActual ==
                                                              3
                                                          ? Colors.white
                                                          : Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await scanQR(socioService, context);
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey
                                                      .withOpacity(.1)),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.qr_code_scanner),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Tickets',
                                                  style:
                                                      GoogleFonts.quicksand(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AgregarProductoView()),
                                            );
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey
                                                      .withOpacity(.1)),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.add),
                                                const SizedBox(
                                                  width: 9,
                                                ),
                                                Text(
                                                  'Nuevo producto',
                                                  style:
                                                      GoogleFonts.quicksand(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   behavior: HitTestBehavior.translucent,
                                        //   onTap: () {
                                        //     if (bluetoothService.isConnected) {
                                        //       starPrint2(
                                        //           bluetoothProvider:
                                        //               bluetoothService,
                                        //           context: context);
                                        //     } else {
                                        //       final snackBar = SnackBar(
                                        //         duration:
                                        //             const Duration(seconds: 3),
                                        //         backgroundColor: Colors.black,
                                        //         content: Row(
                                        //           children: [
                                        //             const Icon(
                                        //               Icons.print_disabled,
                                        //               color: Colors.white,
                                        //               size: 20,
                                        //             ),
                                        //             const SizedBox(
                                        //               width: 15,
                                        //             ),
                                        //             Text(
                                        //               'Impresora no conectada',
                                        //               style:
                                        //                   GoogleFonts.quicksand(
                                        //                       color:
                                        //                           Colors.white),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       );

                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(snackBar);
                                        //     }
                                        //   },
                                        //   child: Container(
                                        //     margin:
                                        //         const EdgeInsets.only(left: 15),
                                        //     padding: const EdgeInsets.symmetric(
                                        //         vertical: 5, horizontal: 15),
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(20),
                                        //       color: Colors.white,
                                        //       border: Border.all(
                                        //           width: 1,
                                        //           color: Colors.grey
                                        //               .withOpacity(.1)),
                                        //     ),
                                        //     child: Row(
                                        //       children: [
                                        //         const Icon(
                                        //             Icons.confirmation_num),
                                        //         const SizedBox(
                                        //           width: 9,
                                        //         ),
                                        //         Text(
                                        //           'Etiquetas',
                                        //           style:
                                        //               GoogleFonts.quicksand(),
                                        //         )
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: PageView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      controller: generalActions.controller2,
                                      children: const [
                                        VentaPantalla(),
                                        VentasView(),
                                        InventarioView(),
                                        ApartadosView(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: const LinearProgressIndicator(
                    color: Color.fromRGBO(41, 199, 184, 1),
                    backgroundColor: Color.fromRGBO(41, 199, 184, .1),
                  ),
                ),
        ),
      );
    });
  }

  Future<bool> _bluetoothScanDevicePermission(
      {required BuildContext context}) async {
    double width = MediaQuery.of(context).size.width;
    var instante = FlutterBlue.instance;
    await Future.delayed(const Duration(seconds: 1));

    if (!await instante.isOn) {
      final result = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                'Enciende tu bluetooth',
                style: GoogleFonts.quicksand(color: Colors.black, fontSize: 30),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: width - 100,
                    width: width,
                    margin: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.05),
                        borderRadius: BorderRadius.circular(10000)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            final status =
                                await Permission.bluetoothConnect.request();
                            final permissionService =
                                Provider.of<BluetoothProvider>(context,
                                    listen: false);

                            switch (status) {
                              case PermissionStatus.granted:
                                BluetoothEnable.enableBluetooth.then((result) {
                                  if (result == "true") {
                                    permissionService.isEnabled = true;
                                    Navigator.pop(context, true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ConfiguracionVentaView()),
                                    );
                                  } else if (result == "false") {
                                    permissionService.isEnabled = false;
                                    Navigator.pop(context, false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ConfiguracionVentaView()),
                                    );
                                  }
                                });
                                break;

                              case PermissionStatus.denied:
                              case PermissionStatus.restricted:
                              case PermissionStatus.limited:
                                permissionService.isEnabled = false;
                                break;
                              case PermissionStatus.permanentlyDenied:
                                permissionService.isEnabled = false;
                                break;
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.bluetooth,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]);
          });
      return result;
    } else {
      final status = await Permission.bluetoothScan.request();
      final permissionService =
          Provider.of<BluetoothProvider>(context, listen: false);
      permissionService.isEnabled = true;

      switch (status) {
        case PermissionStatus.granted:
          permissionService.isGranted = true;
          break;

        case PermissionStatus.denied:
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
          permissionService.isGranted = false;
          break;
        case PermissionStatus.permanentlyDenied:
          permissionService.isGranted = false;
          break;
      }

      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
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
        filter: filter, token: LocalStorage.prefs.getString('token2') ?? '');
  }

  showAlertDialog(
      BuildContext context, bool state, SocioService socioProvider) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final pushProvider = PushNotificationProvider();
    final token = await pushProvider.firebaseMessaging.getToken();
    Widget okButton = TextButton(
      child: Text(state ? 'Desconectar' : 'Conectar',
          style: GoogleFonts.quicksand(
            color: Colors.black.withOpacity(.8),
          )),
      onPressed: () async {
        if (state) {
          socketService.socket.emit('desconectar-negocio', {'token': token});
          await socioProvider.desconectarNegocio();
        } else {
          socketService.socket.emit('conectar-negocio', {'token': token});
          await socioProvider.conectarNegocio();
        }
        Navigator.pop(context);
      },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
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
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black.withOpacity(.2),
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Future<void> scanQR(SocioService socioService, BuildContext context) async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    String barcodeScanRes =
        await BarcodeScanner.FlutterBarcodeScanner.scanBarcode(
            '#3EB9B1', 'Cancelar', false, BarcodeScanner.ScanMode.QR);

    final Venta? venta = await socioService.obtenerVentaQR(qr: barcodeScanRes);
    mostrarCarga(context);
    await Future.delayed(const Duration(milliseconds: 1000));

    Navigator.pop(context);

    print(venta);

    if (venta != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetallesPedido(
                  tiendaRopa: true,
                  pedido: venta.pedidos[0],
                  showActions: true,
                  confirmar: true,
                )),
      );
    } else {}
  } catch (e) {
    print(e);
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
}

Future<void> scanBarCode() async {
  String barcodeScanRes;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    barcodeScanRes = await BarcodeScanner.FlutterBarcodeScanner.scanBarcode(
        '#3EB9B1', 'Cancelar', false, BarcodeScanner.ScanMode.QR);
    print(barcodeScanRes);
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
}

class InventarioView extends StatefulWidget {
  const InventarioView({Key? key}) : super(key: key);

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final socioService = Provider.of<SocioService>(context);
    final tiendaService = Provider.of<TiendaService>(context);
    return Column(
      children: [
        Container(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  'SKU',
                  style: GoogleFonts.quicksand(color: Colors.blueGrey),
                ),
              ),
              Expanded(
                child: Text('Nombre',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
              const SizedBox(
                width: 17,
              ),
              SizedBox(
                width: 80,
                child: Text('Cantidad',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 85,
                child: Text('Precio',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
              SizedBox(
                width: 55,
                child: Text('Talla',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: double.infinity,
          color: Colors.grey.withOpacity(.1),
          height: 1,
        ),
        Expanded(
          child: ListView.separated(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            shrinkWrap: true,
            itemBuilder: (_, int i) {
              var producto = socioService.tienda.listaProductos[i];
              String formattedDate = DateFormat.yMd('es-MX')
                  .add_jm()
                  .format(producto.fechaVenta.toLocal());
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => seleccion(producto: producto),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          producto.sku,
                          style: GoogleFonts.quicksand(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          producto.nombre,
                          style: GoogleFonts.quicksand(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      producto.apartado
                          ? SizedBox(
                              width: 17,
                              child: Icon(
                                Icons.pending,
                                color: Colors.black.withOpacity(1),
                                size: 18,
                              ),
                            )
                          : Container(
                              width: 17,
                            ),
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(producto.cantidad.toString(),
                              style: GoogleFonts.quicksand()),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text('\$ ${producto.precio.toStringAsFixed(2)}',
                            style: GoogleFonts.quicksand()),
                      ),
                      SizedBox(
                        width: 55,
                        child: Center(
                          child: Text(producto.descripcion,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: socioService.tienda.listaProductos.length,
            separatorBuilder: (_, __) => const SizedBox(
              height: 5,
            ),
          ),
        )
      ],
    );
  }

  void seleccion({required Producto producto}) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return AgregarProductoView(
              editar: true,
              nombre: producto.nombre,
              precio: producto.precio.toStringAsFixed(2),
              talla: producto.descripcion,
              cantidad: producto.cantidad.toString(),
              uid: producto.id);
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class ApartadosView extends StatefulWidget {
  const ApartadosView({Key? key}) : super(key: key);

  @override
  State<ApartadosView> createState() => _ApartadosViewState();
}

class _ApartadosViewState extends State<ApartadosView>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final socioService = Provider.of<SocioService>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Container(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text('Limite',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                child: Text('Cantidad',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
              SizedBox(
                width: 80,
                child: Text('Restante',
                    style: GoogleFonts.quicksand(color: Colors.blueGrey)),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.infinity,
            color: Colors.grey.withOpacity(.1),
            height: 1,
          ),
          Expanded(
            child: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                socioService.eliminarApartados();
                socioService.obtenerApartados();
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Builder(
                  builder: (BuildContext context) {
                    if (socioService.loadStatusApartados ==
                        LoadStatusApartados.noYet) {
                      return Column(
                        children: const [
                          LinearProgressIndicator(
                            color: Color.fromRGBO(41, 199, 184, 1),
                            backgroundColor: Color.fromRGBO(41, 199, 184, .1),
                          ),
                        ],
                      );
                    } else if (socioService.loadStatusApartados ==
                            LoadStatusApartados.isInitialized &&
                        socioService.apartados.isNotEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            PedidoProducto apartado =
                                socioService.apartados[index];

                            String formattedDate = DateFormat.yMMMEd('es-MX')
                                .format(apartado.createdAt
                                    .toLocal()
                                    .add(const Duration(days: 15)));
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetallesPedido(
                                            tiendaRopa: true,
                                            pedido: apartado,
                                            showActions: true,
                                            confirmar: true,
                                          )),
                                );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 190,
                                    child: Text(
                                      formattedDate,
                                      style: GoogleFonts.quicksand(),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                        '\$ ${apartado.total.toStringAsFixed(2)}',
                                        style: GoogleFonts.quicksand()),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                        '\$ ${(apartado.total - calcularAbonos(abonos: apartado.abonos)).toStringAsFixed(2)}',
                                        style: GoogleFonts.quicksand()),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: socioService.apartados.length,
                          separatorBuilder: (_, __) => const SizedBox(
                            height: 15,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.only(top: 35),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Text(
                              'Nada que mostrar',
                              style: GoogleFonts.quicksand(color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  num calcularAbonos({required List<Abono> abonos}) {
    print(abonos);
    var valores = abonos.fold<num>(0, (previousValue, element) {
      print(element.cantidad);
      return previousValue + element.cantidad;
    });
    return valores;
  }

  @override
  bool get wantKeepAlive => true;
}

class PedidoVentaWidget extends StatelessWidget {
  final PedidoProducto pedido;
  final bool showActions;
  final bool tiendaRopa;
  final bool confirmar;

  const PedidoVentaWidget({
    Key? key,
    required this.pedido,
    required this.showActions,
    required this.confirmar,
    this.tiendaRopa = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socioService = Provider.of<SocioService>(context);
    String formattedDate =
        DateFormat.yMEd('es-MX').add_jm().format(pedido.createdAt.toLocal());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetallesPedido(
                    tiendaRopa: false,
                    pedido: pedido,
                    showActions: showActions,
                    confirmar: confirmar,
                  )),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                formattedDate,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.quicksand(
                    fontSize: 13, color: Colors.black.withOpacity(.8)),
              ),
            ),
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: const Icon(
                          Icons.arrow_upward,
                          size: 10,
                        )),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      socioService.tienda.tiendaRopa
                          ? '\$${pedido.totalSafe.toStringAsFixed(2)}'
                          : '\$${pedido.total.toStringAsFixed(2)}',
                      style: GoogleFonts.quicksand(
                          fontSize: 13, color: Colors.black.withOpacity(.8)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                socioService.tienda.tiendaRopa
                    ? Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                            color: pedido.apartado
                                ? Colors.black.withOpacity(.8)
                                : const Color.fromRGBO(234, 234, 236, .4),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 4,
                                width: 4,
                                decoration: BoxDecoration(
                                    color: pedido.apartado
                                        ? Colors.white
                                        : Colors.black.withOpacity(.8),
                                    shape: BoxShape.circle)),
                            Text(
                              tiendaRopa
                                  ? pedido.conceptoTitulo
                                  : calcularEstadoPedido(
                                      pedido: pedido, context: context),
                              style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  color: pedido.apartado
                                      ? Colors.white
                                      : Colors.black.withOpacity(.8)),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                            color: pedido.confirmado && !pedido.entregadoCliente
                                ? const Color.fromRGBO(41, 199, 184, 1)
                                : !pedido.entregadoRepartidor
                                    ? Colors.black.withOpacity(.8)
                                    : const Color.fromRGBO(234, 234, 236, .4),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 4,
                                width: 4,
                                decoration: BoxDecoration(
                                    color: !pedido.confirmado ||
                                            !pedido.entregadoRepartidor
                                        ? Colors.white
                                        : Colors.black.withOpacity(.8),
                                    shape: BoxShape.circle)),
                            Text(
                              calcularEstadoPedido(
                                  pedido: pedido, context: context),
                              style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  color: !pedido.confirmado ||
                                          !pedido.entregadoRepartidor
                                      ? Colors.white
                                      : Colors.black.withOpacity(.8)),
                            ),
                          ],
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  String calcularPagos({required PedidoProducto pedido}) {
    if (pedido.liquidado) {
      return pedido.total.toStringAsFixed(2);
    } else {
      num valor = 0;

      for (var element in pedido.abonos) {
        print(element.fecha);
        print(pedido.createdAt);
        if (element.fecha.isAtSameMomentAs(pedido.createdAt)) {
          valor = element.cantidad;
        }
      }
      return valor.toStringAsFixed(2);
    }
  }

  num calcularAbonos({required List<Abono> abonos}) {
    var valores = abonos.fold<num>(
        0, (previousValue, element) => previousValue + element.cantidad);
    return valores;
  }

  String calcularEstadoPedido(
      {required PedidoProducto pedido, required BuildContext context}) {
    final socioService = Provider.of<SocioService>(context);

    if (socioService.tienda.tiendaRopa) {
      if (pedido.apartado) {
        return 'Apartado';
      } else {
        return 'Liquidado';
      }
    } else {
      if (!pedido.confirmado) {
        return 'Nuevo        ';
      }
      if (!pedido.entregadoRepartidor) {
        return 'Incompleto';
      } else {
        return 'Completo  ';
      }
    }
  }
}
