import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/addcliente_controller.dart';
import 'package:pcw_admin/src/models/cliente.dart';

// import '../widgets/CircularLoadingWidget.dart';

class AddClientePage extends StatefulWidget {
  @override
  AddClientePageState createState() => AddClientePageState();
}

class AddClientePageState extends StateMVC<AddClientePage> {
  Cliente clienteNuevo = new Cliente();
  late AddclienteController _con;

  AddClientePageState() : super(AddclienteController()) {
    _con = controller as AddclienteController;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Agregar un Cliente'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios,
                color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !_con.loading!
            ? Stack(
                children: [
                  Image.asset(
                    'assets/img/fondo_car.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(15),
                            //     border: Border.all(
                            //         color: Theme.of(context).accentColor)),

                            height:
                                150, //MediaQuery.of(context).size.height / 3,
                            child: Center(
                                child: Image(
                              image: AssetImage('assets/img/isotipo.png'),
                              width: MediaQuery.of(context).size.width / 6,
                            )),
                          ),
                          Divider(),
                          TextField(
                            onChanged: (cadena) {
                              print(cadena);
                              _con.clienteNuevo!.nombreCompleto = cadena;
                            },
                            decoration: InputDecoration(
                                hintText: 'Ingrese su Nombre Completo',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0),
                                ),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                          Divider(),
                          TextField(
                            onChanged: (cadena) {
                              print(cadena);
                              _con.clienteNuevo!.email = cadena;
                            },
                            decoration: InputDecoration(
                                hintText: 'Ingrese su Correo Electrónico',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0),
                                ),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                          Divider(),
                          TextField(
                            onChanged: (cadena) {
                              print(cadena);
                              _con.clienteNuevo!.telefono = cadena;
                            },
                            decoration: InputDecoration(
                                hintText:
                                    'Ingrese su Número Telefónico o celular',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 1.0),
                                ),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                          Divider(),
                          ButtonTheme(
                            minWidth: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).hintColor,
                              onPressed: () {
                                print('guardando cliente');
                                _con.registrarCliente(context);
                              },
                              child: Text('Guardar Cliente'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container());
    // : CircularLoadingWidget(
    //    height: MediaQuery.of(context).size.height,
    //  ));
  }
}
