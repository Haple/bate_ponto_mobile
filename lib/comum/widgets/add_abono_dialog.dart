import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:bate_ponto_mobile/abono.dart';
import 'package:bate_ponto_mobile/comum/funcoes/exibe_alerta.dart';
import 'package:bate_ponto_mobile/comum/funcoes/get_token.dart';
import 'package:bate_ponto_mobile/comum/modelos/abono.dart';
import 'package:bate_ponto_mobile/comum/widgets/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddAbonoDialog extends StatefulWidget {
  final AbonoTelaState abonoTelaState;
  const AddAbonoDialog({
    Key key,
    @required this.abonoTelaState,
  });

  @override
  State<StatefulWidget> createState() => _AddAbonoDialogState();
}

class _AddAbonoDialogState extends State<AddAbonoDialog> {
  final formKey = new GlobalKey<FormState>();
  final TextEditingController _dataAbonada = TextEditingController();
  final TextEditingController _motivo = TextEditingController();
  File _anexo;

  void _salvar() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Abono abono = new Abono(
        motivo: _motivo.text,
        dataAbonada: _dataAbonada.text,
      );
      try {
        int codAbono = await _criarAbono(abono);
        if (_anexo != null) {
          print("Enviando anexo do abono $codAbono");
          await _enviarAnexo(codAbono);
        }
        exibeAlerta(
          contexto: context,
          titulo: "Tudo certo",
          mensagem: "Abono solicitado!",
          labelBotao: "Ok",
          evento: () {
            widget.abonoTelaState.setState(() {});
            Navigator.of(context).pop();
          },
        );
      } catch (e) {
        exibeAlerta(
          contexto: context,
          titulo: "Opa",
          mensagem: "${e.toString()}",
          labelBotao: "Tentar novamente",
        );
      }
    }
  }

  Future<int> _criarAbono(Abono abono) async {
    var token = await getToken();

    final url = "https://bate-ponto-backend.herokuapp.com/abonos";
    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      url,
      headers: headers,
      body: abonoToJson(abono),
    );
    final responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseJson["codigo"];
    } else if (responseJson['erro'] != null) {
      throw responseJson['erro'];
    } else {
      throw "Não foi possível solicitar abono";
    }
  }

  Future _enviarAnexo(int codAbono) async {
    final url =
        "https://bate-ponto-backend.herokuapp.com/abonos/$codAbono/anexos";
    Map<String, String> headers = {
      'Authorization': await getToken(),
    };

    final mimeTypeData =
        lookupMimeType(_anexo.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
    final file = await http.MultipartFile.fromPath('anexo', _anexo.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.headers.addAll(headers);
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _selecionarImagem() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _anexo = image;
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final titulo = new Center(
      child: new Text(
        "Solicitação de Abono",
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    final textoMotivo = TextFormField(
      controller: _motivo,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 8,
      autofocus: false,
      validator: (valor) => valor.isEmpty ? 'Motivo é obrigatório' : null,
      decoration: new InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Motivo do abono",
      ),
    );

    final botaoSelecionaAnexo = new RaisedButton(
      onPressed: _selecionarImagem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_alt),
          SizedBox(
            width: 5.0,
          ),
          _anexo == null ? Text('Selecionar anexo') : Text('Trocar anexo'),
        ],
      ),
    );

    final botaoSolicitar = new RaisedButton(
      child: new Text(
        "Solicitar",
        style: new TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      onPressed: _salvar,
    );

    final formulario = new Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        // padding: EdgeInsets.all(10),
        children: <Widget>[
          titulo,
          SizedBox(height: 28.0),
          new Data(
            controller: _dataAbonada,
            label: "Data abonada",
          ),
          SizedBox(height: 8.0),
          textoMotivo,
          SizedBox(height: 8.0),
          botaoSelecionaAnexo,
          SizedBox(height: 8.0),
          botaoSolicitar,
        ],
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 420.0,
        width: 450.0,
        padding: EdgeInsets.all(15.0),
        child: formulario,
      ),
    );
  }
}
