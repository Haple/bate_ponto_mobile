import 'dart:convert';

class Jornada {
  int codigo;
  String nome;
  String entrada1;
  String saida1;
  String entrada2;
  String saida2;
  int codEmpresa;
  int cargaDiaria;

  Jornada({
    this.codigo,
    this.nome,
    this.entrada1,
    this.saida1,
    this.entrada2,
    this.saida2,
    this.codEmpresa,
    this.cargaDiaria,
  });

  factory Jornada.fromJson(Map<String, dynamic> map) {
    return Jornada(
      codigo: map["codigo"],
      nome: map["nome"],
      entrada1: map["entrada1"],
      saida1: map["saida1"],
      entrada2: map["entrada2"],
      saida2: map["saida2"],
      codEmpresa: map["cod_empresa"],
      cargaDiaria: map["carga_diaria"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "nome": nome,
      "entrada1": entrada1,
      "saida1": saida1,
      "entrada2": entrada2,
      "saida2": saida2,
      "cod_empresa": codEmpresa,
      "carga_diaria": cargaDiaria
    };
  }

  @override
  String toString() {
    return 'Jornada { ' +
        'codigo: $codigo, ' +
        'nome: $nome,' +
        'entrada1: $entrada1,' +
        'saida1: $saida1,' +
        'entrada2: $entrada2,' +
        'saida2: $saida2,' +
        'cod_empresa: $codEmpresa,' +
        'carga_diaria: $cargaDiaria}';
  }
}

List<Jornada> jornadasFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Jornada>.from(data.map((item) => Jornada.fromJson(item)));
}

String jornadaToJson(Jornada data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
