import 'dart:convert';

class Indicador {
  int codigo;
  String titulo;
  String mensagem;

  Indicador({
    this.codigo,
    this.titulo,
    this.mensagem,
  });

  factory Indicador.fromJson(Map<String, dynamic> map) {
    return Indicador(
      codigo: map["codigo"],
      titulo: map["titulo"],
      mensagem: map["mensagem"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "titulo": titulo,
      "mensagem": mensagem,
    };
  }

  @override
  String toString() {
    return indicadorToJson(this);
  }
}

List<Indicador> indicadoresFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Indicador>.from(data.map((item) => Indicador.fromJson(item)));
}

String indicadorToJson(Indicador data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
