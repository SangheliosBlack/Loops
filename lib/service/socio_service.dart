// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/venta_model_pro.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum LoadStatus { isInitialized, noYet }

class SocioService with ChangeNotifier {
  LoadStatus loadStatus = LoadStatus.noYet;

  late Tienda tienda;

  SocioService() {
    getTienda();
  }

  conectarNegocio() {
    tienda.online = true;
    notifyListeners();
  }

  desconectarNegocio() {
    tienda.online = false;
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

  obtenerPedidos({required String filter}) async {
    final data = {'filtro': filter};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/pedidos'),
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

  getTienda() async {
    try {
      final data = {"token": await AuthService.getPuntoVenta()};
      await Future.delayed(const Duration(seconds: 1));
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

          loadStatus = LoadStatus.isInitialized;

          notifyListeners();
        }
      } catch (e) {}
    } catch (e) {}
  }
}
