// lib/suzy_product.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_detail_card.dart';

class SuzyProduct extends StatelessWidget {
  const SuzyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWithBackground(context, h, w),
              ProductDetailCard(
                productName: "Suzy Photocard",
                imageAsset: 'assets/images/suzi.png',
                priceText: "Rp 120.000,00",
                salesText: "Sales : 90 pcs",
                stockText: "Stock : 8 pcs",
                descriptionText: "Description : Photocard Special",
                ratingText: "4.7",
                tags: const [
                  "Good Quality (40)",
                  "Good (35)",
                ],
                onUpdatePressed: () {
                  _showUpdateDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWithBackground(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.20,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF4EFFF),
            Color(0xFFEAE3FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        20,
        screenWidth * 0.05,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PhotoKart",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF304369),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF7B95CF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Back",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7B95CF),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDFD),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF7B95CF)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search,
                          size: 18, color: Color(0xFF7B95CF)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Search photocards",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF7B95CF),
                          ),
                        ),
                      ),
                      const Icon(Icons.mic_none,
                          size: 20, color: Color(0xFF7B95CF)),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Update Product"),
        content: const Text("This will open the edit product page (dummy)."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({super.key});

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
          _navIcon('assets/images/bag.png'),
          _navIcon('assets/images/cart.png'),
          _navIcon('assets/images/center.png', size: 58),
          _navIcon('assets/images/chat.png'),
          _navIcon('assets/images/profile.png'),
        ],
      ),
    );
  }

  Widget _navIcon(String assetPath, {double size = 39}) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}
