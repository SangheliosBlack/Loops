import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider  {
  

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

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
      String argumento = 'no-data';

      if (Platform.isAndroid) {
        argumento = event.data['comida'] ?? 'no-data';
      }

      _mensajesStreamController.sink.add(argumento);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String argumento = 'no-data';

      if (Platform.isAndroid) {
        argumento = event.data['comida'] ?? 'no-data';
      }

      _mensajesStreamController.sink.add(argumento);
    });
  }
}
