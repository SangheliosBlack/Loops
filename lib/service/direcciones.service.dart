import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/direccion.dart';
import 'package:delivery/models/direcciones_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class DireccionesService with ChangeNotifier {
  List<Direccion> _direcciones = [];

  List<Direccion> get direcciones => _direcciones;

  set direcciones(List<Direccion> direcciones) {
    _direcciones = direcciones;

    notifyListeners();
  }

  DireccionesService() {
    getDirecciones();
  }

  Future<bool> agregarNuevaDireccion(
      {required String id,
      required double latitud,
      required longitud,
      required String titulo}) async {
    final data = {
      "id": id,
      "latitud": latitud,
      "longitud": longitud,
      "titulo": titulo
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

  Future<bool> eliminarDireccion({required String id}) async {
    final data = {'id': id};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/direcciones/eliminar'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        direcciones.removeWhere((element) => element.id == id);
        notifyListeners();
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

      return direccionesResponse.direcciones;
    } catch (e) {
      return null;
    }
  }
}
