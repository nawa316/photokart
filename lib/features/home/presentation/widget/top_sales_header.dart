import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopSalesHeader extends StatelessWidget {
  const TopSalesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Top Sales',
          style: TextStyle(
            color: Color(0xFF304369),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => GoRouter.of(context).push('/top-rating'),
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF7B95CF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}