import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF7B95CF),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A7B95CF),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            size: 18,
            color: Color(0xFF7B95CF),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search photocards',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7B95CF),
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF304369),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7B95CF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.mic_none,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
