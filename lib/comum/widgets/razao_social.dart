import 'package:flutter/material.dart';

class RazaoSocial extends StatefulWidget {
  final TextEditingController controller;

  const RazaoSocial({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _RazaoSocialState();
}

class _RazaoSocialState extends State<RazaoSocial> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (valor) => valor.isEmpty ? 'Razão social inválida' : null,
      decoration: new InputDecoration(
        labelText: "Razão social",
        hintText: "Alpargatas S/A",
      ),
    );
  }
}
