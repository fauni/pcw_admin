// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.id,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.nombres,
    this.email,
    this.username,
    this.password,
    this.auth,
  });

  String? id;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? nombres;
  String? email;
  String? username;
  String? password;
  bool? auth;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        nombres: json["nombres"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        auth: json["auth"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "nombres": nombres,
        "email": email,
        "username": username,
        "password": password,
        "auth": auth,
      };
}
