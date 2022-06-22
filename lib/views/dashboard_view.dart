import 'package:delivery/helpers/calculando_alerta.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/search_results.dart';
import 'package:delivery/search/search_destination.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/direcciones.service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/service/permission_status.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/views/drawer/mis_pedidos_drawer_view.dart';
import 'package:delivery/views/orden_view.dart';
import 'package:delivery/views/socio/socio_dashboard_view.dart';
import 'package:delivery/widgets/direcciones_widget.dart';
import 'package:delivery/widgets/dot_navigation_bar_simple.dart';
import 'package:delivery/widgets/drawe_custom.dart';
import 'package:delivery/widgets/main.dart';
import 'package:delivery/widgets/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final llenarPantallasService = Provider.of<LlenarPantallasService>(context);
    final generalActions = Provider.of<GeneralActions>(context);
    final direccionesService = Provider.of<DireccionesService>(context);
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final sugerencia = Provider.of<PermissionStatusProvider>(context);

    final nombre = authService.usuario.nombre.split(' ');
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              toolbarHeight: 90,
              centerTitle: false,
              actions: [
                Center(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MisPedidosView()),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromRGBO(41, 199, 184, .03)),
                          child: const Icon(
                            Icons.moped_sharp,
                            size: 20,
                            color: Color.fromRGBO(41, 199, 184, 1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               const NotificacionesView()),
                      //     );
                      //   },
                      //   child: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(100),
                      //         color: const Color.fromRGBO(41, 199, 184, .03)),
                      //     child: const Icon(
                      //       Icons.notifications_outlined,
                      //       size: 20,
                      //       color: Color.fromRGBO(41, 199, 184, 1),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 15,
                      // )
                      /*GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SeleccionarAvatarView()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 15, bottom: 0, left: 10),
                          width: 55,
                          height: 55,
                          child: Hero(
                            tag: 'perfil123',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: const AvatarWidget(small: true,),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                )
              ],
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leading: null,
              title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrawerCustom()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mi cuenta',
                            style: GoogleFonts.quicksand(
                                color: Colors.grey, fontSize: 15)),
                        Row(
                          children: [
                            Text(
                              nombre[0],
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10, left: 5),
                              child: const Icon(
                                Icons.expand_more,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer()
                          ],
                        ),
                        AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            child: direccionesService.direcciones.isNotEmpty
                                ? _direccionFavorita(
                                    direccionesService, context)
                                : GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (sugerencia.listaSugerencias.isEmpty) {
                                        calculandoAlerta(context);
                                        try {
                                          if (sugerencia
                                              .listaSugerencias.isEmpty) {
                                            await sugerencia.ubicacionActual();
                                          }
                                          final resultado = await showSearch(
                                              context: context,
                                              delegate: SearchDestination());
                                          if (resultado!.cancelo == false) {
                                            retornoBusqueda(resultado,
                                                direccionesService, context);
                                          }
                                        } catch (e) {
                                          debugPrint(
                                              'Ningun lugar seleccionado');
                                        }
                                        Navigator.pop(context);
                                      } else {
                                        try {
                                          final resultado = await showSearch(
                                              context: context,
                                              delegate: SearchDestination());
                                          if (resultado!.cancelo == false) {
                                            retornoBusqueda(resultado,
                                                direccionesService, context);
                                          }
                                        } catch (e) {
                                          debugPrint(
                                              'Ningun lugar seleccionado');
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Agregar nueva direccion',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        const Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ))
                      ],
                    ),
                  )),
              backgroundColor: Colors.white,
              elevation: .00),
          bottomNavigationBar: const MenuInferior(),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 600),
                child: socketService.serverStatus == ServerStatus.Offline
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Reconectando...',
                              style: GoogleFonts.quicksand(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (valor) {
                    generalActions.paginaActual = valor;
                  },
                  controller: generalActions.controller2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DashBoardMainView(
                        width: width,
                        height: height,
                        llenarPantallasService: llenarPantallasService),
                    const OrderView(),
                    /*const FavoritePlacesView(),*/
                    const SocioDashBoardView()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void retornoBusqueda(SearchResult result,
      DireccionesService direccionesService, BuildContext context) async {
    calculandoAlerta(context);
    await Future.delayed(const Duration(milliseconds: 1500));

    final String titulo = result.titulo;
    final double latitud = result.latitud;
    final double longitud = result.longitud;
    final String id = result.placeId;

    final nuevaDireccion = await direccionesService.agregarNuevaDireccion(
        id: id, latitud: latitud, longitud: longitud, titulo: titulo);
    if (nuevaDireccion) {
      Navigator.pop(context);
    } else {
      /**IMPLEMENTAR ALGO ERROR*/
    }
  }

  DireccionBuildWidget _direccionFavorita(
      DireccionesService direccionesService, BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return DireccionBuildWidget(
      show: true,
      direccion: direccionesService.direcciones[
          authService.usuario.cesta.direccion.titulo != ''
              ? direccionesService.direcciones.indexWhere((element) =>
                  authService.usuario.cesta.direccion.titulo == element.titulo)
              : obtenerFavorito(direccionesService.direcciones) != -1
                  ? obtenerFavorito(direccionesService.direcciones)
                  : 0],
    );
  }
}

obtenerFavorito(List<Direccion> direcciones) {
  final busqueda = direcciones.indexWhere((element) => element.predeterminado);
  return busqueda;
}

class DashBoardMainView extends StatefulWidget {
  const DashBoardMainView({
    Key? key,
    required this.width,
    required this.height,
    required this.llenarPantallasService,
  }) : super(key: key);

  final double width;
  final double height;
  final LlenarPantallasService llenarPantallasService;

  @override
  State<DashBoardMainView> createState() => _DashBoardMainViewState();
}

class _DashBoardMainViewState extends State<DashBoardMainView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AnimatedSize(
        duration: const Duration(seconds: 1),
        child: widget.llenarPantallasService.tiendas.isNotEmpty &&
                widget.llenarPantallasService.categorias.isNotEmpty &&
                widget.llenarPantallasService.productos.isNotEmpty
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BaraBusqueda(width: widget.width),
                const ListadoCategorias(),
                ListadoEstablecimientos(
                    height: widget.height, width: widget.width),
                const ListaProductos(),
              ])
            : const LinearProgressIndicator(
                minHeight: 1,
                backgroundColor: Color.fromRGBO(41, 200, 182, 1),
                color: Colors.white),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
