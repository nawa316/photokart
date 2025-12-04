import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/email_verification_page.dart';
import 'features/home/presentation/pages/homepage.dart';

class PhotoKartApp extends StatelessWidget {
  const PhotoKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          name: 'email-verification',
          path: '/email-verification/:email',
          builder: (context, state) {
            final email = Uri.decodeComponent(state.pathParameters['email'] ?? '');
            final username = state.uri.queryParameters['username'];
            return EmailVerificationPage(
              email: email,
              username: username,
            );
          },
        ),
      ],
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return '/onboarding';
        }
        return null;
      },
    );

    return MaterialApp.router(
      routerConfig: router,
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
