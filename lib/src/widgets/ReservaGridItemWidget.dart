import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pcw_admin/src/controllers/reserva_controller.dart';
import 'package:pcw_admin/src/models/reserva_inner.dart';
import 'package:pcw_admin/src/pages/atencion_page.dart';
import 'package:pcw_admin/src/pages/recepcion_page.dart';

import '../models/route_argument.dart';

class ReservaGridItemWidget extends StatefulWidget {
  final String? heroTag;
  final ReservaInner? reserva;
  VoidCallback? onDismissed;

  ReservaGridItemWidget(
      {Key? key, this.heroTag, this.reserva, this.onDismissed})
      : super(key: key);

  @override
  _ReservaGridItemWidgetState createState() => _ReservaGridItemWidgetState();
}

class _ReservaGridItemWidgetState extends StateMVC<ReservaGridItemWidget> {
  _ReservaGridItemWidgetState() : super(ReservaController()) {
    _con = controller as ReservaController;
  }
  late ReservaController _con;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.reserva);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        _navigateAndDisplaySelection(context, widget.reserva!.estado!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.reserva!.estado == 'L'
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          border: Border.all(color: Theme.of(context).accentColor),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.reserva!.horaReserva!,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    widget.reserva!.fechaReserva!,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  Image.asset(
                    'assets/img/auto_on.png',
                    width: 50,
                  ),
                  Text(
                    widget.reserva!.placa!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            widget.reserva!.estado == 'L'
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/img/en_proceso_white.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context, String estado) async {
    if (estado == 'L') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AtencionPage(
            routeArgument: new RouteArgument(
                id: widget.reserva!.id,
                param: [widget.reserva, widget.heroTag]),
          ),
        ),
      );

      if (result != null) {
        if (result) {
          widget.onDismissed!.call();
        }
      }
    } else {
      //Container();
      //print(json.encode(widget.reserva));
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecepcionPage(
            routeArgument: new RouteArgument(
                id: widget.reserva!.id,
                param: [widget.reserva, widget.heroTag]),
          ),
        ),
      );
      if (result != null) {
        if (result) {
          widget.onDismissed!.call();
        }
      }
    }
    // Navigator.of(context).pushNamed(
    //   '/Recepcion',
    //   arguments: new RouteArgument(
    //       id: widget.reserva.id, param: [widget.reserva, widget.heroTag]),
    // );
  }
}
