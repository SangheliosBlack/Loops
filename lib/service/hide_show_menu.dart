import 'package:flutter/material.dart';

class GeneralActions with ChangeNotifier {
  int _paginaActual = 0;

  int get paginaActual => _paginaActual;

  set paginaActual(int valor) {
    _paginaActual = valor;
    notifyListeners();
  }

  PageController controller2 = PageController(initialPage: 0, keepPage: true);

  controllerNavigate(int page) {
    controller2.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    paginaActual = page;
  }

  Future<bool> resetView() async {
    paginaActual = 0;
    return true;
  }
}
