// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names, prefer_conditional_assignment

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
    SearchResponse({
        required this.type,
        required this.query,
        required this.features,
        required this.attribution,
    });

    String type;
    List<String> query;
    List<Feature> features;
    String attribution;

    factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
    };
}

class Feature {
    Feature({
        required this.id,
        required this.type,
        required this.placeType,
        required this.relevance,
        required this.properties,
        required this.textEs,
        required this.languageEs,
        required this.placeNameEs,
        required this.text,
        required this.language,
        required this.placeName,
        required this.bbox,
        required this.center,
        required this.geometry,
        required this.context,
    });

    String id;
    String type;
    List<String> placeType;
    double relevance;
    Properties properties;
    String textEs;
    Language ?languageEs;
    String placeNameEs;
    String text;
    Language ?language;
    String placeName;
    List<double> ?bbox;
    List<double> center;
    Geometry geometry;
    List<Context> context;

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
        placeName: json["place_name"],
        bbox: json["bbox"] == null ? null : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "language_es": languageEs == null ? null : languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
    };
}

class Context {
    Context({
        required this.id,
        required this.wikidata,
        required this.shortCode,
        required this.textEs,
        required this.languageEs,
        required this.text,
        required this.language,
    });

    Id ?id;
    Wikidata ?wikidata;
    ShortCode ?shortCode;
    String textEs;
    Language ?languageEs;
    String text;
    Language ?language;

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: idValues.map[json["id"]],
        wikidata: json["wikidata"] == null ? null : wikidataValues.map[json["wikidata"]],
        shortCode: json["short_code"] == null ? null : shortCodeValues.map[json["short_code"]],
        textEs: json["text_es"],
        languageEs: json["language_es"] == null ? null : languageValues.map[json["language_es"]],
        text: json["text"],
        language: json["language"] == null ? null : languageValues.map[json["language"]],
    );

    Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        "short_code": shortCode == null ? null : shortCodeValues.reverse[shortCode],
        "text_es": textEs,
        "language_es": languageEs == null ? null : languageValues.reverse[languageEs],
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
    };
}

enum Id { REGION_9731098207993510, COUNTRY_9933875229773450, POSTCODE_13451690894268070, PLACE_13783066420250260 }

final idValues = EnumValues({
    "country.9933875229773450": Id.COUNTRY_9933875229773450,
    "place.13783066420250260": Id.PLACE_13783066420250260,
    "postcode.13451690894268070": Id.POSTCODE_13451690894268070,
    "region.9731098207993510": Id.REGION_9731098207993510
});

enum Language { ES }

final languageValues = EnumValues({
    "es": Language.ES
});

enum ShortCode { MX_JAL, MX }

final shortCodeValues = EnumValues({
    "mx": ShortCode.MX,
    "MX-JAL": ShortCode.MX_JAL
});

enum Wikidata { Q13160, Q96, Q1962295 }

final wikidataValues = EnumValues({
    "Q13160": Wikidata.Q13160,
    "Q1962295": Wikidata.Q1962295,
    "Q96": Wikidata.Q96
});

class Geometry {
    Geometry({
        required this.type,
        required this.coordinates,
    });

    String type;
    List<double> coordinates;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    Properties({
        required this.wikidata,
        required this.foursquare,
        required this.landmark,
        required this.address,
        required this.category,
    });

    Wikidata ?wikidata;
    String foursquare;
    bool landmark;
    String address;
    String category;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"] == null ? null : wikidataValues.map[json["wikidata"]],
        foursquare: json["foursquare"] ?? '',
        landmark: json["landmark"] ?? false,
        address: json["address"] ?? '',
        category: json["category"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "wikidata": wikidata == null ? null : wikidataValues.reverse[wikidata],
        // ignore: unnecessary_null_comparison
        "foursquare": foursquare,
        // ignore: unnecessary_null_comparison
        "landmark": landmark,
        // ignore: unnecessary_null_comparison
        "address": address,
        // ignore: unnecessary_null_comparison
        "category": category,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        // ignore: unnecessary_null_comparison
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => MapEntry(v, k));
        }
        return reverseMap;
    }
}
