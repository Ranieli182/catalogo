import 'package:catalogo/telas/tela_login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6F35A5),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TelaLogin(),
    );
  }
}



//static const PrimaryLightColor = Color(0xFFF1E6FF);