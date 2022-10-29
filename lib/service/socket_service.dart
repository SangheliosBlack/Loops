// ignore_for_file: library_prefixes

import 'package:delivery/providers/push_notifications_provider.dart';
import 'package:delivery/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: constant_identifier_names
enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    final pushProvider = PushNotificationProvider();

    final tokenFB = await pushProvider.firebaseMessaging.getToken();

    final token = await AuthService.getToken();

    _socket = IO.io('https://server-delivery-production.herokuapp.com', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token, 'token': tokenFB}
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
