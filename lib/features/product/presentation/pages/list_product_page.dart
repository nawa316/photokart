import 'package:flutter/material.dart';
import '../../domain/products.dart';
import '../widgets/product_card.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';

class TopRating extends StatefulWidget {
  const TopRating({super.key});

  @override
  State<TopRating> createState() => _TopRatingState();
}

class _TopRatingState extends State<TopRating> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // TODO: Add navigation logic based on index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: PhotoKartBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Top Rating', showSearch: false),
            const SizedBox(height: 20),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: Product.sampleProducts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: ProductCard(
                        product: product,
                        rank: index + 1, // +1 because index starts at 0
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}