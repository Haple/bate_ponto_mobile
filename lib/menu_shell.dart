import 'package:bate_ponto_mobile/comum/funcoes/get_token.dart';
import 'package:bate_ponto_mobile/inicio.dart';
import 'package:bate_ponto_mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Inicio(),
    // Inicio(),
  ];

  @override
  void initState() {
    super.initState();
    _checaUsuarioLogado();
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.power_settings_new),
      //         onPressed: () async {
      //           SharedPreferences prefs = await SharedPreferences.getInstance();
      //           prefs.remove('token');
      //           Navigator.of(context).pushReplacement(
      //             new MaterialPageRoute(
      //               builder: (BuildContext context) => Login(),
      //             ),
      //           );
      //         })
      //   ],
      //   title: Text('Bate Ponto'),
      // ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Início'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            title: Text('Abonos'),
          ),
          // new BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   title: Text('Perfil'),
          // )
        ],
      ),
    );
  }
}
