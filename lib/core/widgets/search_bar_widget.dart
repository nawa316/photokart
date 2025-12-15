import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onMicTap;
  final TextEditingController? controller;
  final bool isListening;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onMicTap,
    this.controller,
    this.isListening = false,
    this.hintText = 'Search photocards',
  });

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
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7B95CF),
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF304369),
              ),
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isListening ? const Color(0xFF304369) : const Color(0xFF7B95CF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: onMicTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  isListening ? Icons.hearing : Icons.mic_none,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
