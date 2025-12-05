import 'package:flutter/material.dart';

class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '4.9',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1f2847),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '/5',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff7f8fa6),
                ),
              ),
              const SizedBox(width: 10),
              const _StarRow(count: 5, size: 22),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xfff4f5fb),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '98% of buyers are satisfied',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff7f8fa6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final int count;
  final double size;

  const _StarRow({required this.count, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.star,
            size: size,
            color: const Color(0xffffc540),
          ),
        ),
      ),
    );
  }
}
