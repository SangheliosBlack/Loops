import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivery/global/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  late GoogleMapController _mapController;

  Polyline _miRuta = const Polyline(polylineId: PolylineId('mi_ruta'), width: 4,color: Colors.transparent);

  Polyline _miRutaDestino = const Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    width: 4,
    color: Colors.black87,
  );

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      _mapController = controller;
      _mapController.setMapStyle(Statics.mapStyle);
      add(OnMapaListo());
    } else {
      _mapController = controller;
      _mapController.setMapStyle(Statics.mapStyle);
      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController.animateCamera(cameraUpdate);
  }

  Stream<MapaState> mapEventToState( MapaEvent event ) async* {
    
    if ( event is OnMapaListo ) {
      yield state.copyWith( mapaListo: true );

    } else if ( event is OnNuevaUbicacion ) {
      yield* _onNuevaUbicacion( event );

    } else if ( event is OnMarcarRecorrido ) {
      yield* _onMarcarRecorrido( event );

    } else if ( event is OnSeguirUbicacion ) {
      yield* _onSeguirUbicacion( event );

    } else if ( event is OnMovioMapa ) {
      yield state.copyWith( ubicacionCentral: event.centroMapa );

    } else if ( event is OnCrearRutaInicioDestino ) {
      yield* _onCrearRutaInicioDestino( event );
    }

  }
  
  Stream<MapaState> _onNuevaUbicacion( OnNuevaUbicacion event ) async* {

    if ( state.seguirUbicacion ) {
      moverCamara( event.ubicacion );
    }


    final points = [ ..._miRuta.points, event.ubicacion ];
    _miRuta = _miRuta.copyWith( pointsParam: points );

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;

    yield state.copyWith( polylines: currentPolylines );

  }

  Stream<MapaState> _onMarcarRecorrido( OnMarcarRecorrido event ) async* {

    if ( !state.dibujarRecorrido ) {
      _miRuta = _miRuta.copyWith( colorParam: Colors.black87 );
    } else {
      _miRuta = _miRuta.copyWith( colorParam: Colors.transparent );
    }

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;

    yield state.copyWith( 
      dibujarRecorrido: !state.dibujarRecorrido,
      polylines: currentPolylines
    );

  }

  Stream<MapaState> _onSeguirUbicacion( OnSeguirUbicacion event ) async* {

    if ( !state.seguirUbicacion ) {
      moverCamara( _miRuta.points[ _miRuta.points.length - 1 ] );
    }
    yield state.copyWith( seguirUbicacion: !state.seguirUbicacion );
  }

  Stream<MapaState> _onCrearRutaInicioDestino( OnCrearRutaInicioDestino event ) async* {

    _miRutaDestino = _miRutaDestino.copyWith(
      pointsParam: event.rutaCoordenadas
    );

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = _miRutaDestino;


    yield state.copyWith(
      polylines: currentPolylines,
    );
  }

}
