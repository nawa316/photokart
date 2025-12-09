import 'package:flutter/material.dart';

class ReviewFilterChips extends StatelessWidget {
  const ReviewFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _FilterChip(text: 'Good Quality (50)'),
        _FilterChip(text: 'Perfect (15)'),
        _FilterChip(text: 'Aesthetic (8)'),
        _FilterChip(text: 'Great Colours (17)'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;

  const _FilterChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xffdde2f4)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xff1f2847),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
