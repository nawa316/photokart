import 'package:flutter/material.dart';
import 'screen/onboarding_page.dart';

void main() {
  runApp(const PhotoKartApp());
}

class PhotoKartApp extends StatelessWidget {
  const PhotoKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Poppins', // pastikan sudah di-set di pubspec.yaml
      ),
      home: const OnboardingPage(),
    );
  }
}
