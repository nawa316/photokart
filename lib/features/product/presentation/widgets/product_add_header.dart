import 'package:flutter/material.dart';

class ProductAddHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const ProductAddHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minHeaderHeight = size.height * 0.18;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeaderHeight),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF4EFFF),
            Color(0xFFEAE3FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Color(0xFF7B95CF),
                ),
                SizedBox(width: 4),
                Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7B95CF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "PhotoKart",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF304369),
            ),
          ),
        ],
      ),
    );
  }
}
