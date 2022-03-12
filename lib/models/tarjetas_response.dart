
import 'dart:convert';

import 'package:delivery/models/tarjeta_model.dart';

TarjetasResponse tarjetasResponseFromJson(String str) => TarjetasResponse.fromJson(json.decode(str));

String tarjetasResponseToJson(TarjetasResponse data) => json.encode(data.toJson());

class TarjetasResponse {
    TarjetasResponse({
        required this.paymentMethods,
    });

    PaymentMethods paymentMethods;

    factory TarjetasResponse.fromJson(Map<String, dynamic> json) => TarjetasResponse(
        paymentMethods: PaymentMethods.fromJson(json["paymentMethods"]),
    );

    Map<String, dynamic> toJson() => {
        "paymentMethods": paymentMethods.toJson(),
    };
}

class PaymentMethods {
    PaymentMethods({
        required this.object,
        required this.data,
        required this.hasMore,
        required this.url,
    });

    String object;
    List<Tarjeta> data;
    bool hasMore;
    String url;

    factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
        object: json["object"],
        data: List<Tarjeta>.from(json["data"].map((x) => Tarjeta.fromJson(x))),
        hasMore: json["has_more"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "has_more": hasMore,
        "url": url,
    };
}


