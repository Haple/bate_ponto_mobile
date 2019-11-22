import 'package:bate_ponto_mobile/login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comum/funcoes/get_token.dart';
import 'comum/funcoes/parse_jwt.dart';
import 'comum/modelos/ponto.dart';

class Inicio extends StatefulWidget {
  static String rota = '/inicio';
  static String titulo = 'Início';

  @override
  _InicioState createState() => new _InicioState();
}

class _InicioState extends State<Inicio> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  var bancoHoras = 0;

  @override
  void initState() {
    super.initState();
    buscaBancoHoras();
  }

  Future<void> buscaBancoHoras() async {
    var payload = parseJwt(await getToken());
    setState(() {
      this.bancoHoras = new Duration(minutes: payload["banco_horas"]).inHours;
    });
  }

  Future<List<Ponto>> _buscaPontos() async {
    final url = "https://bate-ponto-backend.herokuapp.com/pontos";

    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return pontosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os pontos");
    }
  }

  Future<void> _baterPonto() async {
    final url = "https://bate-ponto-backend.herokuapp.com/pontos";
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    var rua =
        placemark[0].thoroughfare != null ? placemark[0].thoroughfare : "";
    var numero = placemark[0].subThoroughfare != null
        ? ", " + placemark[0].subThoroughfare
        : "";
    var bairro =
        placemark[0].subLocality != null ? ", " + placemark[0].subLocality : "";
    var cidade = placemark[0].subAdministrativeArea != null
        ? " - " + placemark[0].subAdministrativeArea
        : "";
    var localizacao = "$rua$numero$bairro$cidade";
    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    Map<String, String> body = {
      'latitude': currentLocation.latitude.toString(),
      'longitude': currentLocation.longitude.toString(),
      'localizacao': localizacao
    };
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      throw new Exception("Não foi possível bater o ponto");
    }
  }

  Widget _botaoBaterPonto() {
    return MaterialButton(
      height: 80,
      padding: EdgeInsets.all(10),
      minWidth: double.maxFinite, // set minWidth to maxFinite
      color: Colors.greenAccent.shade700,
      onPressed: _baterPonto,
      child: Text(
        "BATER PONTO",
        style: new TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _bancoHoras() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Banco de horas:",
              style: Theme.of(context).textTheme.title,
            ),
            Container(
              child: Text(
                (bancoHoras >= 0 ? "+" : "") + "${bancoHoras}h",
                style: TextStyle(
                  fontSize: 24,
                  color: bancoHoras >= 0
                      ? Colors.green.shade500
                      : Colors.red.shade500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _botaoSair() {
    return IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (BuildContext context) => Login(),
            ),
          );
        });
  }

  Widget _buildListaPontos(List<Ponto> pontos) {
    Widget lista = ListView.builder(
      itemBuilder: (context, index) {
        Ponto ponto = pontos[index];
        ponto.criadoEm = new DateFormat("dd/MM/yyyy - HH:mm")
            .format(DateTime.parse(ponto.criadoEm));
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 12, bottom: 20, right: 12),
              child: Column(
                children: [
                  Text(
                    "${ponto.criadoEm}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    // alignment: Alignment.center,
                    width: 300,
                    child: Text(
                      "${ponto.localizacao}",
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: pontos.length,
    );

    if (pontos.length == 0) lista = Text("Nenhum ponto registrado");

    return Center(
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        child: lista,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _buscaPontos(),
        builder: (BuildContext context, AsyncSnapshot<List<Ponto>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Não foi possível buscar os pontos"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Ponto> pontos = snapshot.data;
            Widget botaoBaterPonto = _botaoBaterPonto();
            Widget banco = _bancoHoras();
            Widget lista = _buildListaPontos(pontos);
            Widget botaoSair = _botaoSair();
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[botaoSair],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: botaoBaterPonto,
                  ),
                  banco,
                  Expanded(
                    child: lista,
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
