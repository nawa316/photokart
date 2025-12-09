import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PhotoKartBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PhotoKartBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(21),
        topRight: Radius.circular(21),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Navigate based on the tapped index
          switch (index) {
            case 0: // Shop
              context.go('/product'); // Replace with your shop route
              break;
            case 1: // Cart
              context.go('/product'); // Replace with your cart route
              break;
            case 2: // Home/PhotoKart
              context.go('/'); // Home route
              break;
            case 3: // Chat
              context.go('/chat');
              break;
            case 4: // Profile
              context.go('/profile'); // Replace with your profile route
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF304369),
        unselectedItemColor: const Color(0xFFB0B7D0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'PhotoKart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
