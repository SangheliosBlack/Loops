import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/drawer_service.dart';
import 'package:delivery/service/hide_show_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ItemDrawer extends StatelessWidget {
  final String titulo;
  final bool active;
  final IconData icon;
  final int pagina;
  final bool isOut;
  final String to;

  const ItemDrawer({
    Key? key,
    required this.titulo,
    required this.active,
    required this.icon,
    required this.pagina,
    required this.to,
    this.isOut = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    final generalActions = Provider.of<GeneralActions>(context);
    return GestureDetector(
      onTap: () async {
        generalActions.controllerNavigate(pagina);
        await Future.delayed(const Duration(milliseconds: 210));
        drawerAction.closeDraw();
        if (isOut) {
          authProvider.logout();
        } else {}
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(active ? .1 : 0),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0),
              )
            ],
            border: active
                ? Border.all(color: Colors.grey.withOpacity(.1), width: 1)
                : Border.all(color: Colors.grey.withOpacity(0), width: 1),
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50.0)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: !isOut
                      ? active
                          ? const Color.fromRGBO(41, 199, 184, 1)
                          : Colors.white
                      : Colors.white),
              child: Icon(icon,
                  size: 20,
                  color: !isOut
                      ? active
                          ? Colors.white
                          : Colors.black
                      : Colors.black),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              titulo,
              style: GoogleFonts.raleway(
                  color: !isOut
                      ? active
                          ? Colors.black
                          : Colors.black
                      : Colors.black,
                  fontWeight: !isOut
                      ? active
                          ? FontWeight.w300
                          : FontWeight.w300
                      : FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
