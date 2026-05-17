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
        return const Color(0xFF4FC3F7); // azul claro do mockup
      case 'bad':
        return const Color(0xFFEF5350); // vermelho
      default:
        return const Color(0xFF7E57C2); // roxo para neutro
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
            MaterialPageRoute(builder: (context) => InfoHero(hero: hero)),
          );
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selecionado ? Colors.blue : Colors.black,
                width: selecionado ? 2.5 : 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 0,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  // Imagem do herói
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _alignmentColor(
                        hero.biography.alignment,
                      ).withValues(alpha: 0.3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        hero.heroImage.url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _AlignmentBadge(
                        label: hero.biography.alignment,
                        color: _alignmentColor(hero.biography.alignment),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Checkbox modo comparação
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
                      color: selecionado ? Colors.blue : Colors.black54,
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

class _AlignmentBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _AlignmentBadge({required this.label, required this.color});

  String _labelPt(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'good':
        return 'Herói';
      case 'bad':
        return 'Vilão';
      default:
        return 'Neutro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        _labelPt(label),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
