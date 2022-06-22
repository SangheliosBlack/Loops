import 'dart:convert';

import 'package:equatable/equatable.dart';

Avatar avatarFromJson(String str) => Avatar.fromJson(json.decode(str));

String avatarToJson(Avatar data) => json.encode(data.toJson());

// ignore: must_be_immutable
class Avatar extends Equatable {
  Avatar({
    required this.accesorio,
    required this.rostro,
    required this.barba,
    required this.peinado,
  });

  int accesorio;
  int rostro;
  int barba;
  int peinado;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        accesorio: json["accesorio"],
        rostro: json["rostro"],
        barba: json["barba"],
        peinado: json["peinado"],
      );

  Map<String, dynamic> toJson() => {
        "accesorio": accesorio,
        "rostro": rostro,
        "barba": barba,
        "peinado": peinado,
      };

  @override
  List<Object?> get props => [accesorio, rostro, barba, peinado];
}
