import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcw_admin/src/models/cliente.dart';
import 'package:pcw_admin/src/models/tipo_vehiculo.dart';
import 'package:pcw_admin/src/models/vehiculo.dart';
import 'package:pcw_admin/src/models/vehiculo_modelo.dart';
import 'package:pcw_admin/src/models/vehiculoa.dart';
import 'package:pcw_admin/src/repository/cliente_repository.dart';
import 'package:pcw_admin/src/repository/modelo_vehiculo_repository.dart';
import 'package:pcw_admin/src/repository/servicio_repository.dart';
import 'package:pcw_admin/src/repository/tipo_vehiculo_repository.dart';
import 'package:pcw_admin/src/repository/vehiculo_repository.dart';

class CarroController extends ControllerMVC {
  List<Vehiculo> carros = [];
  List<VehiculoA> vehiculos = [];
  List<VehiculoModelo> modelos = [];
  List<TipoVehiculo> tipos = [];
  List<Cliente> clientes = [];

  List<String> anios = [];
  List<String> marcas = [];

  VehiculoModelo vehiculomodelo = new VehiculoModelo();

  VehiculoA? vehiculoElegido;
  String servicio = '';

  File? image;
  final picker = ImagePicker();
  bool isCapture = false;
  bool loading = false;

  GlobalKey<ScaffoldState>? scaffoldKey;

  CarroController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listarClientes();
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

  Future getImage(int tipo) async {
    if (tipo == 1) {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxWidth: 300.0, maxHeight: 300.0);
      setState(() {
        image = File(pickedFile!.path);
      });
    } else {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 300.0, maxHeight: 300.0);
      setState(() {
        if (pickedFile != null) image = File(pickedFile.path);
      });
    }
  }

  void obtenerServicio() async {
    this.servicio = await getServicio();
  }

  // Obtener tipos de vehiculos
  void listarTipoVehiculo() async {
    final Stream<List<TipoVehiculo>> stream = await obtenerTipoVehiculo();
    stream.listen((List<TipoVehiculo> _data) {
      setState(() {
        tipos = _data;
        // print("===============================");
        // print(jsonEncode(tipos));
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
  void listarModelosVehiculo() async {
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
        content: Text('error de conexión'),
      ));
    }, onDone: () {});
  }

  void listarCarrosByIdCli() async {
    final Stream<List<Vehiculo>> stream = await obtenerVehiculos();
    stream.listen((List<Vehiculo> _productos) {
      setState(() {
        carros = _productos;
        // print("===============================");
        // //print(carros);
        // print(jsonEncode(carros));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        //content: Text(S.current.verify_your_internet_connection),
        content: Text('error de conexión'),
      ));
    }, onDone: () {});
  }

  void eligeVehiculo(BuildContext context, VehiculoA vehiculo) async {
    this.vehiculoElegido = vehiculo;
    String strVehiculo = vehiculoAToJson(vehiculo);
    setVehiculo(strVehiculo);
    Navigator.pop(context);
    // print('_________en string____________');
    // print(await getVehiculo());
  }

  //registrar en servidor
  void registrarVehiculo(BuildContext context, Vehiculo newVehiculo) async {
    if (this.image == null) {
      this.scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('Agregue una imagen por favor'),
            //backgroundColor: Theme.of(context).hintColor ,
          ));
    } else {
      String base64Image = base64Encode(this.image!.readAsBytesSync());
      String fileName = this.image!.path.split("/").last;
      newVehiculo.foto = fileName;
      newVehiculo.imgFile = base64Image;
      newVehiculo.idCliente = await getClienteElegido();

      this.loading = true;
      setState(() {
        image = null;
      });
      var vehiculoResp = await guardarVehiculo(newVehiculo);

      this.loading = false;
      this.scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('Se agregó correctamente'),
            //backgroundColor: Theme.of(context).hintColor ,
          ));
      setState(() {});

      //print('____ANTES DE ENVIAR___');
      //print(newVehiculo.imgFile);
    }
    Navigator.of(context).pop();
    //Navigator.of(context).pop();
    //Navigator.of(context).pushNamed('/Vehiculo', arguments: 3);
  }

  String RutaImg(String nombre) {
    return getRutaImg(nombre);
  }

  // Obtener todos los clientes
  void listarClientes() async {
    final Stream<List<Cliente>> stream = await obtenerTodosClientes();
    stream.listen((List<Cliente> _data) {
      setState(() {
        clientes = _data;
        // print("===============================");
        print(jsonEncode(clientes));
        // print(jsonEncode(carros));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        //content: Text(S.current.verify_your_internet_connection),
        content: Text('error de conexión'),
      ));
    }, onDone: () {});
  }

  void mostrar_mensaje(message) {
    this.scaffoldKey?.currentState?.showSnackBar(new SnackBar(
          //content: Text(S.current.verify_your_internet_connection),
          content: Text(message),
        ));
  }

  // Informaciion sobre tipod e vehiculo
  informacionConfirmacion(BuildContext context, titulo, mensaje) {
    Widget continueButton = FlatButton(
      child: Text("Cerrar"),
      onPressed: () {
        // setReservaCompleta();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
