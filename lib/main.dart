import 'package:bate_ponto_mobile/comum/widgets/app_route_observer.dart';
import 'package:bate_ponto_mobile/inicio.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final rotas = <String, WidgetBuilder>{
    Login.rota: (context) => Login(),
    Inicio.rota: (context) => Inicio(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arial',
      ),
      home: Login(),
      navigatorObservers: [AppRouteObserver()],
      initialRoute: Login.rota,
      routes: rotas,
      title: 'Bate Ponto',
    );
  }
}
