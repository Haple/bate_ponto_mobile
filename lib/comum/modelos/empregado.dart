import 'dart:convert';

class Empregado {
  int codigo;
  String nome;
  String cpf;
  String email;
  String senha;
  String celular;
  int bancoHoras;
  int codEmpresa;
  int codJornada;
  bool confirmado;
  bool enviarLembrete;

  Empregado(
      {this.codigo,
      this.nome,
      this.cpf,
      this.email,
      this.senha,
      this.celular,
      this.bancoHoras,
      this.codEmpresa,
      this.codJornada,
      this.confirmado,
      this.enviarLembrete});

  factory Empregado.fromJson(Map<String, dynamic> map) {
    return Empregado(
      codigo: map["codigo"],
      nome: map["nome"],
      cpf: map["cpf"],
      email: map["email"],
      celular: map["celular"],
      bancoHoras: map["banco_horas"],
      codEmpresa: map["cod_empresa"],
      codJornada: map["cod_jornada"],
      confirmado: map["confirmado"],
      enviarLembrete: map["enviar_lembrete"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "nome": nome,
      "cpf": cpf,
      "email": email,
      "senha": senha,
      "celular": celular,
      "banco_horas": bancoHoras,
      "cod_empresa": codEmpresa,
      "cod_jornada": codJornada,
      "confirmado": confirmado,
      "enviar_lembrete": enviarLembrete,
    };
  }

  @override
  String toString() {
    return 'Empregado {codigo: $codigo, nome: $nome, cpf: $cpf' +
        'email: $email, senha: $senha, celular: $celular, ' +
        'banco_horas: $bancoHoras,cod_empresa: $codEmpresa,' +
        'cod_jornada: $codJornada,confirmado: $confirmado,' +
        'enviar_lembrete: $enviarLembrete}';
  }
}

List<Empregado> empregadosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Empregado>.from(data.map((item) => Empregado.fromJson(item)));
}

String empregadoToJson(Empregado data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
