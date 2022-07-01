import 'package:flutter/material.dart';

class corpo extends StatelessWidget {
  const corpo({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return cor_de_fundo();
  }
}

class cor_de_fundo extends StatelessWidget {
  final Widget child;
  const cor_de_fundo({
    Key? key,
    @required this.child,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
