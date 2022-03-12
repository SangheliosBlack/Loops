import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuInferior extends StatelessWidget {
  const MenuInferior({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final generalActions = Provider.of<GeneralActions>(context);
    final authService = Provider.of<AuthService>(context);
    return Container(
      height: 80,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, -3),
        ),
      ]),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (valor) {
          generalActions.controllerNavigate(valor);
        },
        currentIndex: generalActions.paginaActual,
        elevation: 0,
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        fixedColor: const Color.fromRGBO(41, 199, 184, 1),
        selectedIconTheme:
            const IconThemeData(color: Color.fromRGBO(41, 199, 184, 1)),
        items: authService.usuario.socio ? listaSocio() : listaUsuario(),
      ),
    );
  }

  List<BottomNavigationBarItem> listaUsuario() {
    return [
      const BottomNavigationBarItem(
        activeIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Calls',
      ),
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.delivery_dining),
              Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
        icon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.delivery_dining_outlined),
              Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
        label: 'Camera',
      ),
      /*const BottomNavigationBarItem(
        activeIcon: Icon(Icons.favorite),
        icon: Icon(Icons.favorite_outline),
        label: 'Chats',
      ),*/
    ];
  }

  List<BottomNavigationBarItem> listaSocio() {
    return [
      const BottomNavigationBarItem(
        activeIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Calls',
      ),
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: const [
               Icon(Icons.delivery_dining),
              /*Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )*/
            ],
          ),
        ),
        icon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: const [
               Icon(Icons.delivery_dining_outlined),
              /*Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )*/
            ],
          ),
        ),
        label: 'Camera',
      ),
      /*const BottomNavigationBarItem(
        activeIcon: Icon(Icons.favorite),
        icon: Icon(Icons.favorite_outline),
        label: 'Chats',
      ),*/
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: const [
               Icon(Icons.store),
              /*Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )*/
            ],
          ),
        ),
        icon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: const [
               Icon(Icons.store_outlined),
              /*Positioned(
                top: -3,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(41, 200, 182, 1)),
                  child: Text(
                    '2',
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              )*/
            ],
          ),
        ),
        label: 'Camera',
      ),
    ];
  }
}
