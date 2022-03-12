import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult {
  final bool cancelo;
  final bool manual;
  final LatLng position;
  final String nombreDestino;
  final String descripcion;

  SearchResult({this.descripcion = '', required this.cancelo, this.manual = false ,  this.position =  const LatLng(21.377222000000003,-101.92916700000002)  , this.nombreDestino = ''});


  
}
