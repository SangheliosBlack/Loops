import 'package:delivery/models/errors.dart';
import 'package:flutter/cupertino.dart';

class LoginFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email = '';
  String get email => _email;
  set email(String valor) {
    _email = valor;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String valor) {
    _password = valor;
    notifyListeners();
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String valor) {
    _confirmPassword = valor;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  set name(String valor) {
    _name = valor;
    notifyListeners();
  }
  //errors

  String _emailError = '';
  String get emailError => _emailError;
  set emailError(String valor) {
    _emailError = valor;
    notifyListeners();
  }

  String _passwordError = '';
  String get passwordError => _passwordError;
  set passwordError(String valor) {
    _passwordError = valor;
    notifyListeners();
  }

  String _confirmPasswordError = '';
  String get confirmPasswordError => _confirmPasswordError;
  set confirmPasswordError(String valor) {
    _confirmPasswordError = valor;
    notifyListeners();
  }

  String _nameError = '';
  String get nameError => _nameError;
  set nameError(String valor) {
    _nameError = valor;
    notifyListeners();
  }
  //errors

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool valor) {
    _obscureText = valor;
    notifyListeners();
  }

  Future<bool> isValidForm() async {
    return formKey.currentState?.validate() ?? false;
  }

  void restablecerErrores() {
    emailError = '';
    passwordError = '';
  }

  void validarErrores(List<Errore> errores) {
    for (var element in errores) {
      if (element.param == "correo") {
        emailError = element.msg;
      }
      if (element.param == "contrasena") {
        passwordError = element.msg;
      }
    }
  }
}
