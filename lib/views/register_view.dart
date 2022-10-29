import 'package:delivery/models/errors.dart';
import 'package:delivery/providers/register_form_provider.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:delivery/views/terminos_y_condiciones.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  final String numero;
  final String dialCode;

  const RegisterView({Key? key, required this.numero, required this.dialCode})
      : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final passCtrl = TextEditingController();

  final passConfCtrl = TextEditingController();

  final nameCtrl = TextEditingController();

  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          ChangeNotifierProvider(
            create: (_) => RegisterFromProvider(),
            child: Builder(
              builder: (BuildContext context) {
                final registerFormProvider =
                    Provider.of<RegisterFromProvider>(context);
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 0, top: 40),
                        child: Text(
                          'Registrame',
                          style: GoogleFonts.quicksand(fontSize: 40),
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Text('Primera vez aqui?',
                          style: GoogleFonts.quicksand(color: Colors.black)),
                      const SizedBox(
                        height: 25,
                      ),
                      Theme(
                        data: ThemeData(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                secondary:
                                    const Color.fromRGBO(62, 204, 191, 1),
                                primary:
                                    const Color.fromRGBO(62, 204, 191, 1))),
                        child: Form(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: emailCtrl,
                                  onChanged: (valor) {
                                    registerFormProvider.email = valor;
                                  },
                                  /*validator: (value) {
                                    if (registerFormProvider.email == '') {
                                      return '\u26A0 ' + 'Campo invalido';
                                    } else {
                                      if (registerFormProvider.emailError != '') {
                                        return '\u26A0 ' +
                                            registerFormProvider.emailError;
                                      } else {
                                        return null;
                                      }
                                    }
                                  },*/
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                  decoration: InputDecoration(
                                      errorText: registerFormProvider
                                              .emailError.isEmpty
                                          ? null
                                          : registerFormProvider.emailError,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorStyle: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      contentPadding: const EdgeInsets.only(
                                          left: 25, top: 10, bottom: 10),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: false,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        color: Color.fromRGBO(62, 204, 191, 1),
                                        size: 20,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.start,
                                      hintText: 'tucorreo@tucorre.com',
                                      labelStyle: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      labelText: 'CORREO ELECTRONICO'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: passCtrl,
                                  onChanged: (valor) {
                                    registerFormProvider.password = valor;
                                  },
                                  /*validator: (value) {
                                    if (registerFormProvider.password == '') {
                                      return '\u26A0 ' + 'Campo invalido';
                                    } else {
                                      if (registerFormProvider.passwordError != '') {
                                        return '\u26A0 ' +
                                            registerFormProvider.passwordError;
                                      } else {
                                        return null;
                                      }
                                    }
                                  },*/
                                  obscureText: registerFormProvider.obscureText,
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                  decoration: InputDecoration(
                                      errorText: registerFormProvider
                                              .passwordError.isEmpty
                                          ? null
                                          : registerFormProvider.passwordError,
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            registerFormProvider.obscureText =
                                                !registerFormProvider
                                                    .obscureText;
                                          },
                                          child: Icon(
                                              registerFormProvider.obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorStyle: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      contentPadding: const EdgeInsets.only(
                                          left: 25, top: 10, bottom: 10),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: false,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.start,
                                      hintText: 'Minimo 6 caracteres',
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Color.fromRGBO(62, 204, 191, 1),
                                        size: 20,
                                      ),
                                      labelStyle: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      labelText: 'CONTRASEÑA'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: passConfCtrl,
                                  onChanged: (valor) {
                                    registerFormProvider.confirmPassword =
                                        valor;
                                  },
                                  /*validator: (value) {
                                    if (registerFormProvider.confirmPassword == '') {
                                      return '\u26A0 ' + 'Campo invalido';
                                    } else {
                                      if (registerFormProvider.confirmPasswordError !=
                                          '') {
                                        return '\u26A0 ' +
                                            registerFormProvider.confirmPasswordError;
                                      } else {
                                        return null;
                                      }
                                    }
                                  },*/
                                  obscureText: true,
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                  decoration: InputDecoration(
                                      errorText: registerFormProvider
                                              .confirmPasswordError.isEmpty
                                          ? null
                                          : registerFormProvider
                                              .confirmPasswordError,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorStyle: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      contentPadding: const EdgeInsets.only(
                                          left: 25, top: 10, bottom: 10),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.start,
                                      hintText: 'Confirmar su contraseña',
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.check,
                                        color: Color.fromRGBO(62, 204, 191, 1),
                                        size: 20,
                                      ),
                                      labelStyle: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      labelText: 'CONFIRMAR CONTRASEÑA'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: nameCtrl,
                                  onChanged: (valor) {
                                    registerFormProvider.name = valor;
                                  },
                                  /*validator: (value) {
                                    if (registerFormProvider.name == '') {
                                      return '\u26A0 ' + 'Campo invalido';
                                    } else {
                                      if (registerFormProvider.nameError != '') {
                                        return '\u26A0 ' +
                                            registerFormProvider.nameError;
                                      } else {
                                        return null;
                                      }
                                    }
                                  },*/
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      GoogleFonts.quicksand(color: Colors.grey),
                                  decoration: InputDecoration(
                                      errorText:
                                          registerFormProvider.nameError.isEmpty
                                              ? null
                                              : registerFormProvider.nameError,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorStyle: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                      contentPadding: const EdgeInsets.only(
                                          left: 25, top: 10, bottom: 10),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: false,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.face,
                                        color: Color.fromRGBO(62, 204, 191, 1),
                                        size: 20,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.start,
                                      hintText: 'Nombre completo',
                                      labelStyle: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                      labelText: 'Nombre'),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TerminosCondicionesView()),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Al hacer clic en ',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black.withOpacity(.8)),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '"Registrarme"',
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                        const TextSpan(
                                            text:
                                                ' , aceptas nuestras Condiciones, la Política de privacidad.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                height: 60,
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                                width: authProvider.buttonStatus !=
                                        ButtonStatus.disponible
                                    ? 60
                                    : width - 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        authProvider.buttonStatus !=
                                                ButtonStatus.disponible
                                            ? 100
                                            : 25)),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: authProvider.buttonStatus ==
                                          ButtonStatus.disponible
                                      ? () async {
                                          registerFormProvider
                                              .restablecerErrores();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          final List<Errore> registroOk =
                                              await authProvider.register(
                                                  nameCtrl.text.trim(),
                                                  emailCtrl.text.trim(),
                                                  passCtrl.text.trim(),
                                                  widget.numero,
                                                  passConfCtrl.text.trim(),
                                                  widget.dialCode);

                                          if (registroOk.isEmpty) {
                                            navigationService
                                                .navigateToReplace('dashboard');
                                            Navigator.pop(context);
                                          } else {
                                            registerFormProvider
                                                .validarErrores(registroOk);
                                            authProvider.buttonStatus =
                                                ButtonStatus.disponible;
                                          }
                                        }
                                      : null,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: Center(
                                      child: authProvider.buttonStatus !=
                                              ButtonStatus.disponible
                                          ? const SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Registrarme',
                                              style: GoogleFonts.quicksand(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 35,
                      // ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.symmetric(
                      //           vertical: 15, horizontal: 15),
                      //       child: Text(
                      //         'Ya tengo cuenta?',
                      //         style: GoogleFonts.quicksand(
                      //             color: Colors.grey,
                      //             fontWeight: FontWeight.w600),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: authProvider.buttonStatus ==
                      //                 ButtonStatus.disponible
                      //             ? () async {
                      //                 navigationService.navigateTo('/auth/login');
                      //               }
                      //             : null,
                      //         child: Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 border: Border.all(
                      //                     width: 1,
                      //                     color: Colors.grey.withOpacity(.5))),
                      //             alignment: Alignment.center,
                      //             padding:
                      //                 const EdgeInsets.symmetric(vertical: 20),
                      //             child: Text(
                      //               'Ingresar',
                      //               style: GoogleFonts.quicksand(
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.black,
                      //                   fontSize: 17),
                      //             )),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  showErrors(BuildContext context, List<Errore> registroOk) async =>
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          builder: (builder) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text('Datos incorrectos',
                        style: GoogleFonts.quicksand(
                            fontSize: 30, color: Colors.black.withOpacity(.7))),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          errorMsg(registroOk[index].msg),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                      itemCount: registroOk.length),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(top: 25),
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  primary: Theme.of(context).primaryColor),
                              child: Text(
                                'Ok',
                                style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
  Widget errorMsg(String titulo) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.10),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Icon(
            Icons.warning,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text('  ' + titulo,
            style: GoogleFonts.quicksand(
                fontSize: 14, fontWeight: FontWeight.w600))
      ],
    );
  }
}
