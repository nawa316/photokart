import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/products.dart';
import '../components/product_card.dart';
import '../components/header.dart';
import '../components/bottom_nav.dart';

class TopRating extends StatelessWidget {
  const TopRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section (header + title)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Top Rating",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF304369),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            
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