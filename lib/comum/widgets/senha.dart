import 'package:flutter/material.dart';

class Senha extends StatefulWidget {
  final TextEditingController controller;

  const Senha({
    Key key,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SenhaState();
}

class _SenhaState extends State<Senha> {
  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'Senha',
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _mostrarSenha = !_mostrarSenha;
            });
          },
          child: Icon(
            _mostrarSenha ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      obscureText: !_mostrarSenha,
      validator: (valor) {
        Pattern pattern =
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(valor))
          return 'A senha deve ser uma mistura de letras minúsculas,' +
              ' maiúsculas, números e caracteres especiais';
        else
          return null;
      },
    );
  }
}
