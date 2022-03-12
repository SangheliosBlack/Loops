import 'package:delivery/global/styles.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:delivery/service/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconMedia extends StatelessWidget {
  final IconData icono;
  final Color color;

  const CustomIconMedia({Key? key, required this.icono, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: 40,
      height: 40,
      child: Icon(
        icono,
        size: 17,
        color: Colors.white,
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height,
        width: double.infinity,
        child: const FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://images.unsplash.com/photo-1585047668151-b281b0c89c97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxMzU3NTF8MHwxfHNlYXJjaHw0fHxVQkVSJTIwRUFUU3xlbnwwfHx8&ixlib=rb-1.2.1&q=80&w=800'),
          placeholder: AssetImage('assets/images/place_holder.gif'),
        ));
  }
}

class TypeAuth extends StatelessWidget {
  final bool isRegister;
  final AuthService authService;

  const TypeAuth(
      {Key? key, required this.isRegister, required this.authService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (isRegister
                    ? 'No es tu primera vez aqui?'
                    : 'Es tu primera vez aqui?'),
                style: Styles.letterCustom(15, true, -0.1),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  //await authService.resetAll();
                  isRegister
                      ? navigationService.navigateTo('/auth/login')
                      : navigationService.navigateTo('/auth/register');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: Styles.containerCustom(),
                  child: Text(
                    (isRegister ? 'Iniciar sesion' : 'Registrarme'),
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.white,
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomIconMedia(
                  icono: FontAwesomeIcons.facebookF,
                  color: Color.fromRGBO(20, 162, 249, 1),
                ),
                CustomIconMedia(
                  icono: FontAwesomeIcons.google,
                  color: Color.fromRGBO(235, 77, 77, 1),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget titleAuth(String titulo) {
  return Container(
    margin: const EdgeInsets.only(bottom: 30),
    child: Text(
      titulo,
      style: Styles.letterCustom(35, true, -0.1),
    ),
  );
}

class ButtonAuth extends StatelessWidget {
  final AuthService authService;
  final bool isLogin;

  final TextEditingController passCtrl;
  final TextEditingController passConfCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;

  const ButtonAuth(
      {Key? key,
      required this.authService,
      this.isLogin = false,
      required this.passCtrl,
      required this.passConfCtrl,
      required this.nameCtrl,
      required this.emailCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      //width: authService.autenticando ? 45 : 60,
      child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              )),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          /*onPressed: authService.autenticando
              ? null
              : (() async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  authService.autenticando = true;
                  if (!isLogin) {
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                        passConfCtrl.text.trim());
                    print(registroOk);
                    if (registroOk == true) {
                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  } else {
                    final loginOk = await authService.logIn(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk == true) {
                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  }
                }),*/
          onPressed: () {},
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                /*child: authService.autenticando
                    ? Container(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Icon(
                        Icons.login_outlined,
                        color: Theme.of(context).primaryColor,
                      ),*/
              ))),
    );
  }
}
