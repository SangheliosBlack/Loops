
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocalStorage {

  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
     WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
  }

}
