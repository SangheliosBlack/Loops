// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:delivery/models/usuario.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));


class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.usuario,
    required this.token,
    required this.checkToken,
  });

  bool ok;
  Usuario usuario;
  bool checkToken;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"], checkToken: json["checkToken"],
      );

  
}


