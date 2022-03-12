import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

class Usuario {
    Usuario({
        required this.online,
        required this.direcciones,
        required this.tienda,
        required this.correo,
        required this.nombreUsuario,
        required this.nombre,
        required this.socio,
        required this.createdAt,
        required this.updatedAt,
        required this.uid,
        this.profilePhotoKey,
        this.numeroCelular
    });

    bool online;
    List<dynamic> direcciones;
    String ?tienda;
    String correo;
    String nombreUsuario;
    String nombre;
    bool socio;
    DateTime createdAt;
    DateTime updatedAt;
    String uid;
    String? profilePhotoKey;
    String? numeroCelular;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        direcciones: List<dynamic>.from(json["direcciones"].map((x) => x)),
        tienda: json["tienda"] ?? "",
        correo: json["correo"],
        nombreUsuario: json["nombre_usuario"],
        nombre: json["nombre"],
        socio: json["socio"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
        profilePhotoKey: json["uid"] ?? "",
        numeroCelular: json['numeroCelular'] ?? "" 
    );
    
}
