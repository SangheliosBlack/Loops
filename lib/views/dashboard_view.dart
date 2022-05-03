import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/notificaciones_view.dart';
import 'package:delivery/views/orden_view.dart';
import 'package:delivery/views/socio/socio_dashboard_view.dart';
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
    final authService = Provider.of<AuthService>(context);

    final nombre = authService.usuario.nombre.split(' ');
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              toolbarHeight: 75,
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
                                builder: (context) =>
                                    const NotificacionesView()),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromRGBO(41, 199, 184, .03)),
                          child: const Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: Color.fromRGBO(41, 199, 184, 1),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            right: 15, bottom: 0, left: 10),
                        width: 55,
                        height: 55,
                        child: Hero(
                          tag: 'perfil123',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const Image(
                                image: AssetImage('assets/images/peeps.png')),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              leadingWidth: 190,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leading: null,
              title: GestureDetector(
                  behavior: HitTestBehavior.translucent,
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
                            ),
                            const Icon(
                              Icons.expand_more,
                              color: Colors.black,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              backgroundColor: Colors.white,
              elevation: 0),
          bottomNavigationBar: const MenuInferior(),
          backgroundColor: Colors.white,
          body: PageView(
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
      ),
    );
  }
}

class DashBoardMainView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AnimatedSize(
        duration: const Duration(seconds: 1),
        child: llenarPantallasService.tiendas.isNotEmpty &&
                llenarPantallasService.categorias.isNotEmpty &&
                llenarPantallasService.productos.isNotEmpty
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                BaraBusqueda(width: width),
                const ListadoCategorias(),
                ListadoEstablecimientos(height: height, width: width),
                const ListaProductos(),
              ])
            : const LinearProgressIndicator(
                backgroundColor: Color.fromRGBO(41, 200, 182, 1),
                color: Colors.white),
      ),
    );
  }
}
