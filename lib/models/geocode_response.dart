// To parse this JSON data, do
//
//     final geocodeResponse = geocodeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:delivery/models/geocode.dart';

GeocodeResponse geocodeResponseFromJson(String str) => GeocodeResponse.fromJson(json.decode(str));

String geocodeResponseToJson(GeocodeResponse data) => json.encode(data.toJson());

class GeocodeResponse {
    GeocodeResponse({
        required this.results,
        required this.status,
    });

    List<Geocode> results;
    String status;

    factory GeocodeResponse.fromJson(Map<String, dynamic> json) => GeocodeResponse(
        results: List<Geocode>.from(json["results"].map((x) => Geocode.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
    };
}







