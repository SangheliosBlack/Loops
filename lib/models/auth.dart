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
  });

  bool ok;
  Usuario usuario;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
      );

  
}


