// To parse this JSON data, do
//
//     final notificacion = notificacionFromJson(jsonString);

import 'dart:convert';

Notificacion notificacionFromJson(String str) =>
    Notificacion.fromJson(json.decode(str));

String notificacionToJson(Notificacion data) => json.encode(data.toJson());

class Notificacion {
  Notificacion({
    this.titulo,
    this.mensaje,
    this.cliente,
    this.idReserva,
  });

  String? titulo;
  String? mensaje;
  String? cliente;
  String? idReserva;

  factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
        titulo: json["titulo"],
        mensaje: json["mensaje"],
        cliente: json["cliente"],
        idReserva: json["id_reserva"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "mensaje": mensaje,
        "cliente": cliente,
        "id_reserva": idReserva,
      };
}
