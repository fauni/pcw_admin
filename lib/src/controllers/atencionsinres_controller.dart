import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/cliente.dart';
import 'package:pcw_admin/src/models/reserva.dart';
import 'package:pcw_admin/src/models/servicio.dart';
import 'package:pcw_admin/src/models/vehiculoa.dart';
import 'package:pcw_admin/src/repository/cliente_repository.dart';
import 'package:pcw_admin/src/repository/reserva_repository.dart';
import 'package:pcw_admin/src/repository/servicio_repository.dart';
import 'package:pcw_admin/src/repository/vehiculo_repository.dart';

class AtencionsinresController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;

  Map<String, dynamic> reservaCompleta = {
    "vehiculo": "",
    "servicios": "",
    "fecha": ""
  };

  String placa = '';
  String inputSearch = '';

  bool loading = false;

  double precioFinal = 0;
  List<Cliente> lclientes = [];
  late Cliente clienteSel = new Cliente();

  List<Servicio> lservicios = [];
  List<Servicio> lserviciosElegidos = [];

  VehiculoA vehiculoElegido = new VehiculoA();

  AtencionsinresController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    setClienteElegido('');
  }
  void listarClientes(String placa) async {
    final Stream<List<Cliente>> stream = await obtenerClientesXPlaca(placa);
    stream.listen((List<Cliente> _clientes) {
      lclientes = _clientes;
      print("***************");
      print(jsonEncode(lclientes));
      setState(() {});
    }, onError: (a) {
      scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text('ocurrio un error al obtener clientes')));
    }, onDone: () {});
  }

//obtiene vehiculo dado cliente y placa
  void obtenerVehiculoXcliPlaca(String idcli, String placa,
      {String? message}) async {
    final Stream<List<VehiculoA>> stream =
        await obtenerVehiculoByIdClientePlaca(idcli, placa);
    stream.listen((List<VehiculoA> _vehiculos) {
      setState(() {
        _vehiculos.forEach((vehiculoItem) {
          vehiculoElegido = vehiculoItem;
        });

        print("***************");
        print(jsonEncode(vehiculoAToJson(vehiculoElegido)));
      });
    }, onError: (a) {
      scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text('ocurrio un error al obtener vehiculos')));
    }, onDone: () {});
  }

  //obtener servicios
  void listarServicios() async {
    final Stream<List<Servicio>> stream = await obtenerServicios();
    stream.listen((List<Servicio> _servicios) {
      setState(() {
        lservicios = _servicios;
        print("***************");
        print(jsonEncode(lservicios));
      });
    }, onError: (a) {
      scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text('ocurrio un error al obtener servicios')));
    }, onDone: () {});
  }

  //sumatoria de precios
  void sumarPrecios() {
    double precio = 0;
    for (Servicio item in this.lservicios) {
      if (item.esSeleccionado!) {
        switch (this.vehiculoElegido.tamanio) {
          case 'M':
            precio += double.parse(item.precioM!);
            break;
          case 'L':
            precio += double.parse(item.precioL!);
            break;
          case 'XL':
            precio += double.parse(item.precioXl!);
            break;
          default:
        }
      }

      this.precioFinal = precio;
    }
  }

  void guardarReserva(BuildContext context) async {
    this.reservaCompleta["vehiculo"] =
        json.decode(vehiculoAToJson(this.vehiculoElegido));

    List<dynamic> lservJson = [];
    for (var itms in this.lservicios) {
      if (itms.esSeleccionado!) {
        lservJson.add(itms.toJson());
      }
    }

    String servString = json.encode(lservJson);
    this.reservaCompleta["servicios"] = json.decode(servString);

    Reserva reserva = new Reserva();

    DateTime now = new DateTime.now();
    reserva.fechaCrea = now.toString();
    reserva.fechaReserva = now.toString().split(' ')[0];
    reserva.horaReserva = now.toString().split(' ')[1].substring(0, 7);

    this.reservaCompleta["fecha"] = json.decode(reservaToJson(reserva));

    this.loading = true;
    setState(() {});
    var respuesta = await registrarReserva(json.encode(this.reservaCompleta));
    print(this.reservaCompleta);
    this.loading = false;
    setState(() {});
    this.scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text('Se agregó correctamente'),
          //backgroundColor: Theme.of(context).hintColor ,
        ));
    Navigator.of(context).pushReplacementNamed('/Main');
  }
}
