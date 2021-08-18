import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/recepcion_controller.dart';
import 'package:pcw_admin/src/models/route_argument.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'detail_page.dart';

class RecepcionPage extends StatefulWidget {
  RouteArgument? routeArgument;
  String? _heroTag;

  RecepcionPage({Key? key, this.routeArgument}) {
    _heroTag = this.routeArgument!.param[1] as String;
  }

  @override
  _RecepcionPageState createState() => _RecepcionPageState();
}

class _RecepcionPageState extends StateMVC<RecepcionPage>
    with SingleTickerProviderStateMixin {
  double? width_size;
  double? height_size;

  String? id_reserva = '';
  String? id_cliente = '';

  int tamElegido = 0;

  _RecepcionPageState() : super(RecepcionController()) {
    _con = controller as RecepcionController;
  }
  late RecepcionController _con;

  @override
  void initState() {
    // TODO: implement initState
    id_reserva = this.widget.routeArgument!.param[0].id;
    id_cliente = this.widget.routeArgument!.param[0].idCliente;
    _con.reserva = this.widget.routeArgument!.param[0];
    // print('clieeeentee ' + id_cliente);
    _con.listadoDetalleReservaPorId(id_reserva!);
    _con.listadoClientePorEmail(id_cliente!);
    // print('ReservaInner------>>');
    // print(jsonEncode(_con.reserva));

    _con.atencion.observaciones = '';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width_size = MediaQuery.of(context).size.width;
    height_size = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _con.scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Recepción del Vehículo'),
        actions: [],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // print('Hola');
      //     _con.iniciarAtencion();
      //   },
      //   child: FaIcon(FontAwesomeIcons.playCircle),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/img/fondo_car.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: width_size,
            height: height_size,
            padding: EdgeInsets.only(top: 0, bottom: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      'assets/img/isotipo.png',
                      width: MediaQuery.of(context).size.width / 6,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).accentColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cliente',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          _con.cliente.nombreCompleto == null
                              ? ''
                              : _con.cliente.nombreCompleto! +
                                  '\n' +
                                  _con.cliente.email!,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).accentColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehículo',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          this.widget.routeArgument!.param[0].marca +
                              ' ' +
                              this.widget.routeArgument!.param[0].modelo +
                              ' - ' +
                              this.widget.routeArgument!.param[0].placa,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Divider(),
                        GroupButton(
                          selectedButtons: [int.parse(_con.reserva.tamanio!)],
                          isRadio: true,
                          spacing: 5,
                          buttons: ['M', 'L', 'XL'],
                          onSelected: (index, isSelected) {
                            print('$index fue seleccionado');
                            if (index == 0) {
                              _con.reserva.tamanio = "M";
                              _con.cambiaTamanio("M");
                            } else if (index == 1) {
                              _con.reserva.tamanio = "L";
                              _con.cambiaTamanio("L");
                            } else {
                              _con.reserva.tamanio = "XL";
                              _con.cambiaTamanio("XL");
                            }
                            print(jsonEncode(_con.ldetalleReserva));
                          },
                          selectedColor: Theme.of(context).primaryColor,
                          unselectedTextStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                          unselectedColor: Colors.transparent,
                          unselectedBorderColor: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).accentColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Servicios',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Column(
                          children: [
                            for (var item in _con.ldetalleReserva)
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(item.nombre!,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w200,
                                            color:
                                                Theme.of(context).hintColor)),
                                  ),
                                  Text(
                                      'Bs. ' +
                                          (double.parse(item.precio!))
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).accentColor))
                                ],
                              )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Total Servicio',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200,
                                      color: Theme.of(context).accentColor)),
                            ),
                            Text('Bs. ' + _con.total.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).accentColor))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).accentColor),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Tomar Fotografias',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _con.carLeft == null
                                ? InkWell(
                                    onTap: () {
                                      _con.getImageCar('L');
                                    },
                                    child: Image.asset(
                                      'assets/img/left.png',
                                      width: 60,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return DetailScreen(
                                                heroTag: widget._heroTag,
                                                image: _con.carLeft!.path);
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _con.carLeft!,
                                            width: 50,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              _con.quitarImagen('L');
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            _con.carRigth == null
                                ? InkWell(
                                    onTap: () {
                                      _con.getImageCar('R');
                                    },
                                    child: Image.asset(
                                      'assets/img/rigth.png',
                                      width: 60,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return DetailScreen(
                                                heroTag: widget._heroTag,
                                                image: _con.carRigth!.path);
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _con.carRigth!,
                                            width: 50,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              _con.quitarImagen('R');
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            _con.carFront == null
                                ? InkWell(
                                    onTap: () {
                                      _con.getImageCar('F');
                                    },
                                    child: Image.asset(
                                      'assets/img/front.png',
                                      width: 60,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return DetailScreen(
                                                heroTag: widget._heroTag,
                                                image: _con.carFront!.path);
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _con.carFront!,
                                            width: 50,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              _con.quitarImagen('R');
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            _con.carBack == null
                                ? InkWell(
                                    onTap: () {
                                      _con.getImageCar('B');
                                    },
                                    child: Image.asset(
                                      'assets/img/back.png',
                                      width: 60,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return DetailScreen(
                                                heroTag: widget._heroTag,
                                                image: _con.carBack!.path);
                                          },
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            _con.carBack!,
                                            width: 50,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              _con.quitarImagen('B');
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.times,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (cadena) {
                        _con.atencion.observaciones = cadena;
                        // print(cadena);
                        //vehículoNuevo.placa = cadena;
                      },
                      decoration: InputDecoration(
                          hintText: 'Observaciones',
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ToggleSwitch(
                      totalSwitches: 2,
                      initialLabelIndex: 0,
                      activeBgColor: [Theme.of(context).primaryColor],
                      activeFgColor: Theme.of(context).hintColor,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Theme.of(context).hintColor,
                      minWidth: 100.0,
                      labels: ['Lavado 1', 'Lavado 2'],
                      onToggle: (index) {
                        _con.canal = index;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        height: 50,
                        child: RaisedButton.icon(
                          // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                          onPressed: () {
                            _con.iniciarAtencion(context);
                          },
                          icon: Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).hintColor,
                          ),
                          label: Text(
                            'Iniciar Atención',
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
