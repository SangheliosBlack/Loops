import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuInferior extends StatelessWidget {
  const MenuInferior({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final generalActions = Provider.of<GeneralActions>(context);
    final authService = Provider.of<AuthService>(context);
    return SizedBox(
      height: 90,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (valor) {
          generalActions.controllerNavigate(valor);
        },
        currentIndex: generalActions.paginaActual,
        elevation: 0,
        unselectedIconTheme: IconThemeData(color: Colors.black.withOpacity(.8)),
        type: BottomNavigationBarType.fixed,
        fixedColor: const Color.fromRGBO(41, 199, 184, 1),
        selectedIconTheme:
            const IconThemeData(color: Color.fromRGBO(41, 199, 184, 1)),
        items: authService.usuario.socio
            ? listaSocio(context)
            : listaUsuario(context),
      ),
    );
  }

  List<BottomNavigationBarItem> listaUsuario(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return [
      const BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          size: 30,
        ),
        icon: Icon(
          Icons.home_outlined,
          size: 30,
        ),
        label: 'Calls',
      ),
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 30,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: authService.totalPiezas() > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(41, 199, 184, 1),
                        shape: BoxShape.circle),
                  ),
                ),
              )
            ],
          ),
        ),
        icon: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 30,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: authService.totalPiezas() > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(41, 199, 184, 1),
                        shape: BoxShape.circle),
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

  List<BottomNavigationBarItem> listaSocio(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return [
      const BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          size: 30,
        ),
        icon: Icon(
          Icons.home_outlined,
          size: 30,
        ),
        label: 'Calls',
      ),
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 30,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: authService.totalPiezas() > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(41, 199, 184, 1),
                        shape: BoxShape.circle),
                  ),
                ),
              )
            ],
          ),
        ),
        icon: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 30,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: authService.totalPiezas() > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(41, 199, 184, 1),
                        shape: BoxShape.circle),
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
      BottomNavigationBarItem(
        activeIcon: SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.store,
                size: 30,
              ),
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
              Icon(
                Icons.store_outlined,
                size: 30,
              ),

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
