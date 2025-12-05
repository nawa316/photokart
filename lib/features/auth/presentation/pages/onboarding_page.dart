import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE4F0FF), Color(0xFFFFEEFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PageView untuk konten
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildPage1(size),
                    _buildPage2(size),
                    _buildPage3(size),
                  ],
                ),
              ),

              // Button Section
              _buildButtons(),

              const SizedBox(height: 20),

              // Page Indicator
              _buildPageIndicator(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ====== PAGE 1: LOGO + TAGLINE ======
  Widget _buildPage1(Size size) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.32,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 52),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Collect Your Idol, One\nCard at a Time!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 28,
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
      ],
    );
  }

  // ====== PAGE 2: ONLINE SHOPPING ======
  Widget _buildPage2(Size size) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.40,
                child: Image.asset(
                  'assets/images/online_shopping.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Shop & Connect with Fans Worldwide',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 28,
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
      ],
    );
  }

  // ====== PAGE 3: SIGN IN OPTIONS ======
  Widget _buildPage3(Size size) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.35,
                child: Image.asset(
                  'assets/images/wanita_keranjang.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Ready to Start Your\nCollection?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ====== BUTTONS ======
  Widget _buildButtons() {
    if (_currentPage == 2) {
      // Page 3: Google Sign In + Create Account + Sign In Text
      return Column(
        children: [
          // Google Sign In Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: handle Google sign-in
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ...icon dan teks Google Sign In...
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Create Account Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/register');
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
                  'Create Account',
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
          const SizedBox(height: 16),

          // Sign In Text
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF304369),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Sign In',
                    style: const TextStyle(
                      color: Color(0xFF7B95CF),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/login');
                      },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else {
      // Page 1 & 2: Start/Next Button
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 52),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF7B95CF),
              elevation: 4,
              shadowColor: Colors.black38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text(
              _currentPage == 0 ? 'Start' : 'Next',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
  }

  // ====== PAGE INDICATOR ======
  Widget _buildPageIndicator() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      bool isActive = index == _currentPage;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: isActive ? 43 : 16,
        height: 16,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF7B95CF)
              : const Color(0xFFDEE5F3),
          shape: isActive ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: isActive ? BorderRadius.circular(285) : null,
        ),
      );
    }),
  );
}


}
