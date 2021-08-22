import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/atencion.dart';
import 'package:pcw_admin/src/models/cliente.dart';
import 'package:pcw_admin/src/models/detalle_reserva.dart';
import 'package:pcw_admin/src/models/imagenrecepcion.dart';
import 'package:pcw_admin/src/models/reserva_inner.dart';
import 'package:pcw_admin/src/repository/atencion_repository.dart';
import 'package:pcw_admin/src/repository/cliente_repository.dart';
import 'package:pcw_admin/src/repository/reserva_repository.dart';
import 'package:pcw_admin/src/repository/user_repository.dart';

class RecepcionController extends ControllerMVC {
  bool seInicio = false;
  OverlayEntry? loader;

  int tamanioInt = 0;

  int canal = 0;

  ImagenRecepcion imagenRecepcion =
      new ImagenRecepcion(); // Objeto capturas de imagenes

  List<DetalleReserva> ldetalleReserva = []; // Listado de detalle de reserva
  Cliente cliente = new Cliente();
  Atencion atencion = new Atencion();
  ReservaInner reserva = new ReservaInner();

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  double subTotal = 0.0;
  double total = 0.0;

  File? carLeft;
  File? carRigth;
  File? carFront;
  File? carBack;
  final picker = ImagePicker();
  List<String> limages = [];

  RecepcionController() {
    // loader = Helper.overlayLoader(context);
    print("ingreso a reservas");
  }

  String rutaImg(String nombre) {
    return getRutaImg(nombre);
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
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {});
  }

  // listar cliente por Email
  void listadoClientePorEmail(String email) async {
    final Stream<Cliente> stream = await obtenerClienteXEmail(email);
    stream.listen((Cliente _cliente) {
      setState(() {
        cliente = _cliente;
        // print("===============================");
        // //print(carros);
        // print(jsonEncode(cliente));
      });
    }, onError: (a) {
      scaffoldKey.currentState!.showSnackBar(SnackBar(
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

    // atencion.precioTotal = total.toString();
    setState(() {});
  }

  void cambiaTamanio(String tam) {
    ldetalleReserva.forEach((serv) {
      switch (tam) {
        case 'M':
          serv.precio = serv.precioM;
          this.tamanioInt=0;
          break;
        case 'L':
          serv.precio = serv.precioL;
          this.tamanioInt=1;
          break;
        case 'XL':
          serv.precio = serv.precioXl;
          this.tamanioInt=2;
          break;
        default:
      }
    });
    calculateTotal();
  }

  // listar cliente por Email
  void iniciarAtencion(BuildContext context) async {
    if (carLeft == null ||
        carRigth == null ||
        carFront == null ||
        carBack == null) {
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text('Necesita completar las capturas'),
        ),
      );
    } else {
      // FocusScope.of(context).unfocus();
      // Overlay.of(context).insert(loader);
      atencion.id = "0";
      atencion.idReserva = reserva.id;
      atencion.fechaInicio = '';
      atencion.fechaFin = "";
      atencion.usuario = currentUser.value.email;
      atencion.precioTotal = total.toString();
      atencion.estado = "";

      if (this.canal == 0) {
        atencion.rtsp = "3";
      } else {
        atencion.rtsp = "2";
      }

      final Stream<bool> stream = await initAtencion(atencion);
      stream.listen((bool _seInicio) {
        guardarCapturas(context, atencion.idReserva!); // Guardar Capturas
        regCambioPrecioDetalleReserva(context);
        setState(() {
          seInicio = _seInicio;

          if (seInicio) {
            scaffoldKey.currentState!.showSnackBar(
              SnackBar(
                content: Text('Se inicio el proceso de Lavado'),
              ),
            );
            Navigator.pop(context, true);
          } else {
            scaffoldKey.currentState!.showSnackBar(
              SnackBar(
                content: Text(
                    'Revise la información, no se pudo iniciar el proceso de lavado'),
              ),
            );
          }

          // print("===============================");
          // //print(carros);
        });
      }, onError: (a) {
        // loader.remove();
        scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text('Verifica tu conexión de internet!'),
        ));
      }, onDone: () {
        // Helper.hideLoader(loader);
      });
    }
  }

  void guardarCapturas(BuildContext context, String _idreserva) async {
    // FocusScope.of(context).unfocus();
    // Overlay.of(context).insert(loader);

    imagenRecepcion.id = "0";
    imagenRecepcion.idReserva = _idreserva;
    imagenRecepcion.imgLeft = base64Encode(this.carLeft!.readAsBytesSync());
    imagenRecepcion.imgRigth = base64Encode(this.carRigth!.readAsBytesSync());
    imagenRecepcion.imgFront = base64Encode(this.carFront!.readAsBytesSync());
    imagenRecepcion.imgBack = base64Encode(this.carBack!.readAsBytesSync());

    // print(jsonEncode(atencion));
    final Stream<bool> stream = await guardarCapturasRecepcion(imagenRecepcion);
    stream.listen((bool _seInicio) {
      setState(() {
        seInicio = _seInicio;
        if (seInicio) {
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('Se guardo las capturas'),
            ),
          );
          Navigator.pop(context, true);
        } else {
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('No se pudo guardar las capturas del vehiculo'),
            ),
          );
        }

        // print("===============================");
        // //print(carros);
      });
    }, onError: (a) {
      // loader.remove();
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {
      // Helper.hideLoader(loader);
    });
  }

  void regCambioPrecioDetalleReserva(BuildContext context) async {
    //FocusScope.of(context).unfocus();
    //Overlay.of(context).insert(loader);
    String detalleRes = jsonEncode(ldetalleReserva);
    // print(jsonEncode(atencion));
    final Stream<bool> stream =
        await registraCambioPrecioDetalleReserva(detalleRes);
    stream.listen((bool _seInicio) {
      guardarCapturas(context, atencion.idReserva!); // Guardar Capturas
      setState(() {
        seInicio = _seInicio;

        if (seInicio) {
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('acualizado'),
            ),
          );
          Navigator.pop(context, true);
        } else {
          scaffoldKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('Revise la información, no se pudo actalizar'),
            ),
          );
        }

        // print("===============================");
        // //print(carros);
      });
    }, onError: (a) {
      // loader.remove();
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {
      // Helper.hideLoader(loader);
    });
  }
  int tamanioToInt(String tam){
    switch (tam) {
      case "M":
        return 0;
        break;
        case "L":
         return 1;
        break;
        case "XL":
        return 2;
        break;
      default :
      return 2;
    }
  }
}
