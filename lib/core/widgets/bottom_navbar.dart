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
    final size = MediaQuery.of(context).size;
    final h = size.height;

    // skala dari desain 39x39 dan 58x58
    final smallIconSize = h * (39 / 932);
    final bigIconSize = h * (58 / 932);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(21),
        topRight: Radius.circular(21),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 48,
              offset: Offset(-0.60, 0.60),
              spreadRadius: -12,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: const Color(0xFF304369),
            unselectedItemColor: const Color(0xFFB0B7D0),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              // kasih tau parent dulu
              onTap(index);

              // lalu navigasi
              switch (index) {
                case 0:
                  context.go('/shop');     // ganti ke route shop-mu
                  break;
                case 1:
                  context.go('/cart');     // ganti ke route cart-mu
                  break;
                case 2:
                  context.go('/');         // halaman utama / photokart
                  break;
                case 3:
                  context.go('/chat');
                  break;
                case 4:
                  context.go('/profile');  // ganti ke route profile-mu
                  break;
              }
            },
            items: [
              // ========= SHOP =========
              BottomNavigationBarItem(
                label: 'Shop',
                icon: SizedBox(
                  width: smallIconSize,
                  height: smallIconSize,
                  child: Image.asset(
                    currentIndex == 0
                        ? 'assets/images/bag_clicked.png'
                        : 'assets/images/bag.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // ========= CART =========
              BottomNavigationBarItem(
                label: 'Cart',
                icon: SizedBox(
                  width: smallIconSize,
                  height: smallIconSize,
                  child: Image.asset(
                    currentIndex == 1
                        ? 'assets/images/cart_clicked.png'
                        : 'assets/images/cart.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // ========= CENTER / PHOTOKART =========
              BottomNavigationBarItem(
                label: 'PhotoKart',
                icon: SizedBox(
                  width: bigIconSize,
                  height: bigIconSize,
                  child: Image.asset(
                    currentIndex == 2
                        ? 'assets/images/center_clicked.png'
                        : 'assets/images/center.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // ========= CHAT =========
              BottomNavigationBarItem(
                label: 'Chat',
                icon: SizedBox(
                  width: smallIconSize,
                  height: smallIconSize,
                  child: Image.asset(
                    currentIndex == 3
                        ? 'assets/images/chat_clicked.png'
                        : 'assets/images/chat.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // ========= PROFILE =========
              BottomNavigationBarItem(
                label: 'Profile',
                icon: SizedBox(
                  width: smallIconSize,
                  height: smallIconSize,
                  child: Image.asset(
                    currentIndex == 4
                        ? 'assets/images/profile_clicked.png'
                        : 'assets/images/profile.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
