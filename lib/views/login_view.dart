import 'package:delivery/global/styles.dart';
import 'package:delivery/models/errors.dart';
import 'package:delivery/providers/login_form_provider.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final passCtrl = TextEditingController();

  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthService>(context);
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        ChangeNotifierProvider(
          create: (_) => LoginFromProvider(),
          child: Builder(
            builder: (BuildContext context) {
              final loginFormProvider = Provider.of<LoginFromProvider>(context);
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0, top: 40),
                      child: Text(
                        'Iniciar sesion',
                        style: Styles.letterCustom(40, true, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Text('Bienvenido de nuevo!',
                        style: GoogleFonts.quicksand(color: Colors.grey)),
                    const SizedBox(
                      height: 25,
                    ),
                    Theme(
                      data: ThemeData(
                          colorScheme: ThemeData().colorScheme.copyWith(
                              secondary: Colors.white, primary: Colors.white)),
                      child: Form(
                        key: loginFormProvider.formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: emailCtrl,
                                onChanged: (valor) {
                                  loginFormProvider.email = valor;
                                },
                                /*validator: (value) {
                                  if (loginFormProvider.email == '') {
                                    return '\u26A0 ' + 'Campo invalido';
                                  } else {
                                    if (loginFormProvider.emailError != '') {
                                      return '\u26A0 ' + loginFormProvider.emailError;
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
                                        loginFormProvider.emailError.isEmpty
                                            ? null
                                            : loginFormProvider.emailError,
                                    errorBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorStyle: GoogleFonts.quicksand(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                    contentPadding: const EdgeInsets.only(
                                        left: 25, top: 10, bottom: 10),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: false,
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.mail_outline,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    labelStyle: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    labelText: 'CORREO ELECTRONICO'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: passCtrl,
                                onChanged: (valor) {
                                  loginFormProvider.password = valor;
                                },
                                validator: (value) {
                                  if (loginFormProvider.password == '') {
                                    return '\u26A0 Campo invalido';
                                  } else {
                                    if (loginFormProvider.passwordError != '') {
                                      return '\u26A0 ' +
                                          loginFormProvider.passwordError;
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                obscureText: loginFormProvider.obscureText,
                                keyboardType: TextInputType.emailAddress,
                                style:
                                    GoogleFonts.quicksand(color: Colors.grey),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  errorText:
                                      loginFormProvider.passwordError.isEmpty
                                          ? null
                                          : loginFormProvider.passwordError,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      loginFormProvider.obscureText =
                                          !loginFormProvider.obscureText;
                                    },
                                    child: Icon(
                                      loginFormProvider.obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  errorStyle: GoogleFonts.quicksand(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  contentPadding: const EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  labelStyle: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  labelText: 'CONTRASEÑA',
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
                                  color: const Color.fromRGBO(62, 204, 191, 1),
                                  borderRadius: BorderRadius.circular(
                                      authProvider.buttonStatus !=
                                              ButtonStatus.disponible
                                          ? 100
                                          : 15)),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: authProvider.buttonStatus ==
                                        ButtonStatus.disponible
                                    ? () async {
                                        loginFormProvider.restablecerErrores();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        List<Errore> registroOk =
                                            await authProvider.logIn(
                                          emailCtrl.text.trim(),
                                          passCtrl.text.trim(),
                                        );
                                        if (registroOk.isEmpty) {
                                        } else {
                                          loginFormProvider
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
                                            'Iniciar',
                                            style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Olvidaste tu contraseña?',
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: authProvider.buttonStatus ==
                              ButtonStatus.disponible
                          ? () async {
                              navigationService.navigateTo('/auth/register');
                            }
                          : null,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(.5))),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Registrarme',
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 17),
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  showErrors(BuildContext context, List<Errore> registroOk) async =>
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                          errorMsg(
                              titulo: registroOk[index].msg,
                              valor: registroOk[index].msg),
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

  Widget errorMsg({required String titulo, required String valor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.05),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 0),
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
                color: Colors.grey.withOpacity(1),
                fontSize: 14,
                fontWeight: FontWeight.w600))
      ],
    );
  }
}
