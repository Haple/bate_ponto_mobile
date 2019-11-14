import 'package:flutter/material.dart';

_evento() {}

void exibeAlerta({
  @required BuildContext contexto,
  @required String titulo,
  @required String mensagem,
  @required String labelBotao,
  Function evento = _evento,
}) {
  showDialog(
    context: contexto,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(mensagem),
        actions: <Widget>[
          new FlatButton(
            child: new Text(labelBotao),
            onPressed: () {
              Navigator.of(context).pop();
              evento();
            },
          ),
        ],
      );
    },
  );
}

void exibeConfirmacao({
  @required BuildContext contexto,
  @required String titulo,
  @required String mensagem,
  @required String labelConfirmar,
  Function eventoConfirmar = _evento,
  @required String labelCancelar,
  Function eventoCancelar = _evento,
}) {
  showDialog(
    context: contexto,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(mensagem),
        actions: <Widget>[
          new FlatButton(
            child: new Text(labelConfirmar),
            onPressed: () {
              eventoConfirmar();
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(labelCancelar),
            onPressed: () {
              eventoCancelar();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
