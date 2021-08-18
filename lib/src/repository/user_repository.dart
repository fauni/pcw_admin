import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:pcw_admin/src/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/user_repository.dart' as userRepo;

ValueNotifier<Usuario> currentUser = new ValueNotifier(Usuario());

Future<Usuario> login(Usuario usuario) async {
  usuario.id = "0";
  usuario.apellidoPaterno = "";
  usuario.apellidoMaterno = "";
  usuario.nombres = "";
  usuario.email = "cliente@carwash.net";
  // print(json.encode(usuario.toMap()));
  final String url =
      '${GlobalConfiguration().getString('api_base_url_wash')}usuario/login';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(usuario.toJson()),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> responseJson = json.decode(response.body);
    print(responseJson['status']);
    if (responseJson['status'] == 404) {
      return new Usuario();
    } else {
      setCurrentUser((response.body));
      currentUser.value =
          Usuario.fromJson(json.decode(response.body)['body'][0]);
    }
  } else {
    throw new Exception(response.body);
  }
  return currentUser.value;
}

Future<void> logout() async {
  currentUser.value = new Usuario();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['body'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', json.encode(json.decode(jsonString)['body'][0]));
  }
}

Future<Usuario> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value =
        Usuario.fromJson(json.decode(prefs.getString('current_user') ?? ''));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}
