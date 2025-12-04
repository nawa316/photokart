import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';


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
