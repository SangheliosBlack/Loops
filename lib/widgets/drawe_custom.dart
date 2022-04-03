import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/views/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({Key? key}) : super(key: key);

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [Icon(Icons.arrow_back)],
                    ),
                  ),
                  const SizedBox(height: 50),
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
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      authService.usuario.nombre,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff444652),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Text(
                      authService.usuario.correo,
                      style: GoogleFonts.quicksand(
                          fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditarPerfil())),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text('Editar',
                          style: GoogleFonts.quicksand(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 15),
                        itemBuilder: (BuildContext context, int index) =>
                            itemSettings(
                              index: index,
                              context: context,
                              titulo: Statics.listSetting[index]['titulo'],
                              icono: Statics.listSetting[index]['icono'],
                              ruta: Statics.listSetting[index]['ruta'],
                            ),
                        separatorBuilder: (BuildContext context, int index) =>
                            index != 3
                                ? const SizedBox(height: 15)
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    width: double.infinity,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1)),
                                  ),
                        itemCount: Statics.listSetting.length),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemSettings(
      {required int index,
      required BuildContext context,
      required String titulo,
      required IconData icono,
      required String ruta}) {
    final authService = Provider.of<AuthService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (ruta == "logout") {
          navigationService.navigateTo('/');
          Navigator.pop(context);
          Navigator.pop(context);

          authService.logout();
        } else {
          navigationService.navegarDraw(ruta: ruta);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.all(7),
                child: Icon(
                  icono,
                  size: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                titulo,
                style: Styles.letterCustom(14, false, .7),
              ),
            ],
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
