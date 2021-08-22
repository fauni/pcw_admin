import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/detalle_reserva.dart';
import 'package:pcw_admin/src/models/reserva.dart';
import 'package:pcw_admin/src/models/reserva_inner.dart';
import 'package:pcw_admin/src/repository/reserva_repository.dart';

import '../repository/user_repository.dart';

class ReservaController extends ControllerMVC {
  Reserva? reserva;
  List<Reserva> lreservas = [];
  List<ReservaInner> reservasInner = [];

  List<DetalleReserva> ldetalleReserva = []; // Listado de detalle de reserva

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  ReservaController() {
    // listarReservas();
    listarReservasInnerCurrent();
  }

  String rutaImg(String nombre) {
    return getRutaImg(nombre);
  }

  //listar reservas de hoy
  void listarReservas({BuildContext? context, String? message}) async {
    FocusScope.of(context!).unfocus();

    final Stream<List<Reserva>> stream = await obtenerReservasdeHoy();
    stream.listen((List<Reserva> _reservas) {
      setState(() {
        lreservas = _reservas;
        // print("===============================");
        // // //print(carros);
        // print(jsonEncode(lreservas));
      });
    }, onError: (a) {
      // loader.remove();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ocurrio un error al obtener las reservas'),
      ));
    }, onDone: () {
      // Helper.hideLoader(loader);
      if (message != null) {
        scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  //listar reservas para mostrar
  Future<void> listarReservasInnerCurrent(
      {BuildContext? context, String? message}) async {
    // FocusScope.of(context).unfocus();
    // Overlay.of(context).insert(loader);

    final Stream<List<ReservaInner>> stream =
        await obtenerReservasInnerCurrent();
    stream.listen((List<ReservaInner> _reservas) {
      setState(() {
        if (currentUser.value.email == null) {
          Navigator.of(context!).pushNamed('/Login');
        }
        reservasInner = _reservas;
        print('actualizado');

        for (var item in reservasInner) {
          print(json.encode(item));
        }

      });
    }, onError: (a) {
      // loader.remove();
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Ocurrio un error al obtener reservas'),
      ));
    }, onDone: () {
      // Helper.hideLoader(loader);
      if (message != null) {
        scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  //listar reservas para mostrar
  void listadoDetalleReservaPorId(String id_reserva) async {
    final Stream<List<DetalleReserva>> stream =
        await obtenerDetalleReservaPorId(id_reserva);
    stream.listen((List<DetalleReserva> _detallereserva) {
      setState(() {
        ldetalleReserva = _detallereserva;
        // print("===============================");
        // //print(carros);
        // print(jsonEncode(ldetalleReserva));
      });
    }, onError: (a) {
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {});
  }

  Future<void> refreshHome() async {
    setState(() {
      reservasInner = <ReservaInner>[];
    });
    await listarReservasInnerCurrent();
  }
}
