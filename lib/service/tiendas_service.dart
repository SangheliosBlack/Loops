import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/categorias_response.dart';
import 'package:delivery/models/lista_productos.dart';
import 'package:delivery/models/producto_response.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/tiendas_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class TiendasService with ChangeNotifier {
  late Tienda _tienda;

  Tienda get tienda => _tienda;

  set tienda(Tienda tiendas) {
    _tienda = tiendas;
    notifyListeners();
  }

  TiendasService() {
    /*getTienda();*/
  }

  Future<List<Tienda>> verTodoTienda() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final resp = await http
          .get(Uri.parse('${Statics.apiUrl}/tiendas/verTodoTiendas'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final dataParse = tiendaResponseFromJson(resp.body);
      return dataParse.tiendas;
    } catch (e) {
      return [];
    }
  }

  Future<List<Producto>> verTodoProductos() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final resp = await http.get(
          Uri.parse('${Statics.apiUrl}/tiendas/verTodoProductos'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final dataParse = productoResponseFromJson(resp.body);
      return dataParse.productos;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Producto>> listaCategorias({required String filtro}) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = {'filtro': filtro};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/obtenerProductosCategoria'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final dataParse = categoriasFromJson(resp.body);
      return dataParse.productos;
    } catch (e) {
      return [];
    }
  }

  Future<bool> cambiarHorarioTienda(
      {required String id,
      required String apertura,
      required String cierre}) async {
    final data = {'tienda': id, 'apertura': apertura, 'cierre': cierre};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/modificarHorario'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        tienda.horario.apertura = DateTime.parse('2020-01-01T' + apertura);
        tienda.horario.cierre = DateTime.parse('2020-01-01T' + cierre);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> cambiarStatus(String id, bool disponible) async {
    final data = {"tienda": id, "disponible": disponible};

    tienda.disponible = disponible;

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/modificarStatus'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> cambiarAniversario(
      {required String id, required String aniversario}) async {
    final data = {"tienda": id, "aniversario": aniversario};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/modificarAniversario'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        tienda.aniversario = DateTime.parse(aniversario);

        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  agregarNuevoProducto(
      {required String nombre,
      required String precio,
      required String lista,
      required String descripcion}) async {
    String nuevoValor = precio.replaceAll('\$', '');
    nuevoValor = nuevoValor.replaceAll(' ', '');
    nuevoValor = nuevoValor.replaceAll(',', '');
    final data = {
      'listaProductos': lista,
      'nombre': nombre,
      'precio': double.parse(nuevoValor),
      'descripcion': descripcion,
    };
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/productos/nuevoProducto'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final productoResp = productoFromJson(resp.body);
      return productoResp;
    } catch (e) {
      return null;
    }
  }

  getTienda() async {
    try {
      final resp = await http
          .get(Uri.parse('${Statics.apiUrl}/tiendas/obtenerTienda'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      tienda = tiendaFromJson(resp.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<ListaProductosCategoria>> obtenerProductos() async {
    try {
      final resp = await http.get(
          Uri.parse('${Statics.apiUrl}/tiendas/obtenerProductosTienda'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final cast = listaProductosFromJson(resp.body);
      return cast.productos;
    } catch (e) {
      return [];
    }
  }
}
