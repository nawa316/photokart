import 'package:flutter/material.dart';
import 'router/app_router.dart';


class PhotoKartApp extends StatelessWidget {
  const PhotoKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Router dikonfigurasi di lib/router/app_router.dart

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'PhotoKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B95CF)),
      ),
    );
  }
}