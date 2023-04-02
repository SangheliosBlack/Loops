// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/search_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:http/http.dart' as http;

class TrafficService {
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  // ignore: close_sinks
  final StreamController<SearchResponse> _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  final StreamController<Busqueda> _busquedaStreamController =
      StreamController<Busqueda>.broadcast();

  Stream<Busqueda> get busquedaStream => _busquedaStreamController.stream;

  final StreamController<Busqueda> _prendasStreamController =
      StreamController<Busqueda>.broadcast();

  Stream<Busqueda> get prendasStream => _prendasStreamController.stream;

  Future<SearchResponse> getResultadosPorQuery(String busqueda) async {
    final data = {'query': busqueda};

    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/google/busqueda'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      final searchResponse = searchResponseFromJson(resp.body);

      return searchResponse;
    } catch (e) {
      final searchResponse = searchResponseFromJson(e.toString());
      return searchResponse;
    }
  }

  Future<Busqueda> obtenerBusqueda(String busqueda) async {
    final query = {'busqueda': busqueda};
    final resp = await http.post(
        Uri.parse('${Statics.apiUrl}/tiendas/busqueda'),
        body: jsonEncode(query),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final data = busquedaFromJson(resp.body);

    return data;
  }

  Future<Busqueda> obtenerPrendas(String busqueda) async {
    final query = {'busqueda': busqueda};
    final resp = await http.post(
        Uri.parse('${Statics.apiUrl}/tiendas/busquedaPrenda'),
        body: jsonEncode(query),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final data = busquedaFromJson(resp.body);

    return data;
  }

  void killAll() {
    EasyDebounce.cancelAll();
  }

  void getBusquedaPorQuery(String busqueda) async {
    EasyDebounce.debounce('fuck', Duration(milliseconds: 1000), () async {
      final resultados = await obtenerBusqueda(busqueda);
      _busquedaStreamController.add(resultados);
    });
  }

  void getSugerenciasPorQuery(String busqueda) async {
    EasyDebounce.debounce('fuck', Duration(milliseconds: 1600), () async {
      final resultados = await getResultadosPorQuery(busqueda);
      _sugerenciasStreamController.add(resultados);
    });
  }

  void getPrendaPorQuery(String busqueda) async {
    EasyDebounce.debounce('fuck', Duration(milliseconds: 500), () async {
      final resultados = await obtenerPrendas(busqueda);
      _prendasStreamController.add(resultados);
    });
  }
}
