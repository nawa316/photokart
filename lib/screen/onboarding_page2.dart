import 'package:flutter/material.dart';
import 'onboarding_page3.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // sama seperti OnboardingPage1: lebar kartu max 430, min 320
    final cardWidth = width.clamp(320.0, 430.0);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // bezel luar hp
      body: Center(
        child: Container(
          width: cardWidth,
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE4F0FF),
                    Color(0xFFFFEEFC),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // ====== LOGO + TEKS, STRUKTUR SAMA DENGAN PAGE 1 ======
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.40,
                            child: Image.asset(
                              // GANTI ke gambar kamu sendiri untuk page 2
                              'assets/images/online_shopping.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              // TEKS PAGE 2 – boleh kamu ubah
                              'Shop & Connect with Fans Worldwide',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF304369),
                                fontSize: 28, // sama besarnya dengan page 1
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ====== TOMBOL NEXT ======
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 52),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnboardingPage3(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFF7B95CF),
                            elevation: 4,
                            shadowColor: Colors.black38,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ====== INDICATOR: PILL DI TENGAH (PAGE 2 AKTIF) ======
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // dot kiri
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDEE5F3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // pill tengah (aktif)
                        Container(
                          width: 43,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B95CF),
                            borderRadius: BorderRadius.circular(285),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // dot kanan
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDEE5F3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
