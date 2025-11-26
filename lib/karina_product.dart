import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KarinaProduct extends StatelessWidget {
  const KarinaProduct({super.key});

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
          child: Padding(
            padding: EdgeInsets.only(bottom: h * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWithBackground(context, h, w),

                SizedBox(height: h * 0.025),

                // Nama produk
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Text(
                    "Karina Dagu",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF304369),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.018),

                // FOTO PRODUK
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: _productImage(context),
                ),

                SizedBox(height: h * 0.025),

                // HARGA + SALES
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: _priceAndSales(),
                ),

                SizedBox(height: h * 0.01),

                // STOCK
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: _stockText(),
                ),

                SizedBox(height: h * 0.02),

                // DESCRIPTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: _descriptionSection(),
                ),

                SizedBox(height: h * 0.02),

                // REVIEW BAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: _reviewBar(context),
                ),

                SizedBox(height: h * 0.03),

                // UPDATE BUTTON
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.2),
                  child: _updateButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

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
          // judul
          Text(
            "PhotoKart",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF304369),
            ),
          ),

          const SizedBox(height: 16),

          // Back + Search bar
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
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

  // ================= PRODUCT IMAGE =================

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
          'assets/images/karina.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= TEXT SECTIONS =================

  Widget _priceAndSales() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "RP 120.000,00",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF304369),
          ),
        ),
        Text(
          "Sales : 100 pcs",
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
      "Stock : 6 pcs",
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF304369),
      ),
    );
  }

  Widget _descriptionSection() {
    return Text(
      "Description :  Photocard Rare",
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF304369),
      ),
    );
  }

  // ================= REVIEW BAR =================

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
            "4.6",
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
                _smallChip("Good Quality (50)"),
                const SizedBox(width: 8),
                _smallChip("Good (50)"),
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

  // ================= BUTTON =================

  Widget _updateButton(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Center(
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
    );
  }
}

// ================= BOTTOM NAV =================

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
