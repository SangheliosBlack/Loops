
import 'dart:convert';

ListadoOpcionesTemp listadoOpcionesTempFromJson(String str) => ListadoOpcionesTemp.fromJson(json.decode(str));

String listadoOpcionesTempToJson(ListadoOpcionesTemp data) => json.encode(data.toJson());

class ListadoOpcionesTemp {
    ListadoOpcionesTemp({
        required this.index,
        required this.listado,
    });

    int index;
    List<String> listado;

    factory ListadoOpcionesTemp.fromJson(Map<String, dynamic> json) => ListadoOpcionesTemp(
        index: json["index"],
        listado: List<String>.from(json["listado"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "index": index,
        "listado": List<dynamic>.from(listado.map((x) => x)),
    };
}
