import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SistemaEstadoLayout extends StatelessWidget {
  const SistemaEstadoLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          authProvider.estadoSistemaStatus == EstadoSistema.restringido
              ? 'Usuario restringido.'
              : authProvider.estadoSistemaStatus == EstadoSistema.noUpdate
                  ? 'Actuliza tu app'
                  : authProvider.estadoSistemaStatus == EstadoSistema.isClosed
                      ? 'Servidor cerrado error 400.'
                      : 'Mantenimiento error 202.',
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 35),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.primary)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Image(image: AssetImage('assets/images/loops.jpg')),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                authProvider.estadoSistemaStatus == EstadoSistema.restringido
                    ? 'Tu usuario ha sido restringido del sistema'
                    : authProvider.estadoSistemaStatus == EstadoSistema.noUpdate
                        ? 'Tu version de Loops se encuentra desactulizada :('
                        : authProvider.estadoSistemaStatus ==
                                EstadoSistema.isClosed
                            ? 'Loops se encuentra fuera de linea :('
                            : 'Loops se encuentra en mantenimiento :(',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(fontSize: 23),
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                behavior: HitTestBehavior.translucent,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Text(
                        'Salir',
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
