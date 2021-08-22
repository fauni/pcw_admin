import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';

import 'package:http/http.dart' as http;
import 'package:pcw_admin/src/models/detalle_reserva.dart';
import 'package:pcw_admin/src/models/reserva.dart';
import 'package:pcw_admin/src/models/reserva_inner.dart';

/*Obtiene  reservas de acuerdo al cliente con datos de los vehiculos  */
Future<Stream<List<Reserva>>> obtenerReservasdeHoy() async {
  // Uri uri = Helper.getUriLfr('api/producto');
  // String idcli = currentUser.value.uid; /*cambiar por id del cliente*/
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}reserva/getnow';

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));
  try {
    if (response.statusCode == 200) {
      final lreserva =
          LReserva.fromJsonList(json.decode(response.body)['body']);
      return new Stream.value(lreserva.items);
    } else {
      return new Stream.value([]);
    }
  } catch (e) {
    return new Stream.value([]);
  }
}

Future<Stream<List<ReservaInner>>> obtenerReservasInnerCurrent() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}reserva/getreservascurrent';

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));
  try {
    if (response.statusCode == 200) {
      final lreservaInner =
          LReservaInner.fromJsonList(json.decode(response.body)['body']);
      return new Stream.value(lreservaInner.items);
    } else {
      return new Stream.value([]);
    }
  } catch (e) {
    return new Stream.value([]);
  }
}

String getRutaImg(String nombre) {
  if (nombre == null) {
    return ('http://intranet.lafar.net/images/rav4.jpg'); // cambiar por otra ruta
  } else {
    if (nombre == '') {
      return ('http://intranet.lafar.net/images/rav4.jpg');
    } else {
      return '${GlobalConfiguration().getString('img_carros_url_wash')}' +
          nombre;
    }
  }
}

// Future<dynamic> registrarReserva(String reserva) async {
//   final String url =
//       '${GlobalConfiguration().getString('api_base_url_wash')}reserva/save';
//   final client = new http.Client();
//   final response = await client.post(
//     url,
//     headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     body: reserva,
//   );

//   print(Uri.parse(url));
//   if (response.statusCode == 200) {
//     //setCurrentUser(response.body);
//     //currentUser.value = User.fromJSON(json.decode(response.body)['data']);
//     print(response.body);
//   } else {
//     print(response.body);
//     throw new Exception(response.body);
//   }
//   return reserva;
// }

// Future<String> getReserva() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return await prefs.get('reserva');
// }

// Future<void> setReserva(String reserva) async {
//   if (reserva != null) {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('reserva', reserva);
//   }
// }

Future<Stream<List<DetalleReserva>>> obtenerDetalleReservaPorId(
    String idReserva) async {
  // Uri uri = Helper.getUriLfr('api/producto');
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}detallereserva/getdetallereserva/' +
          idReserva;

  final client = new http.Client();
  final response = await client.get(Uri.parse(url));
  try {
    if (response.statusCode == 200) {
      final ldetalle =
          LDetalleReserva.fromJsonList(json.decode(response.body)['body']);
      return new Stream.value(ldetalle.items);
    } else {
      return new Stream.value([]);
    }
  } catch (e) {
    return new Stream.value([]);
  }
}

Future<dynamic> registrarReserva(String reserva) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}reserva/save';
  final client = new http.Client();
  print("******///*/**//*/*/*/");
  print(reserva);
  print("******///*/**//*/*/*/");

  print(url);
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: reserva,
      ) ;
  //final response = null;
  //print(Uri.parse(url));
  if (response.statusCode == 200) {
   // setCurrentUser(response.body);
   // currentUser.value = User.fromJSON(json.decode(response.body)['data']);
   // print(response.body);
  } else {
  // print(response.body);
    throw new Exception(response.body);
  }
  return reserva;
}

Future<Stream<bool>> registraCambioPrecioDetalleReserva(String atencion) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}reserva/cambiaprecioDetalle';
  final client = new http.Client();
  final response = await client.post(Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: atencion);
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> resp = jsonDecode(response.body)['body'];
      final status = jsonDecode(response.body)['status'];
      if (status == 201) {
        return Stream.value(true);
      } else {
        return Stream.value(false);
      }
    } else {
      return Stream.value(false);
    }
  } catch (e) {
    return Stream.value(false);
  }
}


// Future<bool> registraCambioPrecioDetalleReserva(String reserva) async {
//   bool resp;
//   final String url =
//       '${GlobalConfiguration().getString('api_base_url_wash')}reserva/cambiaprecioDetalle';
//   final client = new http.Client();
//   final response = await client.post(
//     url,
//     headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//     body: reserva,
//   );

//   print(Uri.parse(url));
//   if (response.statusCode == 200) {
//     //setCurrentUser(response.body);
//     //currentUser.value = User.fromJSON(json.decode(response.body)['data']);
//     print(response.body);
//     resp = true;
//   } else {
//     print(response.body);
//     throw new Exception(response.body);
//     resp = false;
//   }
//   return resp;
// }
