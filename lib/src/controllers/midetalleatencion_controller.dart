import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/atencion.dart';
import 'package:pcw_admin/src/models/atencion_inner.dart';
import 'package:pcw_admin/src/models/detalle_reserva.dart';
import 'package:pcw_admin/src/repository/atencion_repository.dart';
import 'package:pcw_admin/src/repository/reserva_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class MiDetalleAtencionController extends ControllerMVC {
  String imgLeft = '';
  String imgRigth = '';
  String imgFront = '';
  String imgBack = '';

  String imgFinal = '';
  bool envio = false;
  bool loading = false;
  AtencionInner atencion = new AtencionInner();
  List<DetalleReserva> ldetalleReserva = [];

  GlobalKey<ScaffoldState>? scaffoldKey;

  double subTotal = 0.0;
  double total = 0.0;

  File? carLeft;
  File? carRigth;
  File? carFront;
  File? carBack;

  File? imageFactura;
  final picker = ImagePicker();
  List<String> limages = [];

  MiDetalleAtencionController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

    DateTime now = new DateTime.now();
    String fechaini = now.toString().split(' ')[0];
  }

  void obtenerRutasImagenes() async {
    final url_capturas = await getUrlCapturas();
    setState(() {
      this.imgLeft = url_capturas + atencion.idReserva! + '/left.jpg';
      this.imgRigth = url_capturas + atencion.idReserva! + '/rigth.jpg';
      this.imgFront = url_capturas + atencion.idReserva! + '/front.jpg';
      this.imgBack = url_capturas + atencion.idReserva! + '/back.jpg';
      this.imgFinal = url_capturas + atencion.idReserva! + '/final.jpg';
    });
  }

  Future getImageFactura() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFactura = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void guardarImagenFactura() async {
    String imgBase64 = base64Encode(this.imageFactura!.readAsBytesSync());
    String fileName = this.imageFactura!.path.split("/").last;
    Atencion atencionEnv = new Atencion();
    atencionEnv.id = this.atencion.id;
    atencionEnv.idReserva = this.atencion.idReserva;
    atencionEnv.imagenFinal = imgBase64;
    atencionEnv.observaciones = fileName;
    print(atencionEnv.toJson());

    final Stream<bool> stream = await guardarCapturaFactura(atencionEnv);
    envio = true;
    setState(() {});
    stream.listen((bool _seInicio) {
      setState(() {
        loading = _seInicio;
        if (loading) {
          scaffoldKey!.currentState!.showSnackBar(
            SnackBar(
              content: Text('Se guardo las captura de la factura'),
            ),
          );
          //Navigator.pop(context, true);
        } else {
          scaffoldKey!.currentState!.showSnackBar(
            SnackBar(
              content: Text('No se pudo guardar las captura de la factura'),
            ),
          );
        }

        // print("===============================");
        // //print(carros);
      });
    }, onError: (a) {
      // loader.remove();
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {
      // Helper.hideLoader(loader);
      loading = false;
    });
  }

  Future getImageCar(String lado) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 300, maxWidth: 300);
    setState(() {
      if (pickedFile != null) {
        if (lado == 'L') {
          carLeft = File(pickedFile.path);
          limages.add(pickedFile.path);
        } else if (lado == 'R') {
          carRigth = File(pickedFile.path);
          limages.add(pickedFile.path);
        } else if (lado == 'F') {
          carFront = File(pickedFile.path);
          limages.add(pickedFile.path);
        } else {
          carBack = File(pickedFile.path);
          limages.add(pickedFile.path);
        }
      } else {
        print('Image no seleccionada.');
      }
    });
  }

  Future quitarImagen(String lado) async {
    setState(() {
      if (lado == 'L') {
        carLeft = null;
      } else if (lado == 'R') {
        carRigth = null;
      } else if (lado == 'F') {
        carFront = null;
      } else {
        carBack = null;
      }
    });
  }

  void launchURLFacebook() async {
    const url = 'http://www.lasalvadorahnos.com/fb/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        calculateTotal();
        // print(jsonEncode(ldetalleReserva));
      });
    }, onError: (a) {
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {});
  }

  void calculateTotal() async {
    subTotal = 0;
    total = 0;

    ldetalleReserva.forEach(
      (serv) {
        subTotal = subTotal + double.parse(serv.precio!);
      },
    );
    total = subTotal;
    setState(() {});
  }
}
