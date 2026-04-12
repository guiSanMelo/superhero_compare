import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: const Text("SuperHero Compare")),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator()),
        child: ListView.builder(
          itemCount: heroes?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heroes![index].name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Image.network(heroes![index].heroImage.url),

                  Container( child: Column(
                    children: heroes![index].powerstats.stats.map((stat) {
                  return Text("${stat['label']}: ${stat['value']}");
                  }).toList(),
                  ),),

                  Container( child: Column(
                    children: heroes![index].biography.stats.map((stat) {
                  return Text("${stat['label']}: ${stat['value']}");
                  }).toList(),
                  ),),

                  Container( child: Column(
                    children: heroes![index].work.stats.map((stat) {
                  return Text("${stat['label']}: ${stat['value']}");
                  }).toList(),
                  ),),

                  Container( child: Column(
                    children: heroes![index].connections.stats.map((stat) {
                  return Text("${stat['label']}: ${stat['value']}");
                  }).toList(),
                  ),),
                ]
              ),
            );
          },
        ),
      ),
    );
  }
}
