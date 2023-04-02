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

class TiendaService with ChangeNotifier {
  List<ListaProductos> _productosCategoria = [];
  List<ListaProductos> get productosCategoria => _productosCategoria;

  set productosCategoria(List<ListaProductos> catagorias) {
    _productosCategoria = catagorias;
    notifyListeners();
  }

  Future<List<Tienda>> verTodoTienda() async {
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
      return [];
    }
  }

  Future<Categorias> listaCategorias({required String filtro}) async {
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
      return dataParse;
    } catch (e) {
      return Categorias(ok: false, productos: [], tiendas: []);
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
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarProducto(
      {required String descripcion,
      required String productoUid,
      required String cantidad,
      required String nombre,
      required String precioCast,
      required String listaUid}) async {
    String precio = precioCast.replaceAll('\$', '');
    precio = precio.replaceAll(' ', '');
    precio = precio.replaceAll(',', '');

    final data = {
      'producto_uid': productoUid,
      'talla': descripcion,
      'cantidad': cantidad,
      'nombre': nombre,
      'precio': precio,
      'lista_uid': listaUid
    };

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/productos/modificarProducto'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 400) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  agregarNuevoProducto(
      {required String nombre,
      required String precio,
      required String tienda,
      required String lista,
      required String cantidad,
      required String descripcion}) async {
    String nuevoValor = precio.replaceAll('\$', '');
    nuevoValor = nuevoValor.replaceAll(' ', '');
    nuevoValor = nuevoValor.replaceAll(',', '');
    final data = {
      'listaProductos': lista,
      'cantidad': cantidad,
      'nombre': nombre,
      'precio': double.parse(nuevoValor),
      'descripcion': descripcion,
      'tienda': tienda
    };
    await Future.delayed((const Duration(seconds: 1)));
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
      print(e);
      return null;
    }
  }

  Future<Tienda?> getTienda({required String tienda}) async {
    final data = {"tienda": tienda};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/obtenerTienda'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final tienda = tiendaFromJson(resp.body);

      return tienda;
    } catch (e) {
      return null;
    }
  }

  int tiendaCache({required String nombre}) {
    productosCategoria.indexWhere((element) => element.nombre == nombre);
    return productosCategoria.indexWhere((element) => element.nombre == nombre);
  }

  eliminarTiendaCache({required String nombre}) {
    productosCategoria.removeWhere((element) => element.nombre == nombre);
  }

  

  Future<List<ListaProductosCategoria>> obtenerProductos(
      {required String nombre, required String id}) async {
    final data = {"id": id};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/obtenerProductosTienda'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final cast = listaProductosFromJson(resp.body);
      cast.nombre = nombre;
      productosCategoria.add(cast);
      notifyListeners();

      return cast.productos;
    } catch (e) {
      return [];
    }
  }
}
