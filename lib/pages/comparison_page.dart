import 'package:flutter/material.dart';
import '../models/heroes_dto.dart';

class ComparePage extends StatelessWidget {
  final Heroes heroA;
  final Heroes heroB;

  const ComparePage({super.key, required this.heroA, required this.heroB});

  Color _alignmentColor(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'good':
        return const Color(0xFF3B82F6);
      case 'bad':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  int _parseStatValue(String value) {
    return int.tryParse(value) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      // Apenas mude o AppBar dentro da ComparePage:
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comparação',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            _HeroesHeader(
              heroA: heroA,
              heroB: heroB,
              alignmentColor: _alignmentColor,
            ),
            const SizedBox(height: 28),
            _PowerstatsComparison(
              heroA: heroA,
              heroB: heroB,
              parseStatValue: _parseStatValue,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header com fotos e nomes ────────────────────────────────────────────────

class _HeroesHeader extends StatelessWidget {
  final Heroes heroA;
  final Heroes heroB;
  final Color Function(String) alignmentColor;

  const _HeroesHeader({
    required this.heroA,
    required this.heroB,
    required this.alignmentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HeroAvatar(
            hero: heroA,
            alignmentColor: alignmentColor,
            isLeft: true,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: _HeroAvatar(
            hero: heroB,
            alignmentColor: alignmentColor,
            isLeft: false,
          ),
        ),
      ],
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  final Heroes hero;
  final Color Function(String) alignmentColor;
  final bool isLeft;

  const _HeroAvatar({
    required this.hero,
    required this.alignmentColor,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final color = alignmentColor(hero.biography.alignment);

    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              hero.heroImage.url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.white38),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hero.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
          ),
          child: Text(
            hero.biography.alignment,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Seção de powerstats ──────────────────────────────────────────────────────

class _PowerstatsComparison extends StatelessWidget {
  final Heroes heroA;
  final Heroes heroB;
  final int Function(String) parseStatValue;

  const _PowerstatsComparison({
    required this.heroA,
    required this.heroB,
    required this.parseStatValue,
  });

  List<Map<String, dynamic>> _getStats() {
    return [
      {
        'label': 'Inteligência',
        'icon': Icons.psychology,
        'a': heroA.powerstats.intelligence,
        'b': heroB.powerstats.intelligence,
      },
      {
        'label': 'Força',
        'icon': Icons.fitness_center,
        'a': heroA.powerstats.strength,
        'b': heroB.powerstats.strength,
      },
      {
        'label': 'Velocidade',
        'icon': Icons.speed,
        'a': heroA.powerstats.speed,
        'b': heroB.powerstats.speed,
      },
      {
        'label': 'Durabilidade',
        'icon': Icons.shield,
        'a': heroA.powerstats.durability,
        'b': heroB.powerstats.durability,
      },
      {
        'label': 'Poder',
        'icon': Icons.bolt,
        'a': heroA.powerstats.power,
        'b': heroB.powerstats.power,
      },
      {
        'label': 'Combate',
        'icon': Icons.sports_martial_arts,
        'a': heroA.powerstats.combat,
        'b': heroB.powerstats.combat,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStats();

    // Calcula totais para o placar geral
    final totalA = stats.fold<int>(0, (sum, s) => sum + parseStatValue(s['a']));
    final totalB = stats.fold<int>(0, (sum, s) => sum + parseStatValue(s['b']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Placar geral
        _ScoreCard(heroA: heroA, heroB: heroB, totalA: totalA, totalB: totalB),
        const SizedBox(height: 20),

        const Text(
          'POWERSTATS',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),

        ...stats.map(
          (stat) => _StatRow(
            label: stat['label'],
            icon: stat['icon'],
            valueA: parseStatValue(stat['a']),
            valueB: parseStatValue(stat['b']),
            rawA: stat['a'],
            rawB: stat['b'],
          ),
        ),
      ],
    );
  }
}

// ─── Placar geral ─────────────────────────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  final Heroes heroA;
  final Heroes heroB;
  final int totalA;
  final int totalB;

  const _ScoreCard({
    required this.heroA,
    required this.heroB,
    required this.totalA,
    required this.totalB,
  });

  @override
  Widget build(BuildContext context) {
    final maxTotal = 600; // 6 stats × 100
    final percA = totalA / maxTotal;
    final percB = totalB / maxTotal;
    final winner = totalA > totalB
        ? heroA.name
        : totalB > totalA
        ? heroB.name
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalA pts',
                style: TextStyle(
                  color: totalA >= totalB
                      ? const Color(0xFF60A5FA)
                      : Colors.white38,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                winner != null ? '🏆 $winner' : '🤝 Empate',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$totalB pts',
                style: TextStyle(
                  color: totalB >= totalA
                      ? const Color(0xFFF87171)
                      : Colors.white38,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra dupla de totais
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: (percA * 100).round(),
                  child: Container(height: 10, color: const Color(0xFF3B82F6)),
                ),
                Expanded(
                  flex: (percB * 100).round(),
                  child: Container(height: 10, color: const Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Linha individual de stat ─────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int valueA;
  final int valueB;
  final String rawA;
  final String rawB;

  const _StatRow({
    required this.label,
    required this.icon,
    required this.valueA,
    required this.valueB,
    required this.rawA,
    required this.rawB,
  });

  @override
  Widget build(BuildContext context) {
    final max = 100;
    final percA = (valueA / max).clamp(0.0, 1.0);
    final percB = (valueB / max).clamp(0.0, 1.0);
    final aWins = valueA > valueB;
    final bWins = valueB > valueA;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            // Label e ícone
            Row(
              children: [
                Icon(icon, color: Colors.white38, size: 14),
                const SizedBox(width: 6),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Valor A
                SizedBox(
                  width: 32,
                  child: Text(
                    rawA == '0' ? '-' : rawA,
                    style: TextStyle(
                      color: aWins ? const Color(0xFF60A5FA) : Colors.white38,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),

                // Barras
                Expanded(
                  child: Row(
                    children: [
                      // Barra A (cresce da esquerda para o centro)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          curve: Curves.easeOutCubic,
                                          height: 8,
                                          width: constraints.maxWidth * percA,
                                          decoration: BoxDecoration(
                                            color: aWins
                                                ? const Color(0xFF3B82F6)
                                                : const Color(
                                                    0xFF3B82F6,
                                                  ).withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4),

                      // Barra B (cresce do centro para a direita)
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.easeOutCubic,
                                  height: 8,
                                  width: constraints.maxWidth * percB,
                                  decoration: BoxDecoration(
                                    color: bWins
                                        ? const Color(0xFFEF4444)
                                        : const Color(
                                            0xFFEF4444,
                                          ).withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Valor B
                SizedBox(
                  width: 32,
                  child: Text(
                    rawB == '0' ? '-' : rawB,
                    style: TextStyle(
                      color: bWins ? const Color(0xFFF87171) : Colors.white38,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
