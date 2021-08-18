import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.username != null
                  ? Navigator.of(context).pushNamed('/Main')
                  : Navigator.of(context).pushNamed('/Login');
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
              accountName: Text(
                currentUser.value.username!,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              accountEmail: Text(
                currentUser.value.email!,
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: NetworkImage(
                    "https://www.kindpng.com/picc/m/33-338711_circle-user-icon-blue-hd-png-download.png"),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Home');
            },
            // leading: Icon(
            //   UiIcons.home,
            //   color: Theme.of(context).focusColor.withOpacity(1),
            // ),
            leading: new Image.asset(
              'assets/img/home.png',
              width: 40.0,
            ),
            title: Text(
              'Inicio',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/MisAtenciones');
            },
            // leading: Icon(
            //   UiIcons.home,
            //   color: Theme.of(context).focusColor.withOpacity(1),
            // ),
            leading: new Image.asset(
              'assets/img/mi_factura.png',
              width: 40.0,
            ),
            title: Text(
              'Mis Atenciones',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 3);
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/carrito_verde.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).pedidos,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 1);
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/cobranzas.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).cobranzas,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Categories');
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/vademecum.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).vademecum,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 0);
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/notificaciones.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).notifications,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),

          // Container(
          //   padding: EdgeInsets.only(left: 5.0),
          //   color: Theme.of(context).primaryColor,
          //   child: ListTile(
          //     dense: true,
          //     leading:
          //         Image.asset('assets/icon/preferencias_app.png', width: 25.0),
          //     title: Text(S.of(context).application_preferences,
          //         style:
          //             TextStyle(color: Theme.of(context).secondaryHeaderColor)),
          //     trailing: Icon(
          //       Icons.remove,
          //       color: Theme.of(context).focusColor.withOpacity(0.3),
          //     ),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Contactanos');
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/contactanos.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).contactanos,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/PoliticasPrivacidad');
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/politicas_privacidad.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).politicasprivacidad,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/TerminoUso');
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/terminos_uso.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     S.of(context).terminosuso,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     const url = 'http://lafar.net/';
          //     launchURL(url);
          //     // Navigator.of(context).pushNamed('/Languages');
          //   },
          //   leading: Icon(
          //     Icons.info,
          //     color: Theme.of(context).accentColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).acercade,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     if (Theme.of(context).brightness == Brightness.dark) {
          //       setBrightness(Brightness.light);
          //       DynamicTheme.of(context).setBrightness(Brightness.light);
          //     } else {
          //       setBrightness(Brightness.dark);
          //       DynamicTheme.of(context).setBrightness(Brightness.dark);
          //     }
          //   },
          //   leading: new Image.asset(
          //     'assets/icon/quit.png',
          //     width: 35.0,
          //   ),
          //   title: Text(
          //     Theme.of(context).brightness == Brightness.dark
          //         ? S.of(context).light_mode
          //         : S.of(context).dark_mode,
          //     style: Theme.of(context).textTheme.subhead,
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Vehiculos');
            },
            // leading: Icon(
            //   UiIcons.home,
            //   color: Theme.of(context).focusColor.withOpacity(1),
            // ),
            leading: new Image.asset(
              'assets/img/auto_on.png',
              width: 40.0,
            ),
            title: Text(
              'Vehículos',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/ModeloVehiculo');
            },
            leading: new Image.asset(
              'assets/img/modelo_vehiculo.png',
              width: 40.0,
            ),
            title: Text(
              'Modelos Vehículo',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),

          ListTile(
            onTap: () {
              if (currentUser.value.username != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: new Image.asset(
              'assets/img/cerrar_sesion_blue.png',
              width: 40.0,
            ),
            title: Text(
              currentUser.value.username != null
                  ? 'Cerrar Sesión'
                  : 'Iniciar Sesión',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),

          currentUser.value.username == null
              // ? ListTile(
              //     onTap: () {
              //       Navigator.of(context).pushNamed('/SignUp');
              //     },
              //     leading: Icon(
              //       Icons.person_add,
              //       color: Theme.of(context).focusColor.withOpacity(1),
              //     ),
              //     title: Text(
              //       S.of(context).register,
              //       style: Theme.of(context).textTheme.subhead,
              //     ),
              //   )
              ? SizedBox(height: 0)
              : SizedBox(height: 0),
          setting.value.enableVersion!
              ? ListTile(
                  dense: true,
                  title: Text(
                    'Versión: ' + " 1.0.0", // + setting.value.appVersion,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la url $url';
    }
  }
}
