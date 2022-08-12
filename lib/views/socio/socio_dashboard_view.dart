import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/tiendas_service.dart';
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final _controller = WeSlideController();
    final tiendasService = Provider.of<TiendasService>(context);
    final authServiceService = Provider.of<AuthService>(context);
    super.build(context);

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
                        panelMaxSize: 222,
                        parallaxOffset: 0.3,
                        isDismissible: true,
                        appBarHeight: 80.0,
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
                                  margin: const EdgeInsets.only(right: 25),
                                  child: const Icon(
                                    FontAwesomeIcons.gear,
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
                        body: snapshot.connectionState ==
                                ConnectionState.waiting
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
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 90, top: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Hero(
                                                  tag:
                                                      '${tienda.imagenPerfil}+socio',
                                                  child: SizedBox(
                                                    width: 170,
                                                    height: 170,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: tienda
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
                                              ),
                                            ],
                                          ),
                                          authServiceService.puntoVentaStatus ==
                                                  PuntoVenta.isAvailable
                                              ? Container()
                                              : SizedBox(
                                                  height: 93,
                                                  child: ListView.separated(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 10),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (BuildContext
                                                                context,
                                                            int index) =>
                                                        const MiembroEquipo(),
                                                    itemCount: 1,
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const SizedBox(
                                                      width: 5,
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 170,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Sin pedidos por ahora :(',
                                                  style: GoogleFonts.quicksand(
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 20,
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
                        panel: Container(
                          padding: const EdgeInsets.only(top: 25),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          height: 140,
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
                              Expanded(
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: authServiceService
                                      .usuario.negocios.length,
                                  itemBuilder: (_, int index) {
                                    var tiendaPrev = authServiceService
                                        .usuario.negocios[index];

                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            tiendaUrl = tiendaPrev.uid;
                                          });
                                          _controller.hide();
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(.1))),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: tiendaPrev.imagen,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                              colorFilter:
                                                                  ColorFilter
                                                                      .mode(
                                                                Colors.black
                                                                    .withOpacity(
                                                                        .15),
                                                                BlendMode.color,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(100),
                                                            child:
                                                                const CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                    errorWidget:
                                                        (context, url, error) {
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
                                    );
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

class MiembroEquipo extends StatelessWidget {
  const MiembroEquipo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(.2)),
                color: Colors.white,
                shape: BoxShape.circle),
            child: const Icon(
              Icons.add,
              color: Color.fromRGBO(62, 204, 191, 1),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Equipo',
            style: GoogleFonts.quicksand(),
          )
        ],
      ),
    );
  }
}
