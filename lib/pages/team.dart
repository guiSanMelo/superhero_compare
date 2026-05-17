import 'dart:async';
import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';
import 'package:superhero_compare/shared/hero_card.dart';
import 'package:superhero_compare/shared/app_bar.dart';
import 'package:superhero_compare/shared/filter_button.dart';

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final RemoteService _service = RemoteService();

  int selecionandoSlot = -1;
  int poderTotal = 0;
  List<Heroes> heroes = [];
  List<Heroes> filteredHeroes = [];
  List<Heroes> team = [];

  bool isLoading = true;

  AlignmentFilter _selectedAlignment = AlignmentFilter.all;
  double _powerMin = 0;

  @override
  void initState() {
    super.initState();
    _loadHeroes();
  }

  Future<void> _loadHeroes() async {
    final data = await _service.getHeroesByRange(1, 50);

    setState(() {
      heroes = data;
      filteredHeroes = data;
      isLoading = false;
    });
  }

  void _applyFilters(AlignmentFilter alignment, double powerMin) {
    setState(() {
      _selectedAlignment = alignment;
      _powerMin = powerMin;

      filteredHeroes = heroes.where((hero) {
        final alignmentStr = hero.biography.alignment.toLowerCase();

        final passaAlignment = switch (_selectedAlignment) {
          AlignmentFilter.hero => alignmentStr == 'good',
          AlignmentFilter.villain => alignmentStr == 'bad',
          AlignmentFilter.neutral => alignmentStr != 'good' && alignmentStr != 'bad',
          AlignmentFilter.all => true,
        };

        final totalPower = [
          hero.powerstats.intelligence,
          hero.powerstats.strength,
          hero.powerstats.speed,
          hero.powerstats.durability,
          hero.powerstats.power,
          hero.powerstats.combat,
        ].fold<int>(0, (sum, v) => sum + (int.tryParse(v) ?? 0));

        return passaAlignment && totalPower >= _powerMin;
      }).toList();
    });
  }

  void _calcularPoderTotal() {
    // if (team.length != 6) return;
    setState(() {
      poderTotal = team.fold<int>(0, (soma, h) => soma + (int.tryParse(h.powerstats.power) ?? 0));
    });
  }

  void _ativarSelecaoSlot(int slot) {
    setState(() {
      selecionandoSlot = slot;
    });
  }

  void _adicionarHeroiAoSlot(Heroes hero) {
    if (team.contains(hero)) return;

    setState(() {
      team.add(hero);
      selecionandoSlot = -1;
    });

    _calcularPoderTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "HeroCompare", showBackButton: false),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Text('Poder total: $poderTotal'),

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
                  onTap: hero == null
                      ? () => _ativarSelecaoSlot(index)
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selecionandoSlot == index ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selecionandoSlot == index ? Colors.black : Colors.black12,
                        width: selecionandoSlot == index ? 2 : 1,
                      ),
                    ),
                    child: hero == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: selecionandoSlot == index
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 32,
                                ),
                                if (selecionandoSlot == index)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Selecione',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  hero.heroImage.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 3,
                                  ),
                                  child: Text(
                                    hero.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      team.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          if (selecionandoSlot != -1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Selecionando para o slot ${selecionandoSlot + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selecionandoSlot = -1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
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
                FilterButton(
                  selectedAlignment: _selectedAlignment,
                  powerMin: _powerMin,
                  onApply: _applyFilters,
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
                    itemCount: filteredHeroes.length,
                    itemBuilder: (context, index) {
                      final hero = filteredHeroes[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (selecionandoSlot == -1) {
                              if (team.length < 6 && !team.contains(hero)) {
                                setState(() {
                                  team.add(hero);
                                });
                              }
                            }
                          },
                          child: HeroCard(
                            hero: hero,
                            modoComparacao: selecionandoSlot != -1,
                            selecionado: false,
                            onToggleSelecao: selecionandoSlot != -1
                                ? () => _adicionarHeroiAoSlot(hero)
                                : null,
                          ),
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
