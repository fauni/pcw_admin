import 'package:flutter/material.dart';
import 'package:pcw_admin/src/pages/atencionsinres_page.dart';
import 'package:pcw_admin/src/pages/login_page.dart';
import 'package:pcw_admin/src/pages/main_page.dart';
import 'package:pcw_admin/src/pages/splash_page.dart';

import 'models/route_argument.dart';
import 'pages/AddVehiculoWidget.dart';
import 'pages/addcliente_page.dart';
import 'pages/midetalleatencion_page.dart';
import 'pages/misatenciones_page.dart';
import 'pages/modelo_vehiculo_page.dart';
import 'pages/recepcion_page.dart';
import 'pages/vehiculos_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/Main':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/AtencionSinRes':
        return MaterialPageRoute(builder: (_) => AtencionsinresPage());
      case '/MisAtenciones':
        return MaterialPageRoute(builder: (_) => MisAtencionesPage());
      case '/ModeloVehiculo':
        return MaterialPageRoute(builder: (_) => ModeloVehiculoPage());
      case '/MiDetalleAtencion':
        return MaterialPageRoute(
            builder: (_) =>
                MiDetalleAtencionPage(routeArgument: args as RouteArgument));
      case '/AddVehiculo':
        return MaterialPageRoute(builder: (_) => AddVehiculoWidget());

      case '/AddCliente':
        return MaterialPageRoute(builder: (_) => AddClientePage());

      case '/Vehiculos':
        return MaterialPageRoute(builder: (_) => VehiculosPage());
      case '/VerVehiculo':
        return MaterialPageRoute(
            builder: (_) =>
                RecepcionPage(routeArgument: args as RouteArgument));

      case '/Home':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/Recepcion':
        return MaterialPageRoute(
            builder: (_) =>
                RecepcionPage(routeArgument: args as RouteArgument));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: SizedBox(height: 0)));
    }
  }
}
