import 'package:flutter/material.dart';

class Celular extends StatefulWidget {
  final TextEditingController controller;

  const Celular({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CelularState();
}

class _CelularState extends State<Celular> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (valor) {
        Pattern pattern =
            r'(\({0,1}\d{0,2}\){0,1} {0,1})(\d{4,5}) {0,1}-{0,1}(\d{4})';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(valor))
          return 'Celular inválido';
        else
          return null;
      },
      decoration: new InputDecoration(
        labelText: "Celular",
      ),
    );
  }
}
