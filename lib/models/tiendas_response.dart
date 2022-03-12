import 'dart:convert';

import 'package:delivery/models/tienda.dart';

TiendaResponse tiendaResponseFromJson(String str) => TiendaResponse.fromJson(json.decode(str));

String tiendaResponseToJson(TiendaResponse data) => json.encode(data.toJson());

class TiendaResponse {
    TiendaResponse({
       required this.ok,
       required this.tiendas,
    });

    bool ok;
    List<Tienda> tiendas;

    factory TiendaResponse.fromJson(Map<String, dynamic> json) => TiendaResponse(
        ok: json["ok"],
        tiendas: List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "tiendas": List<dynamic>.from(tiendas.map((x) => x.toJson())),
    };
}