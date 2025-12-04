import 'package:flutter/material.dart';
import 'status_bar_widget.dart';
import 'search_bar_widget.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showSearch;

  const AppHeader({
    super.key,
    required this.title,
    this.showSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusBarWidget(),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF304369),
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showSearch) ...[
            const SizedBox(height: 16),
            const SearchBarWidget(),
          ],
        ],
      ),
    );
  }
}
