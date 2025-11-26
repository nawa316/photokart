import 'package:flutter/material.dart';
import 'onboarding_page2.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // lebar “kartu” maksimal 430 biar mirip desain, tapi mengecil otomatis di layar kecil
    final cardWidth = width.clamp(320.0, 440.0);

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
                    const SizedBox(height: 28),

                    // ====== LOGO + TAGLINE, PAKAI FLEX SUPAYA RESPONSIF ======
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // logo dibikin proporsional terhadap tinggi layar
                          SizedBox(
                            height: size.height * 0.32, // naik-turun otomatis
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 52),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Collect Your Idol, One\nCard at a Time!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF304369),
                                fontSize: 28, // <<< dibesarkan dari 20
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ====== TOMBOL START ======
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
                                builder: (context) => const OnboardingPage2(),
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
                            'Start',
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


                    const SizedBox(height: 20),

                    // ====== PAGE INDICATOR: PILL KIRI AKTIF ======
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // pill kiri (aktif)
                        Container(
                          width: 43,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B95CF),
                            borderRadius: BorderRadius.circular(285),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // dot tengah
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDEE5F3),
                            shape: BoxShape.circle,
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
