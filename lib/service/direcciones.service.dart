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

  Future<bool> direccionPredeterminada(
      {required String id, required String estado}) async {
    final data = {'id': id, 'estado': estado};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/direcciones/predeterminada'),
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

  calcularFavorito({required String id, required bool estado}) async {
    final actual = direcciones.indexWhere((element) => element.predeterminado);
    final nuevo = direcciones.indexWhere((element) => element.id == id);
    final estadoInverso = !estado;
    if (estadoInverso) {
      if (actual != -1) {
        direcciones[actual].predeterminado = false;
      }
      direcciones[nuevo].predeterminado = true;
    } else {
      direcciones[nuevo].predeterminado = false;
    }

    notifyListeners();

    final data = {
      'id': id,
      'estado': estadoInverso,
      'actual': actual != -1 ? direcciones[actual].id : 'NA'
    };

    try {
      await http.post(Uri.parse('${Statics.apiUrl}/direcciones/predeterminada'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      // ignore: empty_catches
    } catch (e) {}
  }

  int direccionFavorita() {
    if (direcciones.isEmpty) {
      return 0;
    } else {
      final busqueda =
          direcciones.indexWhere((element) => element.predeterminado);
      if (busqueda != -1) {
        return 0;
      } else {
        return busqueda;
      }
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
