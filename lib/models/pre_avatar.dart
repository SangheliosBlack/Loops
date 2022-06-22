// To parse this JSON data, do
//
//     final preAvatar = preAvatarFromJson(jsonString);

import 'dart:convert';

List<PreAvatar> preAvatarFromJson(String str) =>
    List<PreAvatar>.from(json.decode(str).map((x) => PreAvatar.fromJson(x)));

String preAvatarToJson(List<PreAvatar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PreAvatar {
  PreAvatar({
    required this.largo,
    required this.titulo,
    required this.path,
  });

  int largo;
  String titulo;
  String path;

  factory PreAvatar.fromJson(Map<String, dynamic> json) => PreAvatar(
        largo: json["largo"],
        titulo: json["titulo"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "largo": largo,
        "titulo": titulo,
      };
}
