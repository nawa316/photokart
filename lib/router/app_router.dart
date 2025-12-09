import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/email_verification_page.dart';
import '../features/home/presentation/pages/homepage.dart';
import '../features/product/presentation/pages/list_product_page.dart';
import '../features/review/presentation/pages/reviewpage.dart';
import '../features/chat/presentation/pages/chat_overview.dart';

final GoRouter appRouter = GoRouter(
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
    GoRoute(
      name: 'top-rating',
      path: '/top-rating',
      builder: (context, state) => const TopRating(),
    ),
    GoRoute(
      name: 'rating-reviews',
      path: '/rating-reviews',
      builder: (context, state) => const RatingReviewsPage(),
    ),
    GoRoute(
      name: 'chat-overview',
      path: '/chat',
      builder: (context, state) => const ChatOverviewPage(),
    ),
  ],
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final allowedPaths = [
      '/login',
      '/register',
      '/onboarding',
    ];
    // Allow email-verification page without session
    final isEmailVerification = state.uri.path.startsWith('/email-verification');
    if (session == null &&
        !allowedPaths.contains(state.uri.path) &&
        !isEmailVerification) {
      return '/onboarding';
    }
    return null;
  },
);
