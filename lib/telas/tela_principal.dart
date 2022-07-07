import 'package:catalogo/banco/banco_local.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

var url = Uri.parse('https://webmc.com.br/ws/mobile/');

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {


    Future<List<GetClientes>> fetchJSONData() async {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String senhabase64 = stringToBase64.encode(UsuarioClasse().senha);

      String funcao = "funcao=consulta_clientes" +
          "&usuario=" + UsuarioClasse().user+
          "&senha=" + senhabase64;

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
          body: funcao);


      String resposta = '';
      resposta = response.body.toString();
      if (resposta.contains("cn")) {
        final jsonItems =
        json.decode(response.body).cast<Map<String, dynamic>>();

        List<GetClientes> clienteLista = jsonItems.map<GetClientes>((json) {
          return GetClientes.fromJson(json);
        }).toList();

        return clienteLista;
      } else {
        throw Exception('Failed to load data from internet');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: FutureBuilder<List<GetClientes>>(
        future: fetchJSONData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map(
                  (cliente) => ListTile(
                    title: Text(cliente.nome),
                    onTap: () {
                      print(cliente.nome);
                    },
                    subtitle: Text(cliente.telefone),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(cliente.nome[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          )),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class GetClientes {
  int id;
  String nome;
  String telefone;

  GetClientes({this.id, this.nome, this.telefone});

  factory GetClientes.fromJson(Map<String, dynamic> json) {
    return GetClientes(
      id: json['id'],
      nome: json['no'],
      telefone: json['tl'],
      );
  }
}
