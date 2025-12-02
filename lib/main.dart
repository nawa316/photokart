import 'package:flutter/material.dart';

// import semua screen produk
import 'ahul_product.dart';
import 'hanni_product.dart';
import 'karina_product.dart';
import 'suzy_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B95CF)),
        useMaterial3: true,
      ),

      // default pertama kali yang dibuka
      // (kalau mau ganti ke AhulProduct, tinggal ubah ke '/ahul')
      initialRoute: '/suzy',

      // daftar route sederhana untuk tiap produk
      routes: {
        '/ahul': (context) => const AhulProduct(),
        '/hanni': (context) => const HanniProduct(),
        '/karina': (context) => const KarinaProduct(),
        '/suzy': (context) => const SuzyProduct(),
      },
    );
  }
}
