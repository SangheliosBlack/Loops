import 'package:delivery/global/styles.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/drawer_service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:delivery/service/llenar_pantallas.dart';
import 'package:delivery/views/notificaciones_view.dart';
import 'package:delivery/views/orden_view.dart';
import 'package:delivery/views/socio/socio_dashboard_view.dart';
import 'package:delivery/views/ver_todo.dart';
import 'package:delivery/widgets/dot_navigation_bar_simple.dart';
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
          appBar: AppBar(
              toolbarHeight: 75,
              centerTitle: true,
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificacionesView()),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: 45,
                          height: 45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: const FadeInImage(
                              image: NetworkImage(
                                  'https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=lpDpHg2ftEMAX_zYaGt&_nc_ht=scontent.fagu2-1.fna&oh=00_AT8s9oQsw5eRABdTUwGPrG0P9sI7Yj_q-RlSRka06OV6mQ&oe=6251CB6A'),
                              fit: BoxFit.cover,
                              placeholder:
                                  AssetImage('assets/images/place_holder.gif'),
                            ),
                          ),
                        ),
                        /*Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Theme.of(context).primaryColor),
                                  child: Center(
                                    child: Text(
                                      '5',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))*/
                      ],
                    ),
                  ),
                )
              ],
              leadingWidth: 112,
              leading: GestureDetector(
                  onTap: () {
                    drawerAction.openDraw();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mi perfil',
                            style: GoogleFonts.quicksand(color: Colors.grey)),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 25),
        MenuItems(width: width),
        const ListCategory(),
        BottomWidgetMain(height: height, width: width),
        /*Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: Styles.containerCustom(),
                  child: Row(
                    children: [
                      Text(
                        'Lo mas vendido',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.expand_more_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(width: 1, color: Colors.white),
                      primary: Colors.white,
                      backgroundColor: Colors.white),
                  onPressed: () {},
                  child: Text(
                    'Ver todo',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            )),
        Container(
          margin: const EdgeInsets.only(top: 15),
          height: 210.0,
          child: llenarPantallasService.productos.isEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(left: 25, right: 12),
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      const OffertsCard2(),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(left: 25, right: 12),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      const OffertsCard(),
                ),
        ),*/
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: Styles.containerCustom(),
                  child: Row(
                    children: [
                      Text(
                        'Productos',
                        style: GoogleFonts.quicksand(
                            color: Colors.black.withOpacity(.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(width: 1, color: Colors.white),
                      primary: Colors.white,
                      backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerTodoView(
                                titulo: 'Productos',
                              )),
                    );
                  },
                  child: Text(
                    'Ver todo',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            )),
        const ListItemStore(),
      ]),
    );
  }
}
