import 'package:flutter/material.dart';

class RatingHeader extends StatelessWidget {
  const RatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCFD5FF),
            Color(0xFFF7FAFE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: const [
          Text(
            "Rating & Reviews",
            style: TextStyle(
              color: Color(0xFF304369),
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Product Evaluation",
            style: TextStyle(
              color: Color(0xFF7B95CF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
