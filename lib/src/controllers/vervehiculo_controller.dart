import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/vehiculo_modelo.dart';
import 'package:pcw_admin/src/models/vehiculoa.dart';
import 'package:pcw_admin/src/repository/vehiculo_repository.dart';
import 'package:pcw_admin/src/repository/vehiculomodelo_repository.dart';

class VerVehiculoController extends ControllerMVC {
  GlobalKey<ScaffoldState>? scaffoldKey;
  bool loading = false;
  bool loadingV = false;
  VehiculoA vehiculo = VehiculoA();
  List<VehiculoModelo> modelos = [];
  VerVehiculoController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  // Obtener modelos de vehiculos
  void listarModelosVehiculo() async {
    loading = true;
    final Stream<List<VehiculoModelo>> stream = await obtenerModelosVehiculo();
    stream.listen((List<VehiculoModelo> _modelos) {
      setState(() {
        modelos = _modelos;
        // print("===============================");
        // print(jsonEncode(modelos));
        // print(jsonEncode(carros));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de Internet'),
      ));
    }, onDone: () {
      loading = false;
      setState(() {});
    });
  }

  //registrar modificacion en el servidor
  void guardaEdicionVehiculo(BuildContext context) async {
    this.loading = true;
    this.loadingV = true;
    setState(() {
      //image = null;
    });
    var vehiculoResp = await modificarVehiculo(this.vehiculo);

    this.loading = false;

    this.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Se modifico correctamente'),
          backgroundColor: Theme.of(context).primaryColor,
        ));
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    //print('____ANTES DE ENVIAR___');
    //print(newVehiculo.imgFile);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/Vehiculos', arguments: 3);
  }
}
