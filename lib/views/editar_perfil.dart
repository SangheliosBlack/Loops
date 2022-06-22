import 'package:delivery/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../service/auth_service.dart';

class EditarPerfil extends StatelessWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Editar cuenta',
            style: GoogleFonts.quicksand(
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.blue,
                  margin: const EdgeInsets.only(right: 25),
                  child: Hero(
                    tag: 'perfil123',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: const AvatarWidget(
                            small: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: const Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Nombre',
              style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Text(
              authService.usuario.nombre,
              style: GoogleFonts.quicksand(
                  color: Colors.black.withOpacity(.8), fontSize: 18),
            ),
            const SizedBox(height: 40),
            Text(
              'Correo electronico',
              style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  authService.usuario.correo,
                  style: GoogleFonts.quicksand(
                      color: Colors.black.withOpacity(.8), fontSize: 18),
                ),
                Text(
                  'Verificado',
                  style: GoogleFonts.quicksand(
                      color: Colors.green.withOpacity(.8), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Numero de telefono',
              style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      authService.usuario.dialCode,
                      style: GoogleFonts.quicksand(
                          color: Colors.blue, fontSize: 18),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      authService.usuario.numeroCelular,
                      style: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8), fontSize: 18),
                    ),
                  ],
                ),
                Text(
                  'Verificado',
                  style: GoogleFonts.quicksand(
                      color: Colors.green.withOpacity(.8), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Contraseña',
              style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Text(
              '•••••••••••',
              style: GoogleFonts.quicksand(
                  color: Colors.black.withOpacity(.8), fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
