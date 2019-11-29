import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'comum/funcoes/get_token.dart';
import 'comum/modelos/abono.dart';
import 'comum/widgets/add_abono_dialog.dart';

class AbonoTela extends StatefulWidget {
  static String rota = '/abono';
  static String titulo = 'Abono';

  @override
  AbonoTelaState createState() => new AbonoTelaState();
}

class AbonoTelaState extends State<AbonoTela> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Abono>> _buscaAbonos() async {
    final url = "https://bate-ponto-backend.herokuapp.com/abonos";

    Map<String, String> headers = {
      'Authorization': await getToken(),
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return abonosFromJson(response.body);
    } else {
      throw new Exception("Não foi possível buscar os abonos");
    }
  }

  Widget _botaoSolicitarAbono() {
    return MaterialButton(
      height: 60,
      padding: EdgeInsets.all(10),
      minWidth: double.maxFinite, // set minWidth to maxFinite
      color: Colors.blue.shade500,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddAbonoDialog(
              abonoTelaState: this,
            );
          },
        );
      },
      child: Text(
        "SOLICITAR ABONO",
        style: new TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _statusSoliciacaoAbono(bool aprovado) {
    Icon icone;
    if (aprovado == null)
      icone = Icon(
        Icons.watch_later,
        color: Colors.grey.shade500,
      );
    else if (aprovado == true)
      icone = Icon(
        // Icons.check,
        Icons.thumb_up,
        color: Colors.green.shade500,
      );
    else
      icone = Icon(
        // Icons.cancel,
        Icons.thumb_down,
        color: Colors.red.shade500,
      );

    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: icone,
    );
  }

  Widget _buildListaAbonos(List<Abono> abonos) {
    Widget lista = ListView.builder(
      itemBuilder: (context, index) {
        Abono abono = abonos[index];
        abono.dataAbonada = new DateFormat("dd/MM/yyyy")
            .format(DateTime.parse(abono.dataAbonada));
        abono.dataSolicitacao = new DateFormat("dd/MM/yyyy - HH:mm")
            .format(DateTime.parse(abono.dataSolicitacao));
        return Container(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          child: Card(
            margin: EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statusSoliciacaoAbono(abono.aprovado),
                  Text(
                    "${abono.dataAbonada}",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: abonos.length,
    );

    if (abonos.length == 0) lista = Text("Nenhum abono solicitado ainda");

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
        future: _buscaAbonos(),
        builder: (BuildContext context, AsyncSnapshot<List<Abono>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Não foi possível buscar os abonos"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Abono> pontos = snapshot.data;
            Widget lista = _buildListaAbonos(pontos);
            Widget botaoSolicitarAbono = _botaoSolicitarAbono();
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: botaoSolicitarAbono,
                  ),
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
