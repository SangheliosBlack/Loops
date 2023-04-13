import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/views/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  const DrawerCustom({Key? key}) : super(key: key);

  @override
  DrawerCustomState createState() => DrawerCustomState();
}

class DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: const SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(
                            image: AssetImage('assets/images/loops.jpg')),
                      ),
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
                      margin: const EdgeInsets.only(top: 25),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(.1)),
                        borderRadius: BorderRadius.circular(20),
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
                            index != 2
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
      ),
    );
  }

  Widget itemSettings(
      {required int index,
      required BuildContext context,
      required String titulo,
      required IconData icono,
      required String ruta}) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (ruta == "logout") {
          navigationService.navigateTo('/');
          Navigator.pop(context);
          Navigator.pop(context);
          socketService.disconnect();
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(1),
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
