/* import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SuperHero Compare")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Visibility(
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

                    Container(
                      child: Column(
                        children: heroes![index].powerstats.stats.map((stat) {
                          return Text("${stat['label']}: ${stat['value']}");
                        }).toList(),
                      ),
                    ),

                    Container(
                      child: Column(
                        children: heroes![index].biography.stats.map((stat) {
                          return Text("${stat['label']}: ${stat['value']}");
                        }).toList(),
                      ),
                    ),

                    Container(
                      child: Column(
                        children: heroes![index].work.stats.map((stat) {
                          return Text("${stat['label']}: ${stat['value']}");
                        }).toList(),
                      ),
                    ),

                    Container(
                      child: Column(
                        children: heroes![index].connections.stats.map((stat) {
                          return Text("${stat['label']}: ${stat['value']}");
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
} */
