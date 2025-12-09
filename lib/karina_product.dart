import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KarinaProduct extends StatelessWidget {
  const KarinaProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerWithBackground(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Karina Dagu",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF304369),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _productImage(),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _priceSection(),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _descriptionSection(),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _statsSection(),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _reviewBar(),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _updateButton(),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWithBackground() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFF4EFFF),
          Color(0xFFEAE3FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PhotoKart",
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF304369),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [

            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Color(0xFF7B95CF)),
                  const SizedBox(width: 4),
                  Text(
                    "Back",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7B95CF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF7B95CF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search,
                        size: 20, color: Color(0xFF7B95CF)),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "Search photocards",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF7B95CF),
                        ),
                      ),
                    ),

                    const Icon(Icons.mic_none,
                        size: 22, color: Color(0xFF7B95CF)),
                    const SizedBox(width: 12),
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


  Widget _productImage() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 300,
      color: const Color(0x337B95CF),
      child: Image.asset(
        'assets/images/karina.png',
        fit: BoxFit.cover,
      ),
    ),
  );
}


  Widget _priceSection() {
    return Text(
      "RP 120.000,00",
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF304369),
      ),
    );
  }

  Widget _descriptionSection() {
    return Text(
      "Description : Photocard Rare",
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF304369),
      ),
    );
  }

  Widget _statsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Stock : 6 pcs",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF304369),
          ),
        ),
        Text(
          "Sales : 100 pcs",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF304369),
          ),
        ),
      ],
    );
  }

  Widget _reviewBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF304369),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                _smallChip("Good Quality (50)"),
                _smallChip("Good (50)"),
              ],
            ),
          ),
          const SizedBox(width: 12),

          const Icon(Icons.chevron_right,
              color: Color(0xFF637FBF), size: 28),
        ],
    ),
  );
}


  Widget _smallChip(String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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


  Widget _updateButton() {
    return Center(
      child: Container(
        width: 180,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF7B95CF),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Text(
            "Buy Now",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF304369),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
      ],
    );
  }
}
