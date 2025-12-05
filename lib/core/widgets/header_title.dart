import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String title;

  const HeaderTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF304369),
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
