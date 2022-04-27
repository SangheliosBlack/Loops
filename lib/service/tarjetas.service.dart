import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/tarjetas_response.dart';
import 'package:delivery/models/tarjeta_model.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TarjetasService with ChangeNotifier {
  List<Tarjeta> _listaTarjetas = [];

  List<Tarjeta> get listaTarjetas => _listaTarjetas;

  TarjetasService() {
    getTarjetas();
  }

  set listaTarjetas(List<Tarjeta> tarjetas) {
    _listaTarjetas = tarjetas;
    notifyListeners();
  }

  void getTarjetas() async {
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/stripe/obtenerTarjetas'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final tarjetas = tarjetasResponseFromJson(resp.body);

      listaTarjetas = tarjetas.paymentMethods.data;
    } catch (e) {
      debugPrint('error');
    }
  }

  Future<bool> eliminarMetodoPago({required String id}) async {
    final data = {"paymentMethodID": id};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/stripe/eliminarMetodoPago'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        listaTarjetas.removeWhere(
          (element) => element.id == id,
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> newPaymentMethod(
      {required String card,
      required String cardExpMonth,
      required String cardExpYear,
      required String cardCvc}) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final data = {
        "card": card,
        "cardExpMonth": cardExpMonth,
        "cardExpYear": cardExpYear,
        "cardCvc": cardCvc
      };

      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/stripe/nuevoMetodo'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      if (resp.statusCode == 200) {
        final tarjeta = tarjetaFromJson(resp.body);
        listaTarjetas.insert(0, tarjeta);
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
