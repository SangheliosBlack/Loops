import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/direccion_response.dart';
import 'package:delivery/models/direcciones_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class DireccionesService with ChangeNotifier {
  int _direccionPredeterminada = 0;

  int get direccionPredeterminada => _direccionPredeterminada;

  set direccionPredeterminada(int valor) {
    _direccionPredeterminada = valor;
    notifyListeners();
  }

  List<Direccion> _direcciones = [];

  List<Direccion> get direcciones => _direcciones;

  set direcciones(List<Direccion> direcciones) {
    _direcciones = direcciones;

    notifyListeners();
  }

  int _value = 100000;

  int get value => _value;

  set value(int value) {
    _value = value;
    notifyListeners();
  }

  DireccionesService() {
    getDirecciones();
  }

  Future cambiarDireccionIcono(int icono, int index) async {
    _direcciones[index].icono = icono;
    notifyListeners();
  }

  Future<bool> agregarNuevaDireccion(
      String texto, String descripcion, double latitud, double longitud,bool predeterminado) async {
    final data = {
      "latitud": latitud,
      "longitud": longitud,
      "texto": texto,
      "descripcion": descripcion,
      "titulo": "Casa",
      "icono": 58890,
      "predeterminado":predeterminado
    };

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/direcciones/nuevaDireccion'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final direccion = direccionesResponseFromJson(resp.body);

      direcciones.insert(direcciones.length, direccion.direcciones[0]);

      direccionPredeterminada = 0;

      notifyListeners();

      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  getDirecciones() async {
    try {
      final resp = await http.get(Uri.parse('${Statics.apiUrl}/direcciones'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final direccionesResponse = direccionesResponseFromJson(resp.body);
      direcciones = direccionesResponse.direcciones;

      try {
        final busqueda =
            direcciones.indexWhere((element) => element.predeterminado);
        direccionPredeterminada = busqueda;
      } catch (e) {
        direccionPredeterminada = 0;
      }
      return direccionesResponse.direcciones;
    } catch (e) {
      return null;
    }
  }
}
