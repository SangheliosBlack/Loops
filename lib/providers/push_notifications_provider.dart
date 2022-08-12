import 'dart:async';
import 'dart:convert';

import 'package:delivery/models/firebase_socket.dart';
import 'package:delivery/models/venta_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _mensajesStreamController =
      StreamController<FirebaseSocket>.broadcast();
  Stream<FirebaseSocket> get mensajes => _mensajesStreamController.stream;

  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  initNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        alert: true,
        sound: true);

    settings;

    FirebaseMessaging.onMessage.listen((event) {
      final mensaje = FirebaseSocket(
          evento: event.data['evento'],
          pedido: PedidoProducto.fromJson(json.decode(event.data['pedido'])));

      _mensajesStreamController.sink.add(mensaje);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final mensaje = FirebaseSocket(
          evento: event.data['evento'],
          pedido: PedidoProducto.fromJson(json.decode(event.data['pedido'])));

      _mensajesStreamController.sink.add(mensaje);
    });
  }
}
