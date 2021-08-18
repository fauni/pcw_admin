import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/vehiculoa.dart';
import 'package:pcw_admin/src/repository/vehiculo_repository.dart';

class VehiculosController extends ControllerMVC {
  GlobalKey<ScaffoldState>? scaffoldKey;
  bool loading = false;
  bool loadingV = false;
  List<VehiculoA> lvehiculos = [];

  VehiculosController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listadoVehiculos(String placa) async {
    loadingV = true;
    final Stream<List<VehiculoA>> stream = await obtenerVehiculosByPlaca(placa);
    stream.listen((List<VehiculoA> _vehiculos) {
      setState(() {
        lvehiculos = _vehiculos;
        // print('****************vehiculos***********');
        // print(jsonEncode(lvehiculos));
      });
      loadingV = false;
    }, onError: (a) {
      loadingV = false;
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {
      loadingV = false;
    });
  }
}
