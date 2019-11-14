import 'package:flutter/material.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

class Cnpj extends StatefulWidget {
  final TextEditingController controller;

  const Cnpj({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CnpjState();
}

class _CnpjState extends State<Cnpj> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (valor) =>
          CNPJValidator.isValid(valor) ? null : 'CNPJ inválido',
      decoration: new InputDecoration(
        labelText: "CNPJ",
        hintText: "00.000.000/0000-00",
      ),
    );
  }
}
