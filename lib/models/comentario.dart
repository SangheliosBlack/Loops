// To parse this JSON data, do
//
//     final comentario = comentarioFromJson(jsonString);

import 'dart:convert';

Comentario comentarioFromJson(String str) => Comentario.fromJson(json.decode(str));

String comentarioToJson(Comentario data) => json.encode(data.toJson());

class Comentario {
    Comentario({
        required this.id,
        required this.usuario,
        required this.comentario,
        required this.encabezado,
        required this.eliminado,
        required this.calificacion,
        required this.reacciones,
        required this.destacado,
        required this.subRespuesta,
    });

    String id;
    String usuario;
    String comentario;
    String encabezado;
    bool eliminado;
    double calificacion;
    int reacciones;
    bool destacado;
    bool subRespuesta;

    factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
        id: json["_id"],
        usuario: json["usuario"],
        comentario: json["comentario"],
        encabezado: json["encabezado"],
        eliminado: json["eliminado"],
        calificacion: json["calificacion"].toDouble(),
        reacciones: json["reacciones"],
        destacado: json["destacado"],
        subRespuesta: json["sub_respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "usuario": usuario,
        "comentario": comentario,
        "encabezado": encabezado,
        "eliminado": eliminado,
        "calificacion": calificacion,
        "reacciones": reacciones,
        "destacado": destacado,
        "sub_respuesta": subRespuesta,
    };
}
