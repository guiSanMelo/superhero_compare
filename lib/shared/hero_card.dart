import 'package:flutter/material.dart';
import '../models/heroes_dto.dart';

class HeroCard extends StatelessWidget {
  final Heroes hero;

  const HeroCard({super.key, required this.hero})

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          )
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: hero.heroImage != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  hero.heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
                ),
              )
              : null
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
                    color: Color(0xFF1A1A2E)
                  )
                ),
                const SizedBox(height: 6),
                _TypeBadge(label: hero.biography.alignment),
              ],
            )
          ],
        ),
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
        color: color.withOpacity(0.15),
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