import 'package:flutter/material.dart';
import '../models/heroes_dto.dart';
import '../pages/info_hero.dart';

class HeroCard extends StatelessWidget {
  final Heroes hero;
  final bool modoComparacao;
  final bool selecionado;
  final VoidCallback? onToggleSelecao;

  const HeroCard({
    super.key,
    required this.hero,
    this.modoComparacao = false,
    this.selecionado = false,
    this.onToggleSelecao,
  });

  Color _alignmentColor(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'good':
        return Colors.blue;
      case 'bad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (modoComparacao) {
          onToggleSelecao?.call();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoHero(hero: hero),
            ),
          );
        }
      },

      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: selecionado ? Colors.blue.withValues(alpha: 0.08) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selecionado ? Colors.blue : Colors.black,
                width: selecionado ? 2 : 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        hero.heroImage.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 6),

                      _TypeBadge(
                        label: hero.biography.alignment,
                        color: _alignmentColor(hero.biography.alignment),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Checkbox sobreposto no canto superior esquerdo
          if (modoComparacao)
            Positioned(
              top: 6,
              left: 6,
              child: IgnorePointer(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selecionado ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: selecionado ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: selecionado
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}