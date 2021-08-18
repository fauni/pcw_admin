import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/midetalleatencion_controller.dart';
import 'package:pcw_admin/src/models/atencion_inner.dart';
import 'package:pcw_admin/src/models/route_argument.dart';

import 'detail_network_page.dart';

class MiDetalleAtencionPage extends StatefulWidget {
  RouteArgument? routeArgument;
  AtencionInner? atencion;
  String? _heroTag;
  // MiDetalleAtencionPage({Key key}) : super(key: key);

  MiDetalleAtencionPage({Key? key, this.routeArgument}) {
    _heroTag = '1'; //this.routeArgument.param[1] as String;
    // atencion = this.routeArgument.param as AtencionInner;
    // print(this.routeArgument);
  }

  @override
  _MiDetalleAtencionPageState createState() => _MiDetalleAtencionPageState();
}

class _MiDetalleAtencionPageState extends StateMVC<MiDetalleAtencionPage> {
  late MiDetalleAtencionController _con;
  double? width_size;
  double? height_size;

  _MiDetalleAtencionPageState() : super(MiDetalleAtencionController()) {
    _con = controller as MiDetalleAtencionController;
    // miAtencion = this.widget.atencion;
  }

  @override
  void initState() {
    _con.atencion = this.widget.routeArgument!.param[0];

    _con.listadoDetalleReservaPorId(_con.atencion.idReserva!);
    _con.obtenerRutasImagenes();
    print('mi detalle atencion');
    print(jsonEncode(_con.atencion));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width_size = MediaQuery.of(context).size.width;
    height_size = MediaQuery.of(context).size.height;
    print(_con.atencion.nombreCompleto);
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
        title: Text('Detalle de atención'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                _con.launchURLFacebook();
              })
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // print('Hola');
      //     //_con.showAlertDialog(context);
      //   },
      //   child: FaIcon(FontAwesomeIcons.stopwatch),
      //   backgroundColor: Colors.red.shade900,
      //   // backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Stack(
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
            padding: EdgeInsets.only(top: 170, bottom: 10),
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
                        _con.atencion.nombreCompleto == null
                            ? ''
                            : _con.atencion.nombreCompleto! +
                                '\n' +
                                _con.atencion.idCliente!,
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
                        'Vehiculo',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        this._con.atencion.model! +
                            ' - ' +
                            this._con.atencion.placa!,
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
                                        heroTag: widget._heroTag,
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
                                        heroTag: widget._heroTag,
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
                                        heroTag: widget._heroTag,
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
                                        heroTag: widget._heroTag,
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
                          Text(_con.atencion.fechaInicio.toString(),
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
                          Text(_con.atencion.fechaFin.toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).hintColor))
                        ],
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).accentColor),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return DetailNetworkScreen(
                                heroTag: widget._heroTag, image: _con.imgRigth);
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
                        'Factura',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: _con.imageFactura == null
                            ? Center(
                                child: Image.asset(
                                  'assets/img/mi_factura.png',
                                  width: 100,
                                ),
                              )
                            : Image.file(_con.imageFactura!),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _con.envio
                          ? Text('Factura enviada')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonTheme(
                                  minWidth: width_size! / 3,
                                  child: RaisedButton.icon(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    color: Colors.transparent,
                                    textColor: Theme.of(context).hintColor,
                                    onPressed: () {
                                      _con.getImageFactura();
                                    },
                                    icon: Icon(
                                      Icons.upload_file,
                                      color: Theme.of(context).accentColor,
                                      size: 20,
                                    ),
                                    label: Text(
                                      'Capturar\nFactura',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors
                                            .blue, //Theme.of(context).primaryColor,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: width_size! / 3,
                                  child: RaisedButton.icon(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    color: Colors.transparent,
                                    textColor: Theme.of(context).hintColor,
                                    onPressed: () {
                                      _con.guardarImagenFactura();
                                    },
                                    icon: Icon(
                                      Icons.send_and_archive,
                                      color: Theme.of(context).accentColor,
                                      size: 20,
                                    ),
                                    label: Text(
                                      'Enviar\nFactura',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors
                                            .blue, //Theme.of(context).primaryColor,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
