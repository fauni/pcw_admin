import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/splash_page_controller.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends StateMVC<SplashPage> {
  SplashPageState() : super(SplashPageController()) {
    con = controller as SplashPageController;
  }
  late SplashPageController con;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    con.progress.addListener(() {
      double progress = 0;
      con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          Navigator.of(context).pushReplacementNamed('/Main');
          // Navigator.of(context).pushReplacementNamed('/Login');
        } catch (e) {}
      } else if (progress == 41) {
        try {
          Navigator.of(context).pushReplacementNamed('/Login');
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: Stack(
          children: [
            Image.asset(
              'assets/img/fondo_car.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              alignment: Alignment.bottomCenter,
              child: Text(
                'Tu auto, nuestro cuidado',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Theme.of(context).secondaryHeaderColor),
                // color: Colors.white),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/img/isotipo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).secondaryHeaderColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
