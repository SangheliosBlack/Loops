// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class _NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "GLOBAL MAIN");

  Future navigateTo(String routName) {
    return navigatorKey.currentState!.pushNamed(routName);
  }

  Future navigateToReplace(String routName) {
    return navigatorKey.currentState!.popAndPushNamed(routName);
  }

  Future navegarDraw({required String ruta}) {
    return navigatorKey.currentState!.pushNamed(ruta);
  }

  Future customNavigateTo(int index) {
    switch (index) {
      case 0:
        return navigatorKey.currentState!.pushNamed('/dashboard');
      case 1:
        return navigatorKey.currentState!.pushNamed('/dashboard/order');
      case 2:
        return navigatorKey.currentState!.pushNamed('/dashboard/favorites');
      case 3:
        return navigatorKey.currentState!.pushNamed('/dashboard/settings');
      case 4:
        return navigatorKey.currentState!
            .pushNamed('/dashboard/addNewStoreRoute');
      case 5:
        return navigatorKey.currentState!
            .pushNamed('/dashboard/addNewStoreRoute');

      default:
        return navigatorKey.currentState!
            .pushNamed('/dashboard/permissionRoute');
    }
  }

  void goBack(String routName) {
    return navigatorKey.currentState!.pop();
  }
}

final navigationService = new _NavigatorService();
