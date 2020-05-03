import 'dart:convert';

import 'package:bate_ponto_mobile/menu_shell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comum/funcoes/exibe_alerta.dart';
import 'comum/funcoes/get_token.dart';
import 'comum/modelos/indicador.dart';

class Indicadores extends StatefulWidget {
  static String rota = '/indicadores';
  static String titulo = 'Indicadores';

  final Indicador indicador;

  const Indicadores({
    @required this.indicador,
  });

  @override
  IndicadoresState createState() => new IndicadoresState();
}

class IndicadoresState extends State<Indicadores> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _responderIndicador(String resposta) async {
    final baseUrl = "https://bate-ponto-backend.herokuapp.com";
    final url = "$baseUrl/indicadores/${widget.indicador.codigo}/respostas";
    Map<String, String> body = {
      'resposta': resposta,
    };
    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    final response = await http.post(
      url,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuShell(
            checarIndicador: false,
          ),
        ),
      );
    } else {
      exibeAlerta(
        contexto: context,
        titulo: "Opa!",
        mensagem: "Não foi possível responder essa pesquisa.",
        labelBotao: "Tentar novamente",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pesquisa rápida :)",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              "${widget.indicador.titulo}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Colors.grey
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              "\"${widget.indicador.mensagem}\"",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                // color: Colors.grey
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.sentiment_dissatisfied),
                  tooltip: "Discordo",
                  iconSize: 70,
                  color: Colors.red,
                  onPressed: () async {
                    _responderIndicador("DISCORDO");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_neutral),
                  tooltip: "Neutro",
                  iconSize: 70,
                  color: Colors.grey,
                  onPressed: () async {
                    _responderIndicador("NEUTRO");
                  },
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_satisfied),
                  tooltip: "Concordo",
                  iconSize: 70,
                  color: Colors.green,
                  onPressed: () async {
                    _responderIndicador("CONCORDO");
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
