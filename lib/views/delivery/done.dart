import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DoneDeliveryView extends StatelessWidget {
  const DoneDeliveryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final nombre = authService.usuario.nombre.split(' ');
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: const Color.fromRGBO(41, 199, 184, 1)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(41, 199, 184, 1),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.verified, size: 100, color: Colors.white),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Pedido completado!',
                style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 26),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.transparent),
                child: Text(
                  'Pedido completado con exito, para mas detalles, revisar apartado de envios. Gracias ${nombre[0]} ! <3',
                  style:
                      GoogleFonts.quicksand(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: 200,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Continuar',
                                style: GoogleFonts.quicksand(
                                    color: const Color.fromRGBO(41, 199, 184, 1),
                                    fontSize: 22),
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(41, 199, 184, 1)),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
