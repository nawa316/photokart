import 'package:flutter/material.dart';
import '../components/bottom_nav.dart';
import '../components/product_list_header.dart';
import '../components/product_card.dart';
import '../models/products.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: const BottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProductListHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: products
                          .map(
                            (p) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16),
                              child: ProductCard(product: p),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProductPage(),
    ),
  );
}
