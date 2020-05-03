import 'package:bate_ponto_mobile/abono.dart';
import 'package:bate_ponto_mobile/comum/funcoes/get_token.dart';
import 'package:bate_ponto_mobile/inicio.dart';
import 'package:bate_ponto_mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'comum/modelos/indicador.dart';
import 'indicadores.dart';

class MenuShell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuShellState();
  }
}

class _MenuShellState extends State<MenuShell> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Inicio(),
    AbonoTela(),
  ];

  @override
  void initState() {
    super.initState();
    _checaUsuarioLogado();
    _checaIndicadorParaResponder();
  }

  void _checaUsuarioLogado() async {
    if ((await getToken()) == null) {
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
      );
    }
  }

  void _checaIndicadorParaResponder() async {
    List<Indicador> indicadores = await _buscaIndicadores();
    if (indicadores.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Indicadores(
            indicador: indicadores[0],
          ),
        ),
      );
    }
  }

  Future<List<Indicador>> _buscaIndicadores() async {
    final url = "https://bate-ponto-backend.herokuapp.com/indicadores";

    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return indicadoresFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os indicadores");
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              })
        ],
        title: Text('Bate Ponto'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Início'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            title: Text('Abonos'),
          ),
        ],
      ),
    );
  }
}
