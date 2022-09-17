// To parse this JSON data, do
//
//     final ruta = rutaFromJson(jsonString);

import 'dart:convert';

Ruta rutaFromJson(String str) => Ruta.fromJson(json.decode(str));

String rutaToJson(Ruta data) => json.encode(data.toJson());

class Ruta {
    Ruta({
        required this.id,
        required this.bounds,
        required this.overviewPolyline,
        required this.distance,
        required this.duration,
    });

    String id;
    Bounds bounds;
    OverviewPolyline overviewPolyline;
    Distance distance;
    Distance duration;

    factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
        id: json["_id"],
        bounds: Bounds.fromJson(json["bounds"]),
        overviewPolyline: OverviewPolyline.fromJson(json["overview_polyline"]),
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "bounds": bounds.toJson(),
        "overview_polyline": overviewPolyline.toJson(),
        "distance": distance.toJson(),
        "duration": duration.toJson(),
    };
}

class Bounds {
    Bounds({
        required this.northeast,
        required this.southwest,
    });

    Northeast northeast;
    Northeast southwest;

    factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
        northeast: Northeast.fromJson(json["northeast"]),
        southwest: Northeast.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
    };
}

class Northeast {
    Northeast({
        required this.lat,
        required this.lng,
    });

    double lat;
    double lng;

    factory Northeast.fromJson(Map<String, dynamic> json) => Northeast(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class Distance {
    Distance({
        required this.text,
        required this.value,
    });

    String text;
    int value;

    factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
    };
}

class OverviewPolyline {
    OverviewPolyline({
        required this.points,
    });

    String points;

    factory OverviewPolyline.fromJson(Map<String, dynamic> json) => OverviewPolyline(
        points: json["points"],
    );

    Map<String, dynamic> toJson() => {
        "points": points,
    };
}
