import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/modelo_vehiculo_controller.dart';

class ModeloVehiculoPage extends StatefulWidget {
  ModeloVehiculoPage({Key? key}) : super(key: key);

  @override
  _ModeloVehiculoPageState createState() => _ModeloVehiculoPageState();
}

class _ModeloVehiculoPageState extends StateMVC<ModeloVehiculoPage> {
  late ModeloVehiculoController _con;

  double width_size = 0;
  double height_size = 0;

  TextEditingController _inputFechaController = new TextEditingController();

  _ModeloVehiculoPageState() : super(ModeloVehiculoController()) {
    _con = controller as ModeloVehiculoController;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width_size = MediaQuery.of(context).size.width;
    height_size = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _con.scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Modelos de Vehículo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialogGuardarModeloVehiculo();
        },
        label: Text('Nuevo Modelo'),
        icon: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _con.modelos.length == 0
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              width: MediaQuery.of(context).size.width,
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).accentColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/auto_on.png',
                    width: 100,
                  ),
                  Text(
                    'No se encontraron modelos de vehículo',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: <Widget>[
                Image.asset(
                  'assets/img/fondo_car.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          _con.search = value;
                        },
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          contentPadding: EdgeInsets.all(20),
                          // prefixIcon: Icon(Icons.calendar_today,
                          //     color: Theme.of(context).accentColor),
                          suffixIcon: Icon(Icons.search,
                              color: Theme.of(context).accentColor),
                          hintText: 'Buscar Modelo de Vehículo',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          // prefixIcon:
                          //     Icon(Icons.email, color: Theme.of(context).accentColor),
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
                      SizedBox(
                        height: 10,
                      ),
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 50,
                        child: RaisedButton.icon(
                          // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                          onPressed: () {
                            _con.buscarModelosVehiculo(_con.search);
                            // _con.login();
                          },
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).hintColor,
                          ),
                          label: Text(
                            'Buscar Modelo',
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          children: listarModeloVehiculo(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  List<Widget> listarModeloVehiculo() {
    final List<Widget> listaOpciones = [];

    _con.modelos.forEach((modelo) {
      final widgetTemp = ListTile(
        title: Text(modelo.marca! + ' ' + modelo.modelo! + ' ' + modelo.anio!),
        // trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue[800]),
        onTap: () {
          // print(modelo.id);

          // final result = Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MiDetalleAtencionPage(
          //       routeArgument: new RouteArgument(id: "0", param: [atencion]),
          //     ),
          //   ),
          // );
        },
      );
      listaOpciones.add(widgetTemp);
      listaOpciones.add(Divider(
        color: Theme.of(context).accentColor,
      ));
    });
    return listaOpciones;
  }

  void showDialogGuardarModeloVehiculo() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Modelo de Vehículo"),
              content: Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Agregar Modelo de Vehículo'),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                        mode: Mode.BOTTOM_SHEET,
                        maxHeight: 350,
                        items: _con.anios,
                        label: "Seleccionar el Año",
                        itemAsString: (String mod) => mod,
                        onChanged: (modelo) {
                          //print (modelo.modelo);
                          _con.vehiculomodelo.anio = modelo;
                        },
                        selectedItem: null,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 0.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                        ),
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          labelText: "Buscar Año del Vehículo",
                        ),
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Año del Vehículo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>(
                        mode: Mode.BOTTOM_SHEET,
                        maxHeight: 350,
                        items: _con.marcas,
                        label: "Seleccionar el Fabricante",
                        itemAsString: (String mod) => mod,
                        onChanged: (modelo) {
                          //print (modelo.modelo);
                          _con.vehiculomodelo.marca = modelo;
                        },
                        selectedItem: null,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 0.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0),
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                        ),
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          labelText: "Buscar Fabricantes de Vehículo",
                        ),
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Fabricantes de Vehículo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (cadena) {
                          print(cadena);
                          _con.vehiculomodelo.modelo = cadena;
                        },
                        decoration: InputDecoration(
                            hintText: 'Ingrese el Modelo',
                            hintStyle:
                                TextStyle(color: Theme.of(context).hintColor),
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
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Guardar'),
                  onPressed: () {
                    if (_con.vehiculomodelo.anio == null ||
                        _con.vehiculomodelo.marca == null ||
                        _con.vehiculomodelo.modelo == null) {
                      _con.scaffoldKey!.currentState!.showSnackBar(
                        SnackBar(
                          content:
                              Text('Completa la información, antes de guardar'),
                          action: SnackBarAction(
                              label: "Aceptar", onPressed: () {}),
                        ),
                      );
                    } else {
                      _con.registrarModeloVehiculo(context);
                    }
                  },
                ),
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
