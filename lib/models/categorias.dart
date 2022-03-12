
import 'dart:convert';

List<String> categoriasFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String categoriasToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
