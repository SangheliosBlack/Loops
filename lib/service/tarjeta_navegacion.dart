import 'package:flutter/cupertino.dart';

class TarjetaNavegacion with ChangeNotifier {
  /*GENREAL*/

  double opacidadBoton() {
    if (numeroPantalla == 0 && checkBrandExist()) {
      return 1.0;
    } else {
      return .3;
    }
  }

  void navegar(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (numeroPantalla == 0 && checkBrandExist()) {
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      numeroPantalla = numeroPantalla++;
    }
  }

  PageController pageController = PageController();

  int _numeroPantalla = 0;

  int get numeroPantalla => _numeroPantalla;

  set numeroPantalla(int pantalla) {
    _numeroPantalla = pantalla;
    notifyListeners();
  }

  /*FECHA*/

  final fechaTarjetaController = TextEditingController();

  void actualizarFechaControlador() {
    fechaTarjetaController;
    notifyListeners();
  }

  bool checkDate(String valor) {
    RegExp exp = RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$");

    if (exp.hasMatch(valor)) {
      return true;
    } else {
      return false;
    }
  }

  /*NUMERO TARJETA*/

  final numeroTarjetaController = TextEditingController();

  void actualizarNumeroControlador() {
    numeroTarjetaController;
    notifyListeners();
  }

  bool checkBrandExist() {
    final String nuevoValor =
        numeroTarjetaController.text.trim().replaceAll(" ", "");

    RegExp visaExp = RegExp(
      r"^4[0-9]{6,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp masterCardExp = RegExp(
      r"^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp americanExp = RegExp(
      r"^3[47][0-9]{5,}$",
      caseSensitive: false,
      multiLine: false,
    );

    RegExp discoveryExp = RegExp(
      r"^6(?:011|5[0-9]{2})[0-9]{3,}$",
      caseSensitive: false,
      multiLine: false,
    );

    if (visaExp.hasMatch(nuevoValor) ||
        masterCardExp.hasMatch(nuevoValor) ||
        americanExp.hasMatch(nuevoValor) ||
        discoveryExp.hasMatch(nuevoValor)) {
      if (nuevoValor.trim().length >= 16 && nuevoValor.trim().length <= 19) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
