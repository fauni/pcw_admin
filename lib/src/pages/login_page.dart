import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/user_controller.dart';

import '../repository/user_repository.dart' as userRepo;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends StateMVC<LoginPage> {
  LoginPageState() : super(UserController()) {
    con = controller as UserController;
  }
  late UserController con;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (userRepo.currentUser.value.username != null) {
      Navigator.of(context).pushReplacementNamed('/Main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: con.scaffoldKey,
        body: Stack(
          children: [
            Image.asset(
              'assets/img/fondo_car.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListView(
              padding: EdgeInsets.only(top: 100),
              shrinkWrap: true,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: con.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/img/logo_horizontal.png',
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: '',
                          onSaved: (input) => con.usuario.username = input,
                          decoration: InputDecoration(
                            labelText: 'Nombre de Usuario',
                            labelStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                            contentPadding: EdgeInsets.all(20),
                            hintText: 'Nombre de Usuario',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
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
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: '',
                          onSaved: (input) => con.usuario.password = input,
                          obscureText: con.hidePassword,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelText: 'Contraseña',
                            labelStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                            contentPadding: EdgeInsets.all(20),
                            hintText: '••••••••••••',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            // prefixIcon: Icon(
                            //   Icons.lock_outline,
                            //   color: Theme.of(context).accentColor,
                            // ),
                            suffixIcon: IconButton(
                              icon: Icon(con.hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                setState(() {
                                  con.hidePassword = !con.hidePassword;
                                });
                              },
                            ),
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
                        SizedBox(height: 40),
                        ButtonTheme(
                          minWidth: double.infinity,
                          height: 60,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 80),
                            onPressed: () {
                              con.login(context);
                            },
                            child: Text(
                              'Iniciar Sesión',
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
