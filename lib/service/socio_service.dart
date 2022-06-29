// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/tienda.dart';
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

  Future getTienda() async {
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

      tienda = tiendaParse;

      loadStatus = LoadStatus.isInitialized;

      notifyListeners();

      return tienda;
    } catch (e) {
    }
  }
}
