import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/models/cliente.dart';
import 'package:pcw_admin/src/repository/cliente_repository.dart';

class AddclienteController extends ControllerMVC {
  bool? loading = false;
  Cliente? clienteNuevo = new Cliente();
  GlobalKey<ScaffoldState>? scaffoldKey;

  AddclienteController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  //registrar en cliente en servidor
  void registrarCliente(BuildContext context) async {
    this.loading = true;
    setState(() {});
    var clienteResp = await guardarCliente(clienteNuevo!);

    this.loading = false;
    this.scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Se agregó correctamente'),
          //backgroundColor: Theme.of(context).hintColor ,
        ));
    setState(() {});
    setClienteElegido(clienteNuevo!.email!);
    //print('____ANTES DE ENVIAR___');
    //print(newVehiculo.imgFile);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/AddVehiculo', arguments: 3);
  }
}
