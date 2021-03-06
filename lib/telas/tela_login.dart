import 'dart:convert';
import 'package:catalogo/classes/settings_login.dart';
import 'package:catalogo/componentes/custom_colors.dart';
import 'package:catalogo/schemas/usuario.dart';
import 'package:catalogo/services/usuario_services.dart';
import 'package:catalogo/telas/tela_principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var url = Uri.parse('https://webmc.com.br/ws/mobile/');
//var url = Uri.parse('http://192.168.1.120:8009/ws/mobile/');

class TelaLogin extends StatefulWidget {
  TelaLogin();

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  SettingsLogin _settingsLogin = SettingsLogin();
  UsuarioService _usuarioService = UsuarioService();


  bool? _isCheckedOffline = false;
  bool? _isCheckedSalvarLogin = false;
  bool? _showPassword = false;
  String? _usuarioNaoCadastrado = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();


  @override
  void initState() {
    _buscarCheckLogin();
    _buscarCheckOffline();
    _bucarDadosLogin();

    super.initState();
  }

  _salvarCheckLogin(bool value) async {
    setState(() {
      _isCheckedSalvarLogin = value;
    });
    _settingsLogin.checkSalvarLogin = _isCheckedSalvarLogin!;
    await _settingsLogin.SalvarSettingsLogin();
  }

  _buscarCheckLogin() async {
    await _settingsLogin.BuscarSettingsLogin();
    if (_settingsLogin.checkOffline) {
      setState(() {
        _isCheckedSalvarLogin = false;
      });
    } else {
      setState(() {
        _isCheckedSalvarLogin = _settingsLogin.checkSalvarLogin;
      });
    }
  }

  _salvarCheckOffline(bool value) async {
    setState(() {
      _isCheckedOffline = value;
    });
    _settingsLogin.checkOffline = _isCheckedOffline!;
    await _settingsLogin.SalvarSettingsLogin();
  }

  _buscarCheckOffline() async {
    await _settingsLogin.BuscarSettingsLogin();
    if (_settingsLogin.checkOffline) {
      setState(() {
        _isCheckedOffline = false;
      });
    } else {
      setState(() {
        _isCheckedOffline = _settingsLogin.checkOffline;
      });
    }
  }

  _bucarDadosLogin() async {
    await _settingsLogin.BuscarSettingsLogin();
    if (_isCheckedSalvarLogin == true) {
      if (_settingsLogin.usuario == null) {
        setState(() {
          _userController.text = '';
        });
      }
      else {
        setState(() {
          _userController.text = _settingsLogin.usuario;
        });
      }
      if (_settingsLogin.senha == null) {
        setState(() {
          _senhaController.text = '';
        });
      } else {
        setState(() {
          _senhaController.text = _settingsLogin.senha;
        });
      }
    }
  }

_login() async {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String senhabase64 = stringToBase64.encode(_senhaController.text);

  String funcao = "funcao=consulta_usuario" +
      "&usuario=" +
      _userController.text +
      "&senha=" +
      senhabase64;

  final response = await http.post(url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: funcao);

  String resposta = '';
  resposta = response.body.toString();

  if (resposta.contains("cn")) {
    if (_usuarioService.getUsuario(_userController.text).isNotEmpty){
      print('achei o vivente');
    } else {
      print("cadastrei o vivente");
      _usuarioService.addUsuario(_userController.text, _senhaController.text);
    }

    if (_settingsLogin.checkSalvarLogin == true) {
      _settingsLogin.usuario = _userController.text;
      _settingsLogin.senha = _senhaController.text;
      await _settingsLogin.SalvarSettingsLogin();

      setState(() {
        _usuarioNaoCadastrado = "";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaPrincipal()),
      );
    } else {
      _settingsLogin.usuario = '';
      _settingsLogin.senha = '';

      await _settingsLogin.SalvarSettingsLogin();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaPrincipal()),
      );
    }
  } else {
    setState(() {
      _usuarioNaoCadastrado = "Usu??rio n??o cadastrado!";
    });
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.grey;
  }
  return Colors.blue;
}

@override
Widget build(BuildContext context) {
  // Size size = MediaQuery.of(context).size;
  return Scaffold(
    body: Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      padding: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 212, 0247, 255),
            ]),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 100,
                  height: 100,
                ),
              ),
              Text(
                "Cat??logo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      //Text usu??rio
                      controller: _userController,
                      style: TextStyle(color: Colors.white),
                      validator: (usuario) {
                        if (usuario!.isEmpty) {
                          return "Digite seu Usu??rio";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Usu??rio",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20)),
                    // Espa??o entre os text
                    TextFormField(
                      //Text senha
                      controller: _senhaController,
                      style: TextStyle(color: Colors.white),
                      validator: (senha) {
                        if (senha!.isEmpty) {
                          return "Digite sua Senha";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword!;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      obscureText: _showPassword == false ? true : false,
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isCheckedSalvarLogin!,
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    onChanged: (bool? value) {
                      _salvarCheckLogin(value!);
                    },
                  ),
                  Text(
                    "Salvar Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Checkbox(
                    value: _isCheckedOffline!,
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    onChanged: (bool? value) {
                      setState(() {
                        _salvarCheckOffline(value!);
                      });
                    },
                  ),
                  Text(
                    "Offline",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white),
                ),
                color: CustomColors().BuscarCorPrincipalBotao(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                _usuarioNaoCadastrado!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}}
