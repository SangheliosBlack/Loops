import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/direccion_response.dart';
import 'package:delivery/models/tienda.dart';
import 'package:delivery/models/tiendas_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:http/http.dart' as http;

class ExtrasService {
  Future<Direccion?> getDireccion({required String id}) async {
    try {
      final data = {'uid': id};
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/direcciones/search'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final direccionResponse = direccionResponseFromJson(resp.body);
      return direccionResponse;
    } catch (e) {
      return null;
    }
  }

  Future<Tienda?> agregarNuevaTienda(String nombre) async {
    final data = {'nombre': nombre};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/tiendas/nuevaTienda'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      final tiendasResponse = tiendaResponseFromJson(resp.body);
      return tiendasResponse.tiendas[0];
    } catch (e) {
      return null;
    }
  }

 
  Future<bool> actualizarDireccionIcono(String id, int icono) async {
    try {
      final data = {'direccionUid': id, 'nuevoIcono': icono};
      await http.post(Uri.parse('${Statics.apiUrl}/direcciones/updateIcon'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarTiendaFavorita(String id) async {
    try {
      final data = {'tienda': id};
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/usuarios/modificarTiendaFavorita'),
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

  Future<bool> actualizarDireccionFavorita(String id) async {
    try {
      final data = {'direccionFavorita': id};
      await http.post(
          Uri.parse('${Statics.apiUrl}/usuarios/updateDireccionFavorita'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      return true;
    } catch (e) {
      return false;
    }
  }
}
