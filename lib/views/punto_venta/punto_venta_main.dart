// ignore_for_file: avoid_print

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/bluetooth_servide.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/views/punto_venta/calendario.dart';
import 'package:delivery/views/punto_venta/configuracion.dart';
import 'package:delivery/views/punto_venta/pedido_detalles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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

    socioService.obtenerPedidos(filter: '');

    pushProvider.initNotifications();

    pushProvider.mensajes.listen((event) {
      FlutterRingtonePlayer.play(
          fromAsset: "assets/sounds/sonido.mp3",
          ios: const IosSound(1023),
          asAlarm: true,
          volume: 1);

      socioService.obtenerPedidos(filter: filter);
      starPrint(
          bluetoothProvider: bluetoothProvider,
          producto: event.pedido,
          context: context);
    });
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
                      margin: const EdgeInsets.only(top: 60, bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AnimatedContainer(
                                      margin: const EdgeInsets.only(right: 5),
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: socioService.tienda.online
                                              ? const Color.fromRGBO(
                                                  41, 199, 184, 1)
                                              : Colors.red,
                                          shape: BoxShape.circle),
                                      duration:
                                          const Duration(milliseconds: 400),
                                    ),
                                    Text(
                                      socioService.tienda.online
                                          ? 'Contectado'
                                          : 'Desconectado',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.grey, fontSize: 13),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: authServiceService.puntoVentaStatus ==
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
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.withOpacity(.1)),
                              color: Colors.white,
                              shape: BoxShape.circle),
                          child: SizedBox(
                            width: 90,
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: socioService.tienda.imagenPerfil,
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
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                          color: const Color.fromRGBO(
                                              41, 199, 184, 1),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Row(
                                        children: [
                                          Text(
                                            filter == '' ? 'Hoy' : filter,
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: filter == ''
                                                ? null
                                                : () {
                                                    setState(() {
                                                      filter = '';
                                                      socioService
                                                          .eliminarData();
                                                      socioService
                                                          .obtenerPedidos(
                                                              filter: filter);
                                                    });
                                                  },
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(filter == ''
                                                          ? .2
                                                          : .5),
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _navigateAndDisplaySelection(
                                          context: context,
                                          socioService: socioService);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: const Icon(
                                          Icons.calendar_month,
                                          color: Colors.black,
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
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Fecha',
                                style:
                                    GoogleFonts.quicksand(color: Colors.black),
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
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            51, 53, 54, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : socioService.ventasCargadas &&
                                                socioService
                                                    .ventaCache.venta.isEmpty
                                            ? RefreshIndicator(
                                                triggerMode:
                                                    RefreshIndicatorTriggerMode
                                                        .anywhere,
                                                onRefresh: () async {
                                                  socioService.eliminarData();
                                                  socioService.obtenerPedidos(
                                                      filter: filter);
                                                },
                                                child: SingleChildScrollView(
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15),
                                                    width: double.infinity,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 25,
                                                            left: 25,
                                                            right: 25),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
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
                                                        socioService
                                                            .eliminarData();
                                                        socioService
                                                            .obtenerPedidos(
                                                                filter: filter);
                                                      },
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const AlwaysScrollableScrollPhysics(),
                                                        child:
                                                            ListView.separated(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        25,
                                                                    vertical:
                                                                        5),
                                                                itemCount:
                                                                    socioService
                                                                        .ventaCache
                                                                        .venta
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                separatorBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int
                                                                            index) {
                                                                  return Container(
                                                                    margin: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            4),
                                                                    child:
                                                                        Divider(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              .1),
                                                                    ),
                                                                  );
                                                                },
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return PedidoVentaWidget(
                                                                    pedido: socioService
                                                                        .ventaCache
                                                                        .venta[index],
                                                                    showActions:
                                                                        true, confirmar: true,
                                                                  );
                                                                }),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          spreadRadius: 10,
                                                          blurRadius: 12,
                                                          offset: const Offset(
                                                              0,
                                                              -1), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 25),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Ventas',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              socioService
                                                                  .ventaCache
                                                                  .size
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Pedidos completos',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              socioService
                                                                  .ventaCache
                                                                  .completados
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        15),
                                                            child: Divider(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .4),
                                                            )),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Cancelados',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                            Text(
                                                              '0',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                      color: Colors
                                                                          .black),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .2))),
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'TOTAL :',
                                                                  style: GoogleFonts.quicksand(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                    '\$ ${socioService.ventaCache.ganancia.toStringAsFixed(2)}',
                                                                    style: GoogleFonts.quicksand(
                                                                        fontSize:
                                                                            30,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(.8))),
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
                    AnimatedSize(
                      duration: const Duration(seconds: 1),
                      reverseDuration: const Duration(seconds: 1),
                      child: socioService.tienda.online == false
                          ? Container()
                          : Container(),
                    )
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: const LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      minHeight: 1,
                      color: Color.fromRGBO(41, 199, 184, 1)),
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
    socioService.obtenerPedidos(filter: filter);
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

class PedidoVentaWidget extends StatelessWidget {
  final PedidoProducto pedido;
  final bool showActions;
  final bool confirmar;

  const PedidoVentaWidget({
    Key? key,
    required this.pedido,
    required this.showActions, required this.confirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMEd('es-MX').add_jm().format(pedido.createdAt.toLocal());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetallesPedido(
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
                      '\$${pedido.total.toStringAsFixed(2)}',
                      style: GoogleFonts.quicksand(
                          fontSize: 13, color: Colors.black.withOpacity(.8)),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                      color: !pedido.confirmado
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
                              color: !pedido.confirmado
                                  ? Colors.white
                                  : Colors.black.withOpacity(.8),
                              shape: BoxShape.circle)),
                      Text(
                        calcularEstadoPedido(pedido: pedido),
                        style: GoogleFonts.quicksand(
                            fontSize: 13,
                            color: !pedido.confirmado
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

  String calcularEstadoPedido({required PedidoProducto pedido}) {
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
