import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:group_button/group_button.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/carro_controller.dart';
import 'package:pcw_admin/src/models/cliente.dart';
import 'package:pcw_admin/src/models/vehiculo.dart';
import 'package:pcw_admin/src/models/vehiculo_modelo.dart';
import 'package:pcw_admin/src/repository/cliente_repository.dart';

// import '../widgets/CircularLoadingWidget.dart';

class AddVehiculoWidget extends StatefulWidget {
  @override
  AddVehiculoWidgetState createState() => AddVehiculoWidgetState();
}

class AddVehiculoWidgetState extends StateMVC<AddVehiculoWidget> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Vehiculo vehiculoNuevo = new Vehiculo();
  late CarroController _con;

  AddVehiculoWidgetState() : super(CarroController()) {
    _con = controller as CarroController;
    vehiculoNuevo.idTipo = "1";
  }

  @override
  void initState() {
    _con.listarModelosVehiculo();
    _con.listarTipoVehiculo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vehiculoNuevo.idTipo = "1";
    return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Agregar un vehiculo nuevo'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios,
                color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !_con.loading
            ? Stack(
                children: [
                  Image.asset(
                    'assets/img/fondo_car.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Theme.of(context).accentColor)),

                            height:
                                150, //MediaQuery.of(context).size.height / 3,
                            child: Center(
                                child: _con.image == null
                                    ? FlatButton.icon(
                                        onPressed: () {
                                          _con.getImage(2);
                                        },
                                        label: Text('Capturar Imagen'),
                                        icon: Icon(Icons.camera_alt),
                                        textColor: Theme.of(context).hintColor,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Image(
                                        image: FileImage(_con.image!),
                                      )),
                          ),
                          Divider(),
                          DropdownSearch<Cliente>(
                            mode: Mode.BOTTOM_SHEET,
                            maxHeight: 300,
                            items: _con.clientes,
                            label: "Seleccionar cliente",
                            itemAsString: (Cliente clie) =>
                                clie.nombreCompleto! + ' ' + clie.email!,
                            onChanged: (cliente) {
                              //print (modelo.modelo);
                              setClienteElegido(cliente!.email!);
                              vehiculoNuevo.idCliente = cliente.email;
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
                              labelText: "Buscar Clientes",
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
                                  'Cliente',
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
                          Divider(),
                          ButtonTheme(
                            minWidth: double.infinity,
                            height: 60.0,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).hintColor,
                              onPressed: () {
                                //_con.registrarVehiculo(vehiculoNuevo);
                                Navigator.of(context).pushNamed('/AddCliente');
                              },
                              child: Text('Crear Cliente'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Divider(),
                          ButtonTheme(
                            minWidth: double.infinity,
                            height: 60.0,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).hintColor,
                              onPressed: () {
                                showDialogGuardarModeloVehiculo();
                              },
                              child: Text('Nuevo Modelo de Vehículo'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Divider(),
                          DropdownSearch<VehiculoModelo>(
                            mode: Mode.BOTTOM_SHEET,
                            maxHeight: 300,
                            items: _con.modelos,
                            label: "Seleccionar Modelo de Automovil",
                            itemAsString: (VehiculoModelo mod) =>
                                mod.marca! +
                                ' ' +
                                mod.modelo! +
                                ' ' +
                                mod.anio!,
                            onChanged: (modelo) {
                              //print (modelo.modelo);
                              vehiculoNuevo.idModelo = modelo!.id;
                              vehiculoNuevo.anio = modelo.anio;
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
                              labelText: "Buscar Modelo de Automovil",
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
                                  'Modelo de Automovil',
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
                          Divider(),
                          Text('Elija el tamaño de su vehiculo'),
                          Divider(),
                          GroupButton(
                            isRadio: true,
                            spacing: 10,
                            buttons: ['M', 'L', 'XL'],
                            onSelected: (index, isSelected) {
                              print('$index fue seleccionado');
                              if (index == 0) {
                                vehiculoNuevo.idTipo = "1";
                              } else if (index == 1) {
                                vehiculoNuevo.idTipo = "3";
                              } else {
                                vehiculoNuevo.idTipo = "5";
                              }
                            },
                            selectedColor: Theme.of(context).primaryColor,
                            unselectedTextStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            unselectedColor: Colors.transparent,
                            unselectedBorderColor:
                                Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/img/m-min.png',
                                width: 100,
                              ),
                              Image.asset(
                                'assets/img/l-min.png',
                                width: 100,
                              ),
                              Image.asset(
                                'assets/img/xl-min.png',
                                width: 100,
                              ),
                            ],
                          ),
                          Divider(),
                          TextField(
                            onChanged: (cadena) {
                              print(cadena);
                              vehiculoNuevo.placa = cadena.toUpperCase();
                            },
                            decoration: InputDecoration(
                                hintText: 'Ingrese su Nro. de Placa',
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
                          GroupButton(
                            isRadio: true,
                            spacing: 10,
                            buttons: ['Auto', 'Moto', 'UTV'],
                            onSelected: (index, isSelected) {
                              print('$index fue seleccionado');
                              if (index == 0) {
                              } else if (index == 1) {
                              } else {}
                            },
                            selectedColor: Theme.of(context).primaryColor,
                            unselectedTextStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            unselectedColor: Colors.transparent,
                            unselectedBorderColor:
                                Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          Divider(),
                          ButtonTheme(
                            minWidth: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).hintColor,
                              onPressed: () {
                                // vehiculoNuevo.idCliente =
                                //     "1"; //provisional cambiar por cliente actual
                                // vehiculoNuevo.observaciones = "";
                                vehiculoNuevo.estado = "A";
                                // vehiculoNuevo.anio = "1900";
                                // vehiculoNuevo.foto = "ff";
                                print('guardando el auto');
                                print(vehiculoNuevo.toJson());

                                if (vehiculoNuevo.placa == null ||
                                    vehiculoNuevo.idModelo == null ||
                                    vehiculoNuevo.idCliente == null ||
                                    vehiculoNuevo.placa == "") {
                                  _con.informacionConfirmacion(
                                      context,
                                      "Datos incompletos",
                                      "Complete los datos y vuelva a intentarlo");
                                } else {
                                  if (_con.image == null) {
                                    _con.informacionConfirmacion(
                                        context,
                                        "Imagen del Vehiculo",
                                        "Necesita realizar la captura del Vehiculo. Presione guardar nuevamente");
                                    _con.getImage(2);
                                  } else {
                                    _con.registrarVehiculo(
                                        context, vehiculoNuevo);
                                  }
                                }
                              },
                              child: Text('Guardar Datos de Vehículo'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container());
    /*: CircularLoadingWidget(
                height: MediaQuery.of(context).size.height,
              ));*/
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
                      Text('Agregar Modelo de Vehiculo'),
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
                          labelText: "Buscar Año del Vehiculo",
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
                              'Año del Vehiculo',
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
                          labelText: "Buscar Fabricantes de Vehiculo",
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
                              'Fabricantes de Vehiculo',
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
                      scaffoldKey.currentState!.showSnackBar(
                        SnackBar(
                          content:
                              Text('Completa la información, antes de guardar'),
                          action: SnackBarAction(
                              label: "Aceptar", onPressed: () {}),
                        ),
                      );
                    } else {
                      // if (_con.image == null) {
                      //   scaffoldKey.currentState.showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //           'Necesitas realizar la captura del vehiculo'),
                      //       action: SnackBarAction(
                      //           label: "Aceptar", onPressed: () {}),
                      //     ),
                      //   );
                      // } else {
                      _con.registrarModeloVehiculo(context);
                      scaffoldKey.currentState!.showSnackBar(
                        SnackBar(
                          content:
                              Text('El modelo se registró satisfactoriamente'),
                        ),
                      );
                      // }
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
