import 'package:delivery/global/enviroment.dart';
import 'package:delivery/global/styles.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
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
    double height = MediaQuery.of(context).size.height;
    final authService = Provider.of<AuthService>(context);
    return Container(
      height: height - 35,
      margin: const EdgeInsets.only(top: 35),
      child: Container(
        width: 280,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigationService.navegarDraw(ruta: '/drawer/settings');
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(.2))),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: const Center(
                                child: Icon(
                              Icons.settings,
                              color: Colors.black,
                            )))),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: authService.usuario.profilePhotoKey != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: const FadeInImage(
                            image: NetworkImage(
                                'https://delivery-bucket-app.s3.us-west-1.amazonaws.com/storage/6150f37113226b1c448c4949/profile_image_1635793018637.jpg'),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/images/place_holder.gif'),
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                child: Text(
                  '@julioVM',
                  style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: const Color.fromRGBO(41, 199, 184, 1)),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: SizedBox(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 25),
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
                                          color: Colors.grey.withOpacity(.2)),
                                    ),
                          itemCount: Statics.listSetting.length),
                    )),
              ),
              Text(
                authService.usuario.uid,
                style: GoogleFonts.quicksand(
                    fontSize: 12, color: Colors.grey.withOpacity(.2)),
              ),
            ],
          ),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (ruta == "logout") {
          authService.logout();
        } else {
          navigationService.navegarDraw(ruta: ruta);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            padding: const EdgeInsets.all(7),
            child: Icon(
              icono,
              size: 22,
              color: Colors.grey.withOpacity(.7),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: Styles.letterCustom(14, true, .7),
          ),
        ],
      ),
    );
  }
}
