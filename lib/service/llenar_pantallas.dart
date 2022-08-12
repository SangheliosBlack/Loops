import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/categorias.dart';
import 'package:delivery/models/lista_separada.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/tiendas_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LlenarPantallasService with ChangeNotifier {
  LlenarPantallasService() {
    pantallaPrincipalCategorias();
    pantallaPrincipalTiendas();
    pantallaPrincipalProductos();
  }

  List<Separado> _productos = [];

  List<Separado> get productos => _productos;

  set productos(List<Separado> productos) {
    _productos = productos;
    notifyListeners();
  }

  List<String> _categorias = [];

  List<String> get categorias => _categorias;

  set categorias(List<String> categorias) {
    _categorias = categorias;
    notifyListeners();
  }

  List<Tienda> _tiendas = [];

  List<Tienda> get tiendas => _tiendas;

  set tiendas(List<Tienda> tiendasR) {
    _tiendas = tiendasR;
    notifyListeners();
  }

  abrirNegocio({required String token}) {
    if (tiendas.isNotEmpty) {
      var index = tiendas.indexWhere((element) => element.puntoVenta == token);
      tiendas[index].online = true;
      notifyListeners();
    }
  }

  cerrarNegocio({required String token}) {
    if (tiendas.isNotEmpty) {
      var index = tiendas.indexWhere((element) => element.puntoVenta == token);
      tiendas[index].online = false;
      notifyListeners();
    }
  }

  pantallaPrincipalCategorias() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final resp = await http.get(
          Uri.parse(
              '${Statics.apiUrl}/tiendas/construirPantallaPrincipalCategorias'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final pantallaResponse = categoriasFromJson(resp.body);

      categorias = pantallaResponse;

      return pantallaResponse;
    } catch (e) {
      return [];
    }
  }

  pantallaPrincipalProductos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final resp = await http.get(
          Uri.parse(
              '${Statics.apiUrl}/tiendas/construirPantallaPrincipalProductos'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final pantallaResponse = listaSeparadaFromJson(resp.body);

      productos = pantallaResponse.separados;

      productos.shuffle();

      return pantallaResponse;
    } catch (e) {
      return [];
    }
  }

  pantallaPrincipalTiendas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final resp = await http.get(
          Uri.parse(
              '${Statics.apiUrl}/tiendas/construirPantallaPrincipalTiendas'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final pantallaResponse = tiendaResponseFromJson(resp.body);

      tiendas = pantallaResponse.tiendas;

      return pantallaResponse;
    } catch (e) {
      return [];
    }
  }

  recargarTodo() {
    tiendas = [];
    categorias = [];
    productos = [];
  }
}
