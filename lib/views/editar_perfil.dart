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
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: authService.usuario.profilePhotoKey != ''
                        ? Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(.1))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: const FadeInImage(
                                image: NetworkImage(
                                    'https://scontent.fagu2-1.fna.fbcdn.net/v/t1.6435-9/176949178_2858133404453229_857333007463047365_n.jpg?_nc_cat=104&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeElgITRvUI8Cifv2j1PFGHEztI9OQNDPWLO0j05A0M9Yoq2Ymp4FtwDI5psIxxbEqnFCt1VOJJ-iJ8MAETHuS0t&_nc_ohc=G-OPgIVClf4AX9eJRQP&_nc_ht=scontent.fagu2-1.fna&oh=00_AT-x73nsClxkH8CZupgHJa3jctNM5atRrgoeBCrnbtUX1g&oe=625DA8EA'),
                                fit: BoxFit.cover,
                                placeholder: AssetImage(
                                    'assets/images/place_holder.gif'),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: const Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.white,
                            )),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: Colors.grey[100], shape: BoxShape.circle),
                      child: const Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.black,
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
                Text(
                  '+' + authService.usuario.numeroCelular,
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
