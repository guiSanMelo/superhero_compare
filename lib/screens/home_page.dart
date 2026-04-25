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
      var res = await RemoteService().getAllHeroes();

      setState(() {
        heroes = res ?? [];
        isLoaded = true;
      });

    } catch (e) {

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
            
            final hero = heroes![index];

            return _HeroCard(hero: hero);
          },
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Heroes hero;

  const _HeroCard({required this.hero});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hero.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),

          Image.network(hero.heroImage.url),

          _StatSection(stats: hero.biography.stats),
          _StatSection(stats: hero.powerstats.stats),
          _StatSection(stats: hero.work.stats),
          _StatSection(stats: hero.connections.stats),

        ],
      ),

    );
  }
}

class _StatSection extends StatelessWidget {
  final List<Map<String,dynamic>> stats;

  _StatSection ({required this.stats});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stats.map((stat) {
        return Text("${stat['label']}: ${stat['value']}");
      }).toList()
    );
  }
  
}