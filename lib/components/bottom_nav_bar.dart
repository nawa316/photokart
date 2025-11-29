import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 48,
            offset: Offset(-0.6, 0.6),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            index: 0,
            currentIndex: currentIndex,
            assetPath: 'assets/images/bag.png',
            onTap: onTap,
          ),
          _navItem(
            index: 1,
            currentIndex: currentIndex,
            assetPath: 'assets/images/cart.png',
            onTap: onTap,
          ),
          _centerItem(
            index: 2,
            currentIndex: currentIndex,
            assetPath: 'assets/images/center.png',
            onTap: onTap,
          ),
          _navItem(
            index: 3,
            currentIndex: currentIndex,
            assetPath: 'assets/images/chat.png',
            onTap: onTap,
          ),
          _navItem(
            index: 4,
            currentIndex: currentIndex,
            assetPath: 'assets/images/profile.png',
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required int currentIndex,
    required String assetPath,
    required ValueChanged<int> onTap,
  }) {
    final bool isActive = index == currentIndex;
    final double size = 32;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _centerItem({
    required int index,
    required int currentIndex,
    required String assetPath,
    required ValueChanged<int> onTap,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? const Color(0xFFE7ECF8)
              : Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: Opacity(
              opacity: isActive ? 1.0 : 0.5,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
