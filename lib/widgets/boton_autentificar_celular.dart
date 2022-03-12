import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/service/twilio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';

class BotonAutentificar extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  const BotonAutentificar(
      {Key? key, required this.formKey, required this.controller})
      : super(key: key);

  @override
  State<BotonAutentificar> createState() => _BotonAutentificarState();
}

class _BotonAutentificarState extends State<BotonAutentificar> {
  bool send = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: send ? null : () async {
        var validar = widget.formKey.currentState!.validate();
        if (validar) {
          setState(() {
            send = true;
          });
          await Future.delayed(const Duration(seconds: 5));

          FocusManager.instance.primaryFocus?.unfocus();
          final signCode = await SmsAutoFill().getAppSignature;

          final estado =
              await TwilioService().enviarSms(widget.controller.text, signCode);
          setState(() {
            send = false;
          });
          if (estado) {
            final String numero = widget.controller.text;

            navigationService.navigateTo('/phone/confirmar/$numero/$signCode');
          } else {
            final snackBar = SnackBar(
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
              content: Text(
                'Error al verificar tu numero',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: send ? 50 : width - 50,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(62, 204, 191, 1),
                  borderRadius: send
                      ? BorderRadius.circular(100)
                      : BorderRadius.circular(10)),
              child: send
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    )
                  : Text('Continuar',
                      style: GoogleFonts.quicksand(
                          color: Colors.white, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}


