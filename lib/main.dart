import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Arial',
      ),
      home: Login(),
      initialRoute: Login.rota,
      title: 'Bate Ponto',
    );
  }
}
