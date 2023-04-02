// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:developer';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/abono.dart';
import 'package:delivery/models/productos.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/venta_model_pro.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoadStatus { isInitialized, noYet }

enum LoadStatusApartados { isInitialized, noYet }

class SocioService with ChangeNotifier {
  LoadStatus loadStatus = LoadStatus.noYet;
  LoadStatusApartados loadStatusApartados = LoadStatusApartados.noYet;

  late Tienda tienda;

  //APARTADOS

  List<PedidoProducto> apartados = [];

  eliminarApartados() {
    loadStatusApartados = LoadStatusApartados.noYet;
    apartados = [];
    notifyListeners();
  }

  obtenerApartados() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final resp = await http.get(
          Uri.parse('${Statics.apiUrl}/tiendas/obtenerApartados'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      apartados = ventaProFromJson(resp.body).venta;
      loadStatusApartados = LoadStatusApartados.isInitialized;
      notifyListeners();
    } catch (e) {}
  }

  //APARTADOS

  num entregado = 0;

  SocioService() {
    getTienda();
    obtenerApartados();
  }

  conectarNegocio() {
    tienda.online = true;
    notifyListeners();
  }

  desconectarNegocio() {
    tienda.online = false;
    notifyListeners();
  }

  agregarNuevoProducto({required Producto producto}) {
    tienda.listaProductos.insert(0, producto);
    notifyListeners();
  }

  editarMultiplesCantidades({required Venta venta}) {
    for (var element in venta.pedidos[0].productos) {
      int index = tienda.listaProductos
          .indexWhere((element2) => element2.id == element.id);

      if (index != -1) {
        tienda.listaProductos[index].cantidad =
            tienda.listaProductos[index].cantidad - element.cantidad;
      }
    }
    notifyListeners();
  }

  Future<bool> eliminarProducto(
      {required String idListado, required String idProducto}) async {
    final data = {"lista_productos": idListado, "id_producto": idProducto};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/productos/eliminarProducto'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final statusCode = resp.statusCode;

      if (statusCode == 200) {
        tienda.listaProductos
            .removeWhere((element) => element.id == idProducto);
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  editarProductoInterno(
      {required String id,
      required String talla,
      required String cantidad,
      required String nombre,
      required String precio}) {
    final place =
        tienda.listaProductos.indexWhere((element) => element.id == id);

    tienda.listaProductos[place].descripcion = talla;
    tienda.listaProductos[place].cantidad = num.parse(cantidad);
    tienda.listaProductos[place].nombre = nombre;
    tienda.listaProductos[place].precio = num.parse(precio);

    notifyListeners();
  }

  VentaPro ventaCache =
      VentaPro(venta: [], size: 0, completados: 0, ganancia: 0);

  Future<bool> confirmarCodigoRepartidor(
      {required String idVenta, required String idSubventa}) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final data = {'uid': idVenta, 'uidVenta': idSubventa};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/confirmarPedidoRepartidor'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        ventaCache
            .venta[ventaCache.venta
                .indexWhere((element) => element.id == idSubventa)]
            .entregadoRepartidor = true;
        ventaCache
            .venta[ventaCache.venta
                .indexWhere((element) => element.id == idSubventa)]
            .entregadoRepartidorTiempo = DateTime.now();

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool ventasCargadas = false;

  eliminarData() {
    ventasCargadas = false;
    ventaCache.venta = [];
    notifyListeners();
  }

  obtenerPedidos(
      {String tienda = '',
      bool tiendaRopa = false,
      required String filter,
      required String token}) async {
    final data = {
      'filtro': filter,
      'token': token,
      'tienda': tienda,
      'tienda_ropa': tiendaRopa
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/pedidos'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      log(resp.body);

      final ventas = ventaProFromJson(resp.body);
      ventaCache = ventas;
      ventasCargadas = true;
      notifyListeners();
    } catch (e) {
      print('errrrro');
      print(e);
    }
  }

  Future<bool> recalcularAbonos(
      {required String cantidad,
      required String ventaId,
      required bool liquidado}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final data = {
      'cantidad': cantidad,
      'ventaId': ventaId,
      'liquidado': liquidado
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/agregarNuevoAbono'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        if (liquidado) {
          apartados.removeWhere((element) => element.id == ventaId);
        } else {
          apartados[apartados.indexWhere((element) => element.id == ventaId)]
              .abonos
              .add((Abono(
                  fecha: DateTime.now(),
                  cantidad: num.parse(cantidad),
                  titulo: 'Abono')));
        }
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Venta?> obtenerVentaQR({
    required String qr,
  }) async {
    final data = {'qr': qr};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/busquedaQRVenta'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        log(resp.body);
        final venta = ventoFromJson(resp.body);
        return venta;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  obtenerEnvios({required String filter}) async {
    final data = {'filtro': filter};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/envios'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final ventas = ventaProFromJson(resp.body);
      ventaCache = ventas;
      ventasCargadas = true;
      notifyListeners();
    } catch (e) {}
  }

  macChange({required String mac, required String id}) async {
    tienda.mac = mac;
    notifyListeners();
    final data = {"id": id, 'mac': mac};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/macChangue'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        /*do something*/
      }
    } catch (e) {
      /*cath error faltante*/
    }
  }

  autoImpresionStatus({required bool status, required String id}) async {
    tienda.autoImpresion = status;
    notifyListeners();
    final data = {"id": id, 'status': status};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/autoImpresion'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        /*do something*/
      }
    } catch (e) {
      /*cath error faltante*/
    }
  }

  Future<bool> confirmacionPedido(
      {required String id, required String venta}) async {
    final data = {'uid': venta, 'uidVenta': id};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/confirmarPedidoRestaurante'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        ventaCache
            .venta[
                ventaCache.venta.indexWhere((element) => element.id == venta)]
            .confirmado = true;
        ventaCache
            .venta[
                ventaCache.venta.indexWhere((element) => element.id == venta)]
            .confirmacionTiempo = DateTime.now();
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  modificarEntregadoCliente({required String dinero}) {
    entregado = num.parse(dinero);

    notifyListeners();
  }

  modificarEntregadoCliente2({required String dinero}) {
    entregado = 0;
    notifyListeners();
  }

  getTienda() async {
    try {
      final data = {"token": await AuthService.getPuntoVenta()};
      try {
        final resp = await http.post(
            Uri.parse('${Statics.apiUrl}/tiendas/obtenerTienda'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json',
              'x-token': await AuthService.getToken()
            });

        final tiendaParse = tiendaFromJson(resp.body);

        if (resp.statusCode == 200) {
          tienda = tiendaParse;

          tienda.listaProductos.sort((a, b) => a.nombre.compareTo(b.nombre));

          loadStatus = LoadStatus.isInitialized;

          notifyListeners();
        }
      } catch (e) {}
    } catch (e) {}
  }
}
