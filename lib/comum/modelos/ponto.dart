import 'dart:convert';

class Ponto {
  int codigo;
  String criadoEm;
  String latitude;
  String longitude;
  String localizacao;
  int codEmpregado;

  Ponto({
    this.codigo,
    this.criadoEm,
    this.latitude,
    this.longitude,
    this.localizacao,
    this.codEmpregado,
  });

  factory Ponto.fromJson(Map<String, dynamic> map) {
    return Ponto(
      codigo: map["codigo"],
      criadoEm: map["criado_em"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      localizacao: map["localizacao"],
      codEmpregado: map["cod_empregado"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "criado_em": criadoEm,
      "latitude": latitude,
      "longitude": longitude,
      "localizacao": localizacao,
      "cod_empregado": codEmpregado,
    };
  }

  @override
  String toString() {
    return 'Jornada { ' +
        'codigo: $codigo, ' +
        'criado_em: $criadoEm,' +
        'latitude: $latitude,' +
        'longitude: $longitude,' +
        'localizacao: $localizacao,' +
        'cod_empregado: $codEmpregado}';
  }
}

List<Ponto> pontosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Ponto>.from(data.map((item) => Ponto.fromJson(item)));
}

String pontoToJson(Ponto data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
