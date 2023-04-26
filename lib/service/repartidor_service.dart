// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/google_directions.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class RepartidorProvider with ChangeNotifier {
  List<PedidoProducto> _listaEnvios = [];

  List<PedidoProducto> get listaEnvios => _listaEnvios;

  set listaEnvios(List<PedidoProducto> envios) {
    _listaEnvios = envios;
    notifyListeners();
  }

  late GoogleMapController _controllerM;

  GoogleMapController get controllerM => _controllerM;

  void onMapCreated(GoogleMapController controller) async {
    _controllerM = controller;

    controller.setMapStyle(Statics.mapStyle2);
  }

  moverPuntos() {
    int valor = listaEnvios.indexWhere((element) => !element.entregadoCliente);
    controllerM.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(listaEnvios[valor].ruta.bounds.southwest.lat,
                listaEnvios[valor].ruta.bounds.southwest.lng),
            northeast: LatLng(listaEnvios[valor].ruta.bounds.northeast.lat,
                listaEnvios[valor].ruta.bounds.northeast.lng)),
        100));
  }

  Future<bool> confirmarEntrega() async {
    await Future.delayed(const Duration(seconds: 1));
    int valor = listaEnvios.indexWhere((element) => !element.entregadoCliente);
    final data = {'id': listaEnvios[valor].id};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/confirmarPedidoEntregado'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        listaEnvios[valor].entregadoRepartidor = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  

  Future<List<PedidoProducto>> cargarPedidos() async {
    await Future.delayed(const Duration(milliseconds: 750));
    try {
      final resp = await http
          .post(Uri.parse('${Statics.apiUrl}/repartidor/envios'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      if (resp.statusCode == 200) {
        final envios = pedidoProductoFromJson(resp.body);
        return envios;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<GoogleDirections?> obtenerRuta() async {
    await Future.delayed(const Duration(milliseconds: 750));
    try {
      final resp = await http
          .post(Uri.parse('${Statics.apiUrl}/repartidor/envios'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final direccion = googleDirectionsFromJson(resp.body);
      return direccion;
    } catch (e) {
      return null;
    }
  }

  Future<List<PedidoProducto>> cargarPedidosMomento() async {
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/repartidor/enviosMomento'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final envios = pedidoProductoFromJson(resp.body);
      listaEnvios = envios;
      return envios;
    } catch (e) {
      return [];
    }
  }

  Future<bool> confirmarCodigoCliente(
      {required String idVenta, required String idSubventa,required num envio}) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final data = {'uid': idVenta, 'uidVenta': idSubventa,'envio':envio};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/confirmarPedidoCliente'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        listaEnvios[listaEnvios
                .indexWhere((element) => element.id == idSubventa)]
            .entregadoCliente = true;
        listaEnvios[listaEnvios
                .indexWhere((element) => element.id == idSubventa)]
            .entregadoClienteTiempo = DateTime.now();

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
