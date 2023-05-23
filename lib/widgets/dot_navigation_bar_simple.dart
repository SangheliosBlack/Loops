import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      height: 80,
      child: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: generalActions.paginaActual,
        color: Theme.of(context).colorScheme.primary,
        onTap: (valor) {
          generalActions.controllerNavigate(valor);
        },
        items: authService.usuario.socio
            ? listaSocio(context)
            : listaUsuario(context),
      ),
    );
  }

  listaUsuario(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return [
      const Icon(Icons.home, size: 30, color: Colors.white),
      Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 30, color: Colors.white),
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
                    color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          )
        ],
      ),
    ];
  }

  listaSocio(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return [
      const Icon(Icons.home, size: 30, color: Colors.white),
      Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 30,
            color: Colors.white,
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
                    color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          )
        ],
      ),
      const Icon(Icons.store, size: 30, color: Colors.white)
    ];
  }
}
