import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/email_verification_page.dart';
import '../features/home/presentation/pages/homepage.dart';
import '../features/product/presentation/pages/top_rating.dart';
import '../features/review/presentation/pages/reviewpage.dart';
import '../features/chat/presentation/pages/chat_overview.dart';
import '../features/chat/presentation/pages/chat_detail_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/product/presentation/pages/seller_addproduct.dart';
import '../features/product/presentation/pages/productpage.dart';
import '../features/product/presentation/pages/edit_product_wrapper.dart';
import '../features/product/presentation/pages/product_detail_wrapper.dart';
import '../features/product/presentation/pages/buyer_product_detail_page.dart';
import '../features/product/data/product_repository.dart';
import '../features/order/presentation/pages/order_list_page.dart';
import '../features/order/presentation/pages/order_detail_page.dart';
import '../features/order/presentation/pages/buyer_order_confirmation.dart';
import '../features/order/presentation/pages/order_view_page.dart';
import '../features/product/domain/product_model.dart';
import '../features/revenue/presentation/pages/revenue_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
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
      path: '/reviews',
      builder: (context, state) => const RatingReviewsPage(),
    ),
    GoRoute(
      name: 'chat-overview',
      path: '/chat',
      builder: (context, state) => const ChatOverviewPage(),
    ),
    GoRoute(
      name: 'chat-detail',
      path: '/chat/:conversationId',
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId'] ?? '';
        final extra = state.extra as Map<String, dynamic>?;
        final username = extra?['username'] as String? ?? 'User';
        final platformKey = extra?['platformKey'] as String? ?? 'chat';
        
        return ChatDetailPage(
          conversationId: conversationId,
          username: username,
          platformKey: platformKey,
        );
      },
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: 'addproduct',
      path: '/addproduct',
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      name: 'toprating',
      path: '/toprating',
      builder: (context, state) => const TopRating(),
    ),
    GoRoute(
      name: 'editproduct',
      path: '/editproduct/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return EditProductWrapper(productId: id);
      },
    ),
    GoRoute(
      name: 'product',
      path: '/product',
      builder: (context, state) => const ProductPage(),
    ),
    GoRoute(
      name: 'order',
      path: '/order',
      builder: (context, state) => const OrderListPage(),
    ),
    GoRoute(
      name: 'order-confirmation',
      path: '/order/confirmation',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final transactionId = data['transactionId'] as String;
        final product = data['product'] as ProductModel;
        final quantity = state.uri.queryParameters['quantity'];
        return BuyerOrderConfirmationPage(
          transactionId: transactionId,
          product: product,
          quantity: quantity != null ? int.parse(quantity) : 1,
        );
      },
    ),
    GoRoute(
      name: 'order-detail',
      path: '/order/detail',
      builder: (context, state) {
        final product = state.extra as ProductModel;
        final quantity = state.uri.queryParameters['quantity'];
        return OrderDetailPage(
          product: product,
          quantity: quantity != null ? int.parse(quantity) : 1,
        );
      },
    ),
    GoRoute(
      name: 'order-view',
      path: '/order/:transactionId',
      builder: (context, state) {
        final transactionId = state.pathParameters['transactionId'] ?? '';
        return OrderViewPage(transactionId: transactionId);
      },
    ),
    GoRoute(
      name: 'revenue',
      path: '/revenue',
      builder: (context, state) => const RevenuePage(),
    ),
    GoRoute(
      name: 'product-detail',
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailWrapper(productId: id);
      },
    ),
    GoRoute(
      name: 'buyer-product-detail',
      path: '/buyer-product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return FutureBuilder(
          future: ProductRepository().getProductById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFFF7FAFE),
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Scaffold(
                backgroundColor: const Color(0xFFF7FAFE),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Product not found'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return BuyerProductDetailPage(product: snapshot.data!);
          },
        );
      },
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
    final isEmailVerification =
        state.uri.path.startsWith('/email-verification');

    if (session == null &&
        !allowedPaths.contains(state.uri.path) &&
        !isEmailVerification) {
      return '/onboarding';
    }
    return null;
  },
);
