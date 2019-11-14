import 'package:flutter/material.dart';

class NomeCompleto extends StatefulWidget {
  final TextEditingController controller;

  const NomeCompleto({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _NomeCompletoState();
}

class _NomeCompletoState extends State<NomeCompleto> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (valor) => valor.isEmpty ? 'Nome é obrigatório' : null,
      decoration: new InputDecoration(
        labelText: "Nome completo",
      ),
    );
  }
}
