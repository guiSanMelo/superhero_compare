import 'package:flutter/material.dart';
import '../models/heroes_dto.dart';
import 'package:superhero_compare/shared/app_bar.dart';

class InfoHero extends StatelessWidget {
  final Heroes hero;

  const InfoHero({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F1E1),

        appBar: const CustomAppBar(
          title: "HeroCompare",
          showBackButton: true,
        ),

        body: Column(
          children: [
            const SizedBox(height: 20),

            // HERO IMAGE
            Container(
              width: 200,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  hero.heroImage.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // HERO NAME
            Text(
              hero.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // TAB BAR
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: "Biografia"),
                Tab(text: "Aparência"),
                Tab(text: "Stats"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // BIOGRAPHY
                  _InfoSection(
                    items: [
                      ["Nome completo", hero.biography.fullName],
                      ["Publisher", hero.biography.publisher],
                      ["Alinhamento", hero.biography.alignment],
                      ["Primeira aparição", hero.biography.firstAppearance],
                      ["Local de nascimento", hero.biography.placeOfBirth],
                    ],
                  ),

                  // APPEARANCE
                  _InfoSection(
                    items: [
                      ["Gênero", hero.appearance.gender],
                      ["Raça", hero.appearance.race],
                      ["Altura", hero.appearance.height.join(" / ")],
                      ["Peso", hero.appearance.weight.join(" / ")],
                      ["Olhos", hero.appearance.eyeColor],
                      ["Cabelo", hero.appearance.hairColor],
                    ],
                  ),

                  // STATS (BARRAS)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        PowerStatBar(
                          label: "Inteligência",
                          value: _safeParse(hero.powerstats.intelligence),
                        ),
                        const SizedBox(height: 14),

                        PowerStatBar(
                          label: "Força",
                          value: _safeParse(hero.powerstats.strength),
                        ),
                        const SizedBox(height: 14),

                        PowerStatBar(
                          label: "Velocidade",
                          value: _safeParse(hero.powerstats.speed),
                        ),
                        const SizedBox(height: 14),

                        PowerStatBar(
                          label: "Durabilidade",
                          value: _safeParse(hero.powerstats.durability),
                        ),
                        const SizedBox(height: 14),

                        PowerStatBar(
                          label: "Poder",
                          value: _safeParse(hero.powerstats.power),
                        ),
                        const SizedBox(height: 14),

                        PowerStatBar(
                          label: "Combate",
                          value: _safeParse(hero.powerstats.combat),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _safeParse(String value) {
    return int.tryParse(value) ?? 0;
  }
}

class _InfoSection extends StatelessWidget {
  final List<List<String>> items;

  const _InfoSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item[1].isEmpty ? "Desconhecido" : item[1],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PowerStatBar extends StatelessWidget {
  final String label;
  final int value;

  const PowerStatBar({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 4),
        Text("$value / 100"),
      ],
    );
  }
}