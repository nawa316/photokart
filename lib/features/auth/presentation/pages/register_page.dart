import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/services/supabase_service.dart';
import 'package:flutter/gestures.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = 'buyer'; // Default role

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
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
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
    final result = await _authRepository.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
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
        // Success - navigate to email verification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Account created! Please verify your email to continue.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.pushNamed(
            'email-verification',
            pathParameters: {'email': Uri.encodeComponent(_emailController.text.trim())},
            queryParameters: {'username': user.username},
          );
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
          // ===== BACKGROUND (GRADIENT) =====
          Container(
            width: double.infinity,
            height: h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFEEFC),
                  Color(0xFFFBF4FD),
                  Colors.white,
                ],
              ),
            ),
          ),

          // ===== BACK BUTTON + TITLE =====
          Positioned(
            left: w * (38 / 430),
            top: h * (81 / 932),
            child: IconButton(
              onPressed: () => context.go('/onboarding'),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF304369)),
            ),
          ),
          Positioned(
            left: w * (43 / 430),
            top: h * (125 / 932),
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Color(0xFF304369),
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ===== CARD PUTIH (FORM) =====
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: h * 0.78,
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
                  horizontal: w * (51 / 430),
                  vertical: h * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 28,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hello there, Create an account to continue!',
                      style: TextStyle(
                        color: Color(0xFF304369),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: h * (30 / 932)),

                    // ============= FORM =============
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username
                          const Text(
                            'Username ',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Nicholas Evan S',
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
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Please enter username'
                                      : null,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Email
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'example@gmail.com',
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
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Please enter email'
                                      : null,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Phone
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '081232120897',
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
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Please enter phone number'
                                      : null,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // I want to (role)
                          const Text(
                            'I want to',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF6F7F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xFF304369),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF304369),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'buyer',
                                  child: Text('Buy Products'),
                                ),
                                DropdownMenuItem(
                                  value: 'seller',
                                  child: Text('Sell Products'),
                                ),
                                DropdownMenuItem(
                                  value: 'both',
                                  child: Text('Buy and Sell Products'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Password
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '*****************',
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
                                  horizontal: 14,
                                  vertical: 8,
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
                              validator: (v) =>
                                  (v == null || v.length < 6)
                                      ? 'Min 6 characters'
                                      : null,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Color(0xFF304369),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 34,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: '*****************',
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
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF304369),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm password';
                                }
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            ),
                          ),

                          SizedBox(height: h * (24 / 932)),

                          // Error message
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

                          // Button Create
                          Center(
                            child: SizedBox(
                              width: w * (250 / 430),
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
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
                                        'Create',
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

                          // ===== Already have account (DI DALAM CARD) =====
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF304369),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Already have an account? ',
                                  ),
                                  TextSpan(
                                    text: 'Sign in',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF304369),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.go('/login'),
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

          // >>> TIDAK ADA Positioned "Already have an account" DI SINI LAGI <<<
        ],
      ),
    ),
  );
}

}
