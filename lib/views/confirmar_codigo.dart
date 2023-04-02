import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/socket_service.dart';
import 'package:delivery/service/twilio.dart';
import 'package:delivery/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ConfirmarCodigo extends StatefulWidget {
  final String codigo;
  final String numero;

  const ConfirmarCodigo({Key? key, required this.numero, required this.codigo})
      : super(key: key);

  @override
  State<ConfirmarCodigo> createState() => _ConfirmarCodigoState();
}

class _ConfirmarCodigoState extends State<ConfirmarCodigo> with CodeAutoFill {
  bool send = false;

  String? appSignature;
  String? otpCode;
  final TextEditingController controller = TextEditingController();

  @override
  void codeUpdated() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (!mounted) return;
    setState(() {
      otpCode = code!;
      controller.text = otpCode!;
      checkCode(
          codigo: otpCode!,
          numero: widget.numero,
          authService: authService,
          socket: socketService);
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      if (!mounted) return;
      setState(() {
        appSignature = signature;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return WillPopScope(
      onWillPop: () async => isDone,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 70),
          children: [
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: isDone ? 1 : 1,
              child: Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back_ios_rounded),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Regresar',
                                  style: GoogleFonts.quicksand(),
                                ),
                                Text(
                                  'Numero equivocado',
                                  style:
                                      GoogleFonts.quicksand(color: Colors.red),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Codigo enviado al numero',
              style: GoogleFonts.quicksand(color: Colors.grey, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${widget.codigo}  ',
                  style: GoogleFonts.quicksand(
                    color: Colors.blue,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.numero,
                  style: GoogleFonts.quicksand(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(25),
              child: PinFieldAutoFill(
                keyboardType: TextInputType.number,
                controller: controller,
                autoFocus: false,
                onCodeChanged: (code) {},
                currentCode: otpCode ?? '',
                decoration: UnderlineDecoration(
                    hintText: '0000',
                    hintTextStyle: GoogleFonts.quicksand(
                        color: Colors.grey.withOpacity(.2), fontSize: 30),
                    colorBuilder: const FixedColorBuilder(
                        Color.fromRGBO(62, 204, 191, 1)),
                    textStyle: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.8), fontSize: 30)),
                onCodeSubmitted: (valor) {},
                codeLength: 4,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Reenvio de codigo en',
                  style: GoogleFonts.quicksand(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 2),
                Column(
                  children: [
                    SlideCountdown(
                      onDone: () async {
                        if (!mounted) return;
                        setState(() {
                          isDone = true;
                        });
                      },
                      
                      decoration: const BoxDecoration(color: Colors.white),
                      duration: const Duration(minutes: 10),
                      textStyle: GoogleFonts.quicksand(
                          color: Colors.grey.withOpacity(.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Builder(builder: (_) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: send
                    ? null
                    : () {
                        if (controller.text.length == 4) {
                          checkCode(
                              codigo: controller.text.trim(),
                              numero: widget.numero,
                              authService: authService,
                              socket: socketService);
                        } else {
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.red,
                            content: Text(
                              'Codigo invalido',
                              style: GoogleFonts.quicksand(),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(.8)),
                            borderRadius: send
                                ? BorderRadius.circular(100)
                                : BorderRadius.circular(25)),
                        child: send
                            ? const SizedBox(
                                width: 19,
                                height: 19,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                ),
                              )
                            : Text('Verificar',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600))),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  checkCode(
      {required String codigo,
      required String numero,
      required AuthService authService,
      required SocketService socket}) async {
        if (!mounted) return;
    setState(() {
      send = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (codigo.length >= 3) {
      final confirmado =
          await TwilioService().confirmarSms(numero, codigo, widget.codigo);
      if (confirmado) {
        final logIn = await authService.logInCelular(numero: numero);
        if (!mounted) return;
        setState(() {
          send = false;
        });
        if (!logIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterView(numero: numero, dialCode: widget.codigo)),
          );
        } else {
          Navigator.pop(context);
          socket.connect();
        }
      } else {
        if (!mounted) return;
        setState(() {
          send = false;
        });
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text(
            'Codigo incorrecto',
            style: GoogleFonts.quicksand(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      if (!mounted) return;
      setState(() {
        send = false;
      });
    }
  }
}
