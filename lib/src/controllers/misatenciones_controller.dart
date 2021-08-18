import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/atencion_inner.dart';
import 'package:pcw_admin/src/repository/atencion_repository.dart';
import 'package:pcw_admin/src/repository/user_repository.dart';

class MisAtencionesController extends ControllerMVC {
  bool? loading = false;
  String? fecha = '';

  List<AtencionInner> latenciones = [];

  GlobalKey<ScaffoldState>? scaffoldKey;

  MisAtencionesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();

    DateTime now = new DateTime.now();
    String fechaini = now.toString().split(' ')[0];
    listadoAtencionesInner(fechaini);
  }

  void listadoAtencionesInner(String fecha) async {
    String usuario = currentUser.value.email!;
    loading = true;
    final Stream<List<AtencionInner>> stream =
        await getAtencionesPorUserFechaInner(usuario, fecha);
    stream.listen((List<AtencionInner> _atencioninner) {
      setState(() {
        latenciones = _atencioninner;
        print('****************-mis atenciones-***********');
        print(jsonEncode(latenciones));
      });
      loading = false;
    }, onError: (a) {
      loading = false;
      scaffoldKey!.currentState!.showSnackBar(SnackBar(
        content: Text('Verifica tu conexión de internet!'),
      ));
    }, onDone: () {
      loading = false;
    });
  }
}
