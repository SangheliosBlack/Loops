part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;

  final LatLng? ubicacionCentral;

  final Map<String, Polyline> polylines;

  MapaState(
      {this.seguirUbicacion = false,this.mapaListo = false,
      this.dibujarRecorrido = true,
      this.ubicacionCentral,
      Map<String, Polyline>? polylines})
      : polylines = polylines ?? {};

  MapaState copyWith(
          {bool? seguirUbicacion,bool? mapaListo,
          bool? dibujarRecorrido,
          LatLng ?ubicacionCentral,
          Map<String, Polyline>? polylines}) =>
      MapaState(
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        mapaListo: mapaListo ?? this.mapaListo,
        polylines: polylines ?? this.polylines,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
      );
}
