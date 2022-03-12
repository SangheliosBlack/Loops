import 'dart:convert';

import 'package:delivery/global/enviroment.dart';
import 'package:http/http.dart' as http;

class TwilioService {
  TwilioService._privateConstructor();
  static final TwilioService _instace = TwilioService._privateConstructor();
  factory TwilioService() {
    return _instace;
  }

  Future<bool> enviarSms(String numero, String hash) async {
    final data = {'to': numero, 'hash': hash};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/twilio/enviarSMS'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
          });
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> confirmarSms(String numero, String codigo) async {
    final data = {'to': numero, 'code': codigo};
    try {
      final resp = await http.post(
          Uri.parse('${Statics.apiUrl}/twilio/verificarSms'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
          });
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
 
}
