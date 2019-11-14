import 'package:flutter/material.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Cpf extends StatefulWidget {
  final TextEditingController controller;
  final bool habilitado;
  const Cpf({
    Key key,
    this.habilitado = true,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CpfState();
}

class _CpfState extends State<Cpf> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.habilitado,
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (valor) =>
          CPFValidator.isValid(valor) ? null : 'CNPJ inválido',
      style: widget.habilitado ? null : TextStyle(color: Colors.grey.shade500),
      decoration: new InputDecoration(
        enabled: widget.habilitado,
        labelText: "CPF",
        hintText: "000.000.000-00",
      ),
    );
  }
}
