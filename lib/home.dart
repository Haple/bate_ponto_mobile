import 'package:flutter/material.dart';

import 'comum/widgets/menu_scaffold.dart';

class Home extends StatefulWidget {
  static String rota = '/home';
  static String titulo = 'Bate ponto';

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Home.titulo,
      floatButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person_add),
      ),
      body: Center(
        child: Text("TELA INICIAL"),
      ),
    );
  }
}
