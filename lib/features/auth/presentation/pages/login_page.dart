import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  
  late final AuthRepositoryImpl _authRepository;

  @override
  void initState() {
    super.initState();
    // Initialize auth repository
    final supabaseService = SupabaseService.instance;
    final authApi = AuthApi(supabaseService);
    _authRepository = AuthRepositoryImpl(authApi);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    // Call repository
    final result = await _authRepository.login(
      emailOrUsername: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Hide loading
    setState(() {
      _isLoading = false;
    });

    // Handle result
    result.fold(
      (failure) {
        // Show error
        setState(() {
          _errorMessage = failure.message;
        });
        
        // Show snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (user) {
        // Success - navigate to home
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${user.username}!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/');
        }
      },
    );
  }

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final w = size.width;
  final h = size.height;

  return Scaffold(
    backgroundColor: const Color(0xFFF7FAFE),
    body: SafeArea(
      child: Stack(
        children: [
          // ===== BACKGROUND GRADIENT =====
          Container(
            width: double.infinity,
            height: h * 0.40, // area gradient atas
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE4F0FF),
                  Color(0xFFFFEEFC),
                ],
              ),
            ),
          ),

          // ===== BACK BUTTON =====
          Positioned(
            left: w * 0.09,
            top: h * 0.08,
            child: IconButton(
              onPressed: () => context.go('/onboarding'),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF304369)),
            ),
          ),

          // ===== TITLE "Sign in" =====
          Positioned(
            left: w * 0.10,
            top: h * 0.13,
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: Color(0xFF304369),
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ===== CARD PUTIH DI BAWAH (FORM) =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              // tinggi card sekitar 65–70% layar, tetap terasa seperti desain
              height: h * 0.70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.12, // kira-kira 52/430
                  vertical: h * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 28,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Hello there, sign in to continue!',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // ================= FORM =================
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username or Email',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter email or username';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Username or email',
                              hintStyle: const TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF6F7F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          const Text(
                            'Password',
                            style: TextStyle(
                              color: const Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: '****************',
                              hintStyle: const TextStyle(
                                color: Color(0xFFB0B0B0),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF6F7F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF304369),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),

                          SizedBox(height: h * 0.015),

                          Align(
                            alignment: Alignment.centerLeft, // ganti dari centerRight
                            child: TextButton(
                              onPressed: () {
                                // TODO
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFF304369),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade700,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B95CF),
                                elevation: 4,
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: h * 0.03),

                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Color(0xFF304369),
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Don’t have an account? ",
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.go('/register');
                                      },
                                      child: const Text(
                                        'Create',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF304369),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.015),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
