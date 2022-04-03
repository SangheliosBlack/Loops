// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:delivery/models/busqueda_response.dart';
import 'package:delivery/models/search_response.dart';
import 'package:delivery/models/traffic_response.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' as http;

class TrafficService {
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = Dio();

  // ignore: close_sinks
  final StreamController<SearchResponse> _sugerenciasStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  final StreamController<Busqueda> _busquedaStreamController =
      StreamController<Busqueda>.broadcast();

  Stream<Busqueda> get busquedaStream => _busquedaStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _apiKey =
      'pk.eyJ1IjoianVsaW9qYW1vbjMwMDAiLCJhIjoiY2t1MDNpOW02M2lzNDJ3bzJvanZpcTIydyJ9.2Anx0T9p97v-j57728PO9g';

  Future<DrivingResponse> getCoordsInicioYFin(
      LatLng? inicio, LatLng? destino) async {
    final coordString =
        '${inicio!.longitude},${inicio.latitude};${destino!.longitude},${destino.latitude}';
    final url = '$_baseUrlDir/mapbox/driving/$coordString';

    final resp = await _dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': _apiKey,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }

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

  void killAll() {
    EasyDebounce.cancelAll();
  }

  void getBusquedaPorQuery(String busqueda) async {
    EasyDebounce.debounce('fuck', Duration(milliseconds: 1600), () async {
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
}
