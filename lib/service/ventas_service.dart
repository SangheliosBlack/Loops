import 'dart:developer';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PedidosService with ChangeNotifier {
  List<Venta> listaOrdenesLocal = [];

  agregarCompra({required Venta venta}) {
    listaOrdenesLocal.insert(0, venta);
    notifyListeners();
  }

  PedidosService() {
    listaOrdenes();
  }

  Future<List<Venta>> listaOrdenes() async {
    try {
      final resp = await http
          .get(Uri.parse('${Statics.apiUrl}/usuario/ordenes'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      log(resp.body);
      final lista = ventaResponseFromJson(resp.body);

      if (lista.isNotEmpty) {
        listaOrdenesLocal = lista;
        notifyListeners();
      }
      return lista;
    } catch (e) {
      return [];
    }
  }

  recargarPedidos() {
    listaOrdenesLocal = [];
    notifyListeners();
  }
}
