import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'comum/funcoes/get_token.dart';
import 'comum/funcoes/parse_jwt.dart';
import 'comum/modelos/ponto.dart';
import 'comum/widgets/menu_scaffold.dart';

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
      padding: EdgeInsets.all(10),
      minWidth: double.maxFinite, // set minWidth to maxFinite
      color: Colors.green.shade500,
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
              "Banco de horas: ",
              style: Theme.of(context).textTheme.title,
            ),
            Container(
              child: Text(
                (bancoHoras >= 0 ? "+" : "") + "$bancoHoras",
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

  Widget _buildListaPontos(List<Ponto> pontos) {
    return Center(
      child: Container(
        alignment: Alignment.centerRight,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              Ponto ponto = pontos[index];
              var dataPonto = new DateFormat("dd/MM/yyyy - HH:mm")
                  .format(DateTime.parse(ponto.criadoEm));
              return ListTile(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "${dataPonto.toString()}",
                    ),
                  ),
                ),
              );
            },
            itemCount: pontos.length,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuScaffold(
      key: scaffoldKey,
      pageTitle: Inicio.titulo,
      body: SafeArea(
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
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    botaoBaterPonto,
                    banco,
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: lista,
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
