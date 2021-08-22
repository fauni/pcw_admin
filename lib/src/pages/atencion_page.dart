import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/atencion_controller.dart';
import 'package:pcw_admin/src/models/route_argument.dart';

import 'detail_network_page.dart';
import 'detail_page.dart';

class AtencionPage extends StatefulWidget {
  RouteArgument? routeArgument;
  String? _heroTag;

  AtencionPage({Key? key, this.routeArgument}) {
    _heroTag = this.routeArgument!.param[1] as String;
  }

  @override
  _AtencionPageState createState() => _AtencionPageState();
}

class _AtencionPageState extends StateMVC<AtencionPage>
    with SingleTickerProviderStateMixin {
  double? width_size;
  double? height_size;

  String id_reserva = '';
  String id_cliente = '';
  _AtencionPageState() : super(AtencionController()) {
    _con = controller as AtencionController;
  }

  late AtencionController _con;

  @override
  void initState() {
    // TODO: implement initState
    id_reserva = this.widget.routeArgument!.param[0].id;
    id_cliente = this.widget.routeArgument!.param[0].idCliente;
    _con.reserva = this.widget.routeArgument!.param[0];
    _con.listadoDetalleReservaPorId(id_reserva);
    _con.listadoClientePorEmail(id_cliente);
    _con.obtenerAtencionPorReserva(id_reserva);
    _con.obtenerRutasImagenes();
    // print(jsonEncode(widget.routeArgument.param[0]));

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Atención del Vehículo'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // print('Hola');
      //     _con.showAlertDialog(context);
      //   },
      //   child: FaIcon(FontAwesomeIcons.stopwatch),
      //   backgroundColor: Colors.red.shade900,
      //   // backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/img/fondo_car.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(top: 100),
              child: Image.asset(
                'assets/img/isotipo.png',
                width: MediaQuery.of(context).size.width / 6,
              ),
            ),
          ),
          Container(
            width: width_size,
            height: height_size,
            padding: EdgeInsets.only(top: 170, bottom: 100),
            child: ListView(
              children: [
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
                                          color: Theme.of(context).hintColor)),
                                ),
                                Text(
                                    'Bs. ' +
                                        (double.parse(item.precio!)).toString(),
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
                        'Capturas Realizadas',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DetailNetworkScreen(
                                        heroTag: widget._heroTag!,
                                        image: _con.imgLeft);
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _con.imgLeft,
                                width: 50,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DetailNetworkScreen(
                                        heroTag: widget._heroTag!,
                                        image: _con.imgRigth);
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _con.imgRigth,
                                width: 50,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DetailNetworkScreen(
                                        heroTag: widget._heroTag!,
                                        image: _con.imgFront);
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _con.imgFront,
                                width: 50,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return DetailNetworkScreen(
                                        heroTag: widget._heroTag!,
                                        image: _con.imgBack);
                                  },
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _con.imgBack,
                                width: 50,
                              ),
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
                        'Información Adicional',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Hora de Inicio: ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: Theme.of(context).accentColor)),
                          ),
                          Text(_con.atencion.fechaInicio ?? '',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Hora Finalización: ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: Theme.of(context).accentColor)),
                          ),
                          Text(_con.atencion.fechaFin ?? '',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor))
                        ],
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: Text('Observaciones: ',
                      //           style: TextStyle(
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.w200,
                      //               color: Theme.of(context).accentColor)),
                      //     ),
                      //     Text(_con.atencion.observaciones ?? '',
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             color: Theme.of(context).hintColor))
                      //   ],
                      // ),
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
                        'Observaciones',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(_con.atencion.observaciones ?? '',
                          style: TextStyle(
                              fontSize: 15, color: Theme.of(context).hintColor))
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
                        'Captura Servicio Finalizado',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      _con.carFinal == null
                          ? InkWell(
                              onTap: () {
                                _con.getImageFinal();
                              },
                              child: Center(
                                child: FaIcon(FontAwesomeIcons.camera,
                                    color: Colors.white),
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
                                          image: _con.carFinal!.path);
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        _con.carFinal!,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                  _con.atencion.fechaFin == null
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              _con.quitarImagenFinal();
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
                                      : Container()
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _con.atencion.fechaFin == null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: 
                    !_con.cargando 
                    ?ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      child: RaisedButton.icon(
                        // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                        onPressed: () {
                          // _con.login();
                          _con.showAlertDialog(context);
                        },
                        icon: Icon(
                          Icons.stop,
                          color: Theme.of(context).hintColor,
                        ),
                        label: Text(
                          'Finalizar Atención',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                    :Container(),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      child: RaisedButton.icon(
                        // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: Icon(
                          Icons.home,
                          color: Theme.of(context).hintColor,
                        ),
                        label: Text(
                          'Volver al Inicio',
                          style: TextStyle(color: Theme.of(context).hintColor),
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
    );
  }
}
