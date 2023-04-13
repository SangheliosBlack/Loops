import 'dart:convert';

import 'package:delivery/models/cesta.dart';
import 'package:delivery/models/tienda.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

class Usuario {
  Usuario(
      {required this.codigo,
      required this.online,
      required this.direcciones,
      required this.correo,
      required this.nombreUsuario,
      required this.nombre,
      required this.socio,
      required this.createdAt,
      required this.updatedAt,
      required this.uid,
      this.profilePhotoKey,
      required this.negocios,
      required this.numeroCelular,
      required this.customerID,
      required this.nombreCodigo,
      required this.idCodigo,
      required this.dialCode,
      required this.repartidor,
      required this.ultimaTarea,
      this.fix,
      required this.onlineRepartidor,
      required this.transito,
      required this.hibrido,
      required this.cesta});
  bool online;
  List<dynamic> direcciones;
  String correo;
  String nombreUsuario;
  String nombre;
  String codigo;
  bool socio;
  bool? fix;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;
  String? profilePhotoKey;
  String numeroCelular;
  String customerID;
  Cesta cesta;
  String nombreCodigo;
  String idCodigo;
  String dialCode;
  List<Tienda> negocios;
  bool repartidor;
  DateTime ultimaTarea;
  bool transito;
  bool onlineRepartidor;
  bool hibrido;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        onlineRepartidor: json['online_repartidor'],
        online: json["online"],
        dialCode: json["dialCode"],
        direcciones: List<dynamic>.from(json["direcciones"].map((x) => x)),
        correo: json["correo"],
        transito: json["transito"],
        nombreUsuario: json["nombre_usuario"],
        nombre: json["nombre"],
        ultimaTarea: DateTime.parse(json["ultima_tarea"]),
        socio: json["socio"],
        repartidor: json["repartidor"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"] ?? json["_id"],
        profilePhotoKey: json["profilePhotoKey"] ?? "",
        numeroCelular: json['numero_celular'],
        customerID: json['customer_id'],
        cesta: Cesta.fromJson(json['cesta']),
        codigo: json['codigo'] ?? '',
        nombreCodigo: json['nombreCodigo'] ?? "",
        idCodigo: json['idCodigo'] ?? "",
        negocios:
            List<Tienda>.from(json["negocios"].map((x) => Tienda.fromJson(x))),
        hibrido: json['hibrido'] ?? false);
  }
}

class TiendaPrev {
  TiendaPrev({required this.nombre, required this.uid, required this.imagen});

  String nombre;
  String uid;
  String imagen;

  factory TiendaPrev.fromJson(Map<String, dynamic> json) => TiendaPrev(
      nombre: json['nombre'],
      uid: json['uid'] ?? json['_id'],
      imagen: json['imagen'] ?? json['imagen_perfil']);
}
