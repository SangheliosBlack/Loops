// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/cupertino.dart';

class PutoDial with ChangeNotifier {
  String _dial = '';

  String get dial => _dial;

  set dial(String dial) {
    _dial = dial;
  }
}
