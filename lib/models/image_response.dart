// To parse this JSON data, do
//
//     final imageRespomse = imageRespomseFromJson(jsonString);

import 'dart:convert';

ImageRespomse imageRespomseFromJson(String str) => ImageRespomse.fromJson(json.decode(str));

String imageRespomseToJson(ImageRespomse data) => json.encode(data.toJson());

class ImageRespomse {
    ImageRespomse({
        required this.ok,
        required this.url,
    });

    bool ok;
    String url;

    factory ImageRespomse.fromJson(Map<String, dynamic> json) => ImageRespomse(
      ok: json["ok"],
      url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "url": url,
    };
}
