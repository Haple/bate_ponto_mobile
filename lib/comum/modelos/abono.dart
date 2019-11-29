import 'dart:convert';

class Abono {
  int codigo;
  String motivo;
  String dataSolicitacao;
  String dataAbonada;
  String avaliacao;
  int codEmpregado;
  int codAdmin;
  bool aprovado;

  Abono({
    this.codigo,
    this.motivo,
    this.dataSolicitacao,
    this.dataAbonada,
    this.avaliacao,
    this.codEmpregado,
    this.codAdmin,
    this.aprovado,
  });

  factory Abono.fromJson(Map<String, dynamic> map) {
    return Abono(
      codigo: map["codigo"],
      motivo: map["motivo"],
      dataSolicitacao: map["data_solicitacao"],
      dataAbonada: map["data_abonada"],
      codEmpregado: map["cod_empregado"],
      codAdmin: map["cod_admin"],
      aprovado: map["aprovado"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "motivo": motivo,
      "data_solicitacao": dataSolicitacao,
      "data_abonada": dataAbonada,
      "avaliacao": avaliacao,
      "cod_empregado": codEmpregado,
      "cod_admin": codAdmin,
      "aprovado": aprovado,
    };
  }

  @override
  String toString() {
    return 'Abono { ' +
        'codigo: $codigo, ' +
        'motivo: $motivo,' +
        'data_solicitacao: $dataSolicitacao,' +
        'data_abonada: $dataAbonada,' +
        'avaliacao: $avaliacao,' +
        'cod_empregado: $codEmpregado,' +
        'cod_admin: $codAdmin,' +
        'aprovado: $aprovado}';
  }
}

List<Abono> abonosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Abono>.from(data.map((item) => Abono.fromJson(item)));
}

String abonoToJson(Abono data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
