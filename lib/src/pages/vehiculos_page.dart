import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/vehiculos_controller.dart';
import 'package:pcw_admin/src/models/route_argument.dart';

import 'vervehiculo_page.dart';

class VehiculosPage extends StatefulWidget {
  @override
  VehiculosPageState createState() => VehiculosPageState();
}

class VehiculosPageState extends StateMVC<VehiculosPage> {
  late VehiculosController _con;
  double width_size = 0;
  double height_size = 0;

  TextEditingController _inputVehiculoController = new TextEditingController();

  VehiculosPageState() : super(VehiculosController()) {
    _con = controller as VehiculosController;
  }

  @override
  Widget build(BuildContext context) {
    width_size = MediaQuery.of(context).size.width;
    height_size = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _con.scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Vehículos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: _con.loading
          ? Container() // CircularLoadingWidget(height: height_size / 2)
          : Stack(
              children: <Widget>[
                Image.asset(
                  'assets/img/fondo_car.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _inputVehiculoController,
                      keyboardType: TextInputType.text,
                      onChanged: (placa) {
                        _con.listadoVehiculos(placa);
                        setState(() {});
                      },
                      style: TextStyle(color: Theme.of(context).hintColor),
                      decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                        contentPadding: EdgeInsets.all(20),
                        suffixIcon: Icon(Icons.search,
                            color: Theme.of(context).accentColor),
                        hintText: 'Placa',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(1))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(1))),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: width_size,
                    height: height_size,
                    padding: EdgeInsets.only(top: 150, left: 10, right: 10),
                    child: _con.loadingV
                        ? Container() // CircularLoadingWidget(height: height_size / 2,)
                        : ListView(
                            children: listarvehiculos(),
                          ))
              ],
            ),
    );
  }

  List<Widget> listarvehiculos() {
    final List<Widget> listaOpciones = [];

    _con.lvehiculos.forEach((vehiculo) {
      final widgetTemp = ListTile(
        title: Text(
            "Placa: " + vehiculo.placa! + "   Tamaño: " + vehiculo.tamanio!),
        subtitle: Text(vehiculo.marca! + "-" + vehiculo.modelo!),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue[800]),
        onTap: () {
          final result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerVehiculoPage(
                routeArgument: new RouteArgument(id: "0", param: [vehiculo]),
              ),
            ),
          );
        },
      );
      listaOpciones.add(widgetTemp);
      listaOpciones.add(Divider(
        color: Theme.of(context).accentColor,
      ));
    });
    return listaOpciones;
  }
}
