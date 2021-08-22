import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/atencionsinres_controller.dart';
import 'package:pcw_admin/src/models/cliente.dart';

class AtencionsinresPage extends StatefulWidget {
  AtencionsinresPage({Key? key}) : super(key: key);

  @override
  _AtencionsinresPageState createState() => _AtencionsinresPageState();
}

class _AtencionsinresPageState extends StateMVC<AtencionsinresPage> {
  bool existe = true;
  double height_size = 0;
  double precioFin = 0;

  _AtencionsinresPageState() : super(AtencionsinresController()) {
    _con = controller as AtencionsinresController;
    
  }

  late AtencionsinresController _con;

  @override
  void initState() {
    super.initState();
    _con.listarServicios();
  }

  @override
  Widget build(BuildContext context) {
    height_size = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _con.scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Atención sin Reserva'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/img/fondo_car.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    //key: _con.loginFormKey,
                    child: _con.loading
                        ? Container() // Revisaar
                        /*CircularLoadingWidget(
                            height: 50,
                          )*/
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Image.asset(
                                  'assets/img/isotipo.png',
                                  width: MediaQuery.of(context).size.width / 6,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _con.lservicios.length > 0
                                  ? TextFormField(
                                      //controller: _con.placaController,
                                      keyboardType: TextInputType.text,
                                      initialValue: '',
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      onSaved: (input) {},
                                      onChanged: (input)  {
                                         _con.placa = input.toUpperCase();
                                        //  _con.listarClientes(_con.placa);

                                        //  if (_con.lclientes.isNotEmpty ) {
                                        //    //_con.clienteSel = new Cliente();
                                        //    _con.clienteSel = _con.lclientes[0];
                                        //  }
                                        print(_con.placaController.text);

                                      
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Ingrese N° de Placa',
                                        labelStyle: TextStyle(
                                            color: Theme.of(context).hintColor),
                                        contentPadding: EdgeInsets.all(20),
                                        // prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.search,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          onPressed: () {
                                            _con.listarClientes(_con.placa);
                                          },
                                        ),
                                        hintText: '1234ABC',
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.7)),
                                        // prefixIcon:
                                        //     Icon(Icons.email, color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(1))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(1))),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(1))),
                                      ),
                                    )
                                  : Container(), // Revisar
                              // CircularLoadingWidget(
                              //     height: height_size / 1.5),
                              SizedBox(
                                height: 20,
                              ),
                              _con.lclientes.length > 0
                                  ? SingleChildScrollView(
                                      physics: ScrollPhysics(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          DropdownButtonFormField(
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor),
                                            dropdownColor:
                                                Theme.of(context).primaryColor,
                                            decoration: InputDecoration(
                                              hintText: 'Seleccione un Cliente',
                                              icon: FaIcon(
                                                  FontAwesomeIcons.userFriends,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    width: 1.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 5.0,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                            ),
                                            value: _con.clienteSel,
                                            items: getClientesDropdown(),
                                            onChanged: (opt) {
                                              setState(() {
                                                _con.clienteSel = 
                                                    opt as Cliente;
                                                _con.obtenerVehiculoXcliPlaca(
                                                    _con.clienteSel.email!,
                                                    _con.placa);
                                              });
                                            },
                                          ),
                                          // DropdownButton(
                                          //   value: _con.clienteSel,
                                          //   items: getClientesDropdown(),
                                          //   onChanged: (opt) {
                                          //     setState(() {
                                          //       _con.clienteSel = opt;
                                          //       _con.obtenerVehiculoXcliPlaca(
                                          //           _con.clienteSel.email,
                                          //           _con.placa);
                                          //     });
                                          //     print(opt.email);
                                          //   },
                                          // ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Center(
                                                    child: Text(
                                                      'Seleccione el Servicio',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Divider(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    );
                                                  },
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _con.lservicios.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Theme(
                                                      data: ThemeData(
                                                          unselectedWidgetColor:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                      child: CheckboxListTile(
                                                        value: this
                                                            ._con
                                                            .lservicios
                                                            .elementAt(index)
                                                            .esSeleccionado,
                                                        onChanged:
                                                            (bool? elegido) {
                                                          
                                                          setState(() {
                                                            this
                                                                    ._con
                                                                    .lservicios
                                                                    .elementAt(
                                                                        index)
                                                                    .esSeleccionado =
                                                                elegido;
                                                            this._con.sumarPrecios();

                                                          //   print(this
                                                          //       ._con
                                                          //       .lservicios
                                                          //       .elementAt(
                                                          //           index)
                                                          //       .esSeleccionado);
                                                           });
                                                        },
                                                        title: Text(
                                                          this
                                                              ._con
                                                              .lservicios
                                                              .elementAt(index)
                                                              .nombre!,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    'Total Servicio',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                  Text(
                                                      'Bs. ' +
                                                          _con.precioFinal
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor))
                                                ],
                                              )),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  bottom: 20),
                                              child: ButtonTheme(
                                                minWidth: double.infinity,
                                                height: 50,
                                                child: RaisedButton(
                                                  // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                                                  onPressed: () {
                                                    // _con.login();
                                                    //Navigator.of(context).pushNamed('/AtencionSinRes');
                                                    _con.guardarReserva(
                                                        context);
                                                  },
                                                  child: Text(
                                                    'Crear Reverva',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                  ),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        // RoundedRectangleBorder(
                                        //   borderRadius:
                                        // ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 30),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            child: Text(
                                              'Este número de placa no se encuentra registrado. \n ¿Desea crear un nuevo auto?',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w100,
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            )),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0, bottom: 20),
                                            child: ButtonTheme(
                                              minWidth: double.infinity,
                                              height: 60,
                                              child: RaisedButton(
                                                // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                                                onPressed: () {
                                                  // _con.login();
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/AddVehiculo');
                                                  print(
                                                      'presionando boton para ir a nuevo vehículo');
                                                  //_con.guardarReserva();
                                                },
                                                child: Text(
                                                  'Crear Vehículo',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                ),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<Cliente>> getClientesDropdown() {
    List<DropdownMenuItem<Cliente>> lista = [];
    if (_con.lclientes.length > 0) {
      _con.lclientes.forEach((cliente) {
        lista.add(DropdownMenuItem(
          child: Text(cliente.nombreCompleto!),
          value: cliente,
        ));
      });
    }
    return lista;
  }
}
