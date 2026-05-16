import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';
import 'package:superhero_compare/shared/hero_card.dart'; 

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
      debugPrint("Erro: $e"); // ✅ debugPrint em vez de print
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
        title: const Text("Pesquise seu Herói"),
      ),
      body: isLoaded
    ? heroes == null || heroes!.isEmpty
        ? const Center(child: Text("Nenhum herói encontrado"))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: heroes!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HeroCard(hero: heroes![index]),
              );
            },
          )
    : const Center(child: CircularProgressIndicator()),
    );
  }
}