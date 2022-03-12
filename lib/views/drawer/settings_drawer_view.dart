import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.05),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 0),
              ),
            ]),
            child: AppBar(
              toolbarHeight: 65,
              title: Text(
                'Configuracion',
                textAlign: TextAlign.start,
                style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ),
        body: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: const FadeInImage(
                    image: NetworkImage(
                        'https://delivery-bucket-app.s3.us-west-1.amazonaws.com/storage/6150f37113226b1c448c4949/profile_image_1635793018637.jpg'),
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/place_holder.gif'),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                authService.usuario.nombre,
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black.withOpacity(.7)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.1),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "EDITAR",
                  style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: const Color.fromRGBO(62, 204, 191, 1)),
                ),
              ),
              const Spacer(),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.white,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          "Cerrar sesion",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void mostrarCambioPerfil(
    BuildContext context,
  ) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const ChanceProfileImage();
      },
    );
  }
}

class ChanceProfileImage extends StatefulWidget {
  const ChanceProfileImage({Key? key}) : super(key: key);

  @override
  State<ChanceProfileImage> createState() => _ChanceProfileImageState();
}

class _ChanceProfileImageState extends State<ChanceProfileImage> {
  bool isSend = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return SimpleDialog(
      title: Text('Actualizar foto de perfil',
          style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
      children: [
        Column(
          children: [
            Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.file(
                      authService.image,
                      fit: BoxFit.cover,
                    ))),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 0),
                opacity: isSend ? 0 : 1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Colors.white),
                    onPressed: isSend
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.quicksand(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              const SizedBox(width: 5),
              AnimatedContainer(
                width: isSend ? 40 : 80,
                duration: const Duration(milliseconds: 800),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(isSend ? 100 : 10)),
                        primary: Theme.of(context).primaryColor),
                    onPressed: isSend
                        ? null
                        : () async {
                            if (mounted) {
                              isSend = true;
                              setState(() {});
                            }
                            final complete =
                                await authService.postProfileImage();
                            if (complete) {
                              Navigator.pop(context);
                            }
                          },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 0),
                      child: isSend
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator())
                          : Text(
                              'Guardar',
                              style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                    )),
              )
            ],
          ),
        )
      ],
      elevation: 10,
      //backgroundColor: Colors.green,
    );
  }
}
