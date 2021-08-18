import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/misatenciones_controller.dart';
import 'package:pcw_admin/src/models/route_argument.dart';

import 'midetalleatencion_page.dart';

class MisAtencionesPage extends StatefulWidget {
  MisAtencionesPage({Key? key}) : super(key: key);

  @override
  _MisAtencionesPageState createState() => _MisAtencionesPageState();
}

class _MisAtencionesPageState extends StateMVC<MisAtencionesPage> {
  late MisAtencionesController _con;

  double width_size = 0;
  double height_size = 0;

  TextEditingController _inputFechaController = new TextEditingController();

  _MisAtencionesPageState() : super(MisAtencionesController()) {
    _con = controller as MisAtencionesController;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Mis Atenciones'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: _con.loading!
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
                    'No se encontraron atenciones realizadas',
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: TextField(
                      enableInteractiveSelection: false,
                      controller: _inputFechaController,
                      keyboardType: TextInputType.text,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                      style: TextStyle(color: Theme.of(context).hintColor),
                      decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                        contentPadding: EdgeInsets.all(20),
                        // prefixIcon: Icon(Icons.calendar_today,
                        //     color: Theme.of(context).accentColor),
                        suffixIcon: Icon(Icons.calendar_today,
                            color: Theme.of(context).accentColor),
                        hintText: 'Seleccione una Fecha',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
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
                    // child: Image.asset(
                    //   'assets/img/isotipo.png',
                    //   width: MediaQuery.of(context).size.width / 6,
                    // ),
                  ),
                ),
                Container(
                    // color: Colors.transparent.withOpacity(0.5),
                    width: width_size,
                    height: height_size,
                    padding: EdgeInsets.only(top: 150, left: 10, right: 10),
                    child: ListView(
                      children: listarAtenciones(),
                    ))
              ],
            ),
    );
  }

  List<Widget> listarAtenciones() {
    final List<Widget> listaOpciones = [];

    _con.latenciones.forEach((atencion) {
      final widgetTemp = ListTile(
        title: Text(atencion.model! + "   Placa: " + atencion.placa!),
        subtitle: Text(atencion.nombreCompleto! + "  " + atencion.idCliente!),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue[800]),
        onTap: () {
          print(atencion.nombreCompleto);

          // Navigator.of(context).pushNamed('/MiDetalleAtencion',arguments: new RouteArgument(
          //             id: "0", param: [atencion])) ;

          final result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MiDetalleAtencionPage(
                routeArgument: new RouteArgument(id: "0", param: [atencion]),
              ),
            ),
          );

          //       final result =  Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MiDetalleAtencionPage(atencion),
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

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2021),
        lastDate: new DateTime(2025),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Theme.of(context).accentColor,
              ),
              dialogBackgroundColor: Theme.of(context).primaryColor,
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        _con.fecha = picked.toString().split(' ')[0];
        _inputFechaController.text = _con.fecha!;
        _con.listadoAtencionesInner(_con.fecha!);
      });
      //print(_con.fecha);
    }
  }
}
