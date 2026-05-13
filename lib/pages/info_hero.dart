import 'package:flutter/material.dart';

class InfoHero extends StatefulWidget {
  const InfoHero({super.key});

  @override
  State<InfoHero> createState() => _InfoHero();
}

class _InfoHero extends State<InfoHero> {





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Seu Heroi"
        ),
      ),
    );
  }
}