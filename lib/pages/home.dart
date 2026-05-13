import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/pages/info_hero.dart';
import 'package:superhero_compare/services/remote_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  List<Heroes>? heroes;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var result = await RemoteService().getAllHeroes();

      setState(() {
        heroes = result ?? [];
        isLoaded = true;
      });
    } catch (e) {
      print("Erro: $e");

      setState(() {
        heroes = [];
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesquise seu Heroi"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoHero()),
              );
            }, 
            child: Text("Ir para Info Heroi"), // CORRIGIDO: Text definido
          ),
        ],
      ),
    );
  }
}