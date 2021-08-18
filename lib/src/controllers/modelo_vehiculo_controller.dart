import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/vehiculo_modelo.dart';
import 'package:pcw_admin/src/repository/modelo_vehiculo_repository.dart';

class ModeloVehiculoController extends ControllerMVC {
  List<VehiculoModelo> modelos = [];
  List<VehiculoModelo> lmodelos = [];

  List<String> anios = [];
  List<String> marcas = [];

  VehiculoModelo vehiculomodelo =
      new VehiculoModelo(); // Modelo para crear vehiculo

  bool loading = false;
  String search = '';

  GlobalKey<ScaffoldState>? scaffoldKey;

  ModeloVehiculoController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listarModelosVehiculo();
    cargarAnios();
    cargarMarcas();
    //listarCarrosByCliente();
    //obtenerServicio();
  }

  void cargarAnios() {
    this.anios.add('2007');
    this.anios.add('2008');
    this.anios.add('2009');
    this.anios.add('2010');
    this.anios.add('2011');
    this.anios.add('2012');
    this.anios.add('2013');
    this.anios.add('2014');
    this.anios.add('2015');
    this.anios.add('2016');
    this.anios.add('2017');
    this.anios.add('2018');
    this.anios.add('2019');
    this.anios.add('2020');
    this.anios.add('2021');
  }

  void cargarMarcas() {
    this.marcas.add('Toyota');
    this.marcas.add('Volkswagen');
    this.marcas.add('Ford');
    this.marcas.add('Nissan');
    this.marcas.add('Honda');
    this.marcas.add('Hyundai');
    this.marcas.add('Chevrolet');
    this.marcas.add('Kia');
    this.marcas.add('Renault');
    this.marcas.add('Mercedes');
    this.marcas.add('Mazda');
    this.marcas.add('Jeep');
    this.marcas.add('Fiat');
    this.marcas.add('Geely');
    this.marcas.add('Changan');
    this.marcas.add('Mitsubishi');
    this.marcas.add('Suzuki');
  }

  // Obtener modelos de vehiculos
  void listarModelosVehiculo() async {
    final Stream<List<VehiculoModelo>> stream = await obtenerModelosVehiculo();
    stream.listen((List<VehiculoModelo> _modelos) {
      setState(() {
        modelos = _modelos;
        lmodelos = _modelos;
        // print("===============================");
        // print(jsonEncode(modelos));
        // print(jsonEncode(carros));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        //content: Text(S.current.verify_your_internet_connection),
        content: Text('error de conexión'),
      ));
    }, onDone: () {});
  }

  // Obtener modelos de vehiculos
  void buscarModelosVehiculo(String texto) async {
    Stream<List<VehiculoModelo>> stream;
    if (texto.length > 0) {
      stream = await obtenerModelosVehiculoSearch(texto);
    } else {
      stream = await obtenerModelosVehiculo();
    }
    stream.listen((List<VehiculoModelo> _modelos) {
      setState(() {
        modelos = _modelos;
        // print("===============================");
        // print(jsonEncode(modelos));
        // print(jsonEncode(carros));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        //content: Text(S.current.verify_your_internet_connection),
        content: Text('error de conexión'),
      ));
    }, onDone: () {
      // if (message != null) {
      //   scaffoldKey.currentState.showSnackBar(SnackBar(
      //     content: Text(message),
      //   ));
      // }
    });
  }

  // GUARDAR EL MODELO DE VEHICULO
  void registrarModeloVehiculo(BuildContext context) async {
    this.loading = true;
    var vehiculoResp = await guardarModeloVehiculo(vehiculomodelo);
    Navigator.of(context).pop(true);
    this.loading = false;
    this.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Se guardo correctamente!'),
          //backgroundColor: Theme.of(context).hintColor ,
        ));
    setState(() {
      this.listarModelosVehiculo();
    });
  }
}
