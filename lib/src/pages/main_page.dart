import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/reserva_controller.dart';
import 'package:pcw_admin/src/widgets/DrawerWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends StateMVC<MainPage> {
  double? width_size;
  double? height_size;

  _MainPageState() : super(ReservaController()) {
    _con = controller as ReservaController;
  }

  late ReservaController _con;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    width_size = MediaQuery.of(context).size.width;
    height_size = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: Theme.of(context).hintColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh), // FaIcon(FontAwesomeIcons.syncAlt),
              onPressed: () {
                _con.refreshHome();
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: ValueListenableBuilder(
            valueListenable: settingsRepo.setting,
            builder: (context, value, child) {
              return Text(
                'PCW Admin',
                style: TextStyle(color: Theme.of(context).hintColor),
              );
            },
          ),
        ),
        drawer: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Colors.transparent.withOpacity(0.5)),
          child: DrawerWidget(),
        ),
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
              padding: EdgeInsets.only(top: 200, bottom: 80),
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: _con.reservasInner.isEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context).accentColor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/not_found.png',
                                width: 100,
                              ),
                              Text(
                                'No encontramos reservas',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Presiona actualizar para ver \n si ya existen  reservas \n o puedes la realizar atención \n sin reserva',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ButtonTheme(
                                minWidth: double.infinity,
                                height: 50,
                                child: RaisedButton.icon(
                                  color: Colors.transparent,
                                  textColor: Theme.of(context).hintColor,
                                  onPressed: () {
                                    _con.refreshHome();
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.sync,
                                    color: Theme.of(context).accentColor,
                                    size: 35,
                                  ),
                                  label: Text('Actualizar'),
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
                          ),
                        )
                      : GridView.count(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 20,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4,
                          children: List.generate(
                            _con.reservasInner.length,
                            (index) {
                              return Container();
                              // return ReservaGridItemWidget(
                              //   heroTag: 'reserva_grid',
                              //   reserva: _con.reservasInner.elementAt(index),
                              //   onDismissed: () {
                              //     _con.refreshHome();
                              //   },
                              // );
                            },
                          ),
                        )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                    onPressed: () {
                      // _con.login();
                      Navigator.of(context).pushNamed('/AtencionSinRes');
                    },
                    child: Text(
                      'Atención sin Reverva',
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
      ),
    );
  }
}
