import 'package:flutter/material.dart';
import '../models/heroes_dto.dart';
import '../services/remote_service.dart';
import '../shared/app_bar.dart';
import '../shared/hero_card.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final RemoteService _service = RemoteService();

  List<Heroes> heroes = [];
  List<Heroes> team = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHeroes();
  }

  Future<void> _loadHeroes() async {
    final data = await _service.getHeroesByRange(1, 50);

    setState(() {
      heroes = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "HeroCompare", showBackButton: false),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final hero = index < team.length ? team[index] : null;

                return GestureDetector(
                  onTap: hero != null
                      ? () {
                          setState(() {
                            team.remove(hero);
                          });
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: hero == null
                        ? const Icon(Icons.add, color: Colors.grey)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                hero.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.close, size: 16),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Seleção de Heróis",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: heroes.length,
                    itemBuilder: (context, index) {
                      final hero = heroes[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (team.length < 6 && !team.contains(hero)) {
                                team.add(hero);
                              }
                            });
                          },
                          child: HeroCard(hero: hero),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
