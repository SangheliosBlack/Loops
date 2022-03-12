// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
    ErrorResponse({
        required this.ok,
        required this.errores,
    });

    bool ok;
    List<Errore> errores;

    factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        ok: json["ok"],
        errores: List<Errore>.from(json["errores"].map((x) => Errore.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "errores": List<dynamic>.from(errores.map((x) => x.toJson())),
    };
}

class Errore {
    Errore({
        this.value, 
        required this.msg,
        required this.param,
        required this.location,
    });

    String? value;
    String msg;
    String param;
    String location;

    factory Errore.fromJson(Map<String, dynamic> json) => Errore(
        value: json["value"] ?? "" ,
        msg: json["msg"],
        param: json["param"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "msg": msg,
        "param": param,
        "location": location,
    };
}
