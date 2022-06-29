import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socio_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PuntoVentaMainView extends StatefulWidget {
  const PuntoVentaMainView({Key? key}) : super(key: key);

  @override
  State<PuntoVentaMainView> createState() => _PuntoVentaMainViewState();
}

class _PuntoVentaMainViewState extends State<PuntoVentaMainView> {
  @override
  void initState() {
    super.initState();

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('conectar-negocio', (data) => print(data));
  }

  @override
  Widget build(BuildContext context) {
    final authServiceService = Provider.of<AuthService>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => SocioService()),
      ],
      child: Builder(builder: (context) {
        final socioService = Provider.of<SocioService>(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: socioService.loadStatus == LoadStatus.isInitialized
                  ? Container(
                      padding:
                          const EdgeInsets.only(top: 70, left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  AnimatedContainer(
                                    margin: const EdgeInsets.only(right: 5),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: socioService.tienda.online
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle),
                                    duration: const Duration(milliseconds: 400),
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
                          Container(
                            margin: const EdgeInsets.only(top: 45),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Hero(
                              tag: socioService.tienda.uid,
                              child: SizedBox(
                                width: 170,
                                height: 170,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          socioService.tienda.imagenPerfil,
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
                                      }),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: const LinearProgressIndicator(
                          minHeight: 1, color: Colors.blue),
                    )),
        );
      }),
    );
  }

  showAlertDialog(
      BuildContext context, bool state, SocioService socioProvider) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final pushProvider = PushNotificationProvider();
    final token = await pushProvider.firebaseMessaging.getToken();
    Widget okButton = TextButton(
      child: Text(
        state ? 'Desconectar' : 'Conectar',
        style: GoogleFonts.quicksand(color: state ? Colors.red : Colors.green),
      ),
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
}
