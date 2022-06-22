import 'dart:convert';

CodigoResponse codigoResponseFromJson(String str) => CodigoResponse.fromJson(json.decode(str));

String codigoResponseToJson(CodigoResponse data) => json.encode(data.toJson());

class CodigoResponse {
    CodigoResponse({
        required this.ok,
        required this.usuario,
        required this.id,
        required this.msg,
    });

    bool ok;
    String usuario;
    String id;
    String msg;

    factory CodigoResponse.fromJson(Map<String, dynamic> json) => CodigoResponse(
        ok: json["ok"],
        usuario: json["usuario"],
        id: json["id"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario,
        "id": id,
        "msg": msg,
    };
}
