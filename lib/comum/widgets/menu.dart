import 'package:bate_ponto_mobile/comum/funcoes/get_token.dart';
import 'package:bate_ponto_mobile/home.dart';
import 'package:bate_ponto_mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_route_observer.dart';

class Menu extends StatefulWidget {
  const Menu({@required this.permanentlyDisplay, Key key}) : super(key: key);

  final bool permanentlyDisplay;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with RouteAware {
  String _rotaSelecionada;
  AppRouteObserver _routeObserver;

  @override
  void initState() {
    super.initState();
    _buscaToken();
    _routeObserver = AppRouteObserver();
  }

  void _buscaToken() async {
    if ((await getToken()) == null) {
      await _navigateTo(context, Login.rota);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 55.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              // padding: EdgeInsets.all(10),
              children: [
                logo,
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(Home.titulo),
                  onTap: () async {
                    await _navigateTo(context, Home.rota);
                  },
                  selected: _rotaSelecionada == Home.rota,
                ),
                const Divider(),
                ListTile(
                    leading: const Icon(Icons.power_settings_new),
                    title: Text("Sair"),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('token');
                      await _navigateTo(context, Login.rota);
                    }),
              ],
            ),
          ),
          if (widget.permanentlyDisplay)
            const VerticalDivider(
              width: 1,
            )
        ],
      ),
    );
  }

  Future<void> _navigateTo(BuildContext context, String rota) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushReplacementNamed(context, rota);
  }

  void _updateSelectedRoute() {
    setState(() {
      _rotaSelecionada = ModalRoute.of(context).settings.name;
    });
  }
}
