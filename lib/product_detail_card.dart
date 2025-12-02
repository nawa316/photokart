// lib/product_detail_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailCard extends StatelessWidget {
  final String productName;
  final String imageAsset;
  final String priceText;
  final String salesText;
  final String stockText;
  final String descriptionText;
  final String ratingText;
  final List<String> tags;
  final VoidCallback onUpdatePressed;

  const ProductDetailCard({
    super.key,
    required this.productName,
    required this.imageAsset,
    required this.priceText,
    required this.salesText,
    required this.stockText,
    required this.descriptionText,
    required this.ratingText,
    required this.tags,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.05,
        right: w * 0.05,
        bottom: h * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama produk
          Text(
            productName,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF304369),
            ),
          ),

          SizedBox(height: h * 0.018),

          // FOTO PRODUK
          _productImage(context),

          SizedBox(height: h * 0.025),

          // HARGA + SALES
          _priceAndSales(),

          SizedBox(height: h * 0.01),

          // STOCK
          _stockText(),

          SizedBox(height: h * 0.02),

          // DESCRIPTION
          _descriptionSection(),

          SizedBox(height: h * 0.02),

          // REVIEW BAR
          _reviewBar(context),

          SizedBox(height: h * 0.03),

          // UPDATE BUTTON
          _updateButton(context),
        ],
      ),
    );
  }

  // ================== BAGIAN-BAGIAN UI ==================

  Widget _productImage(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: w * 0.75,
        decoration: BoxDecoration(
          color: const Color(0x337B95CF),
          boxShadow: [
            BoxShadow(
              color: const Color(0x337B95CF),
              blurRadius: 30,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _priceAndSales() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          priceText,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF304369),
          ),
        ),
        Text(
          salesText,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF304369),
          ),
        ),
      ],
    );
  }

  Widget _stockText() {
    return Text(
      stockText,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF304369),
      ),
    );
  }

  Widget _descriptionSection() {
    return Text(
      descriptionText,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF304369),
      ),
    );
  }

  Widget _reviewBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE7ECF8),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            ratingText,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF304369),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                for (final tag in tags) ...[
                  _smallChip(tag),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF637FBF),
            size: 26,
          ),
        ],
      ),
    );
  }

  Widget _smallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF304369),
        ),
      ),
    );
  }

  Widget _updateButton(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Center(
      child: GestureDetector(
        onTap: onUpdatePressed,
        child: Container(
          width: w * 0.45,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFBFCBF0),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B95CF).withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Update",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF304369),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
