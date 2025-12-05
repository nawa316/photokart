import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  final String? username;

  const EmailVerificationPage({
    super.key,
    required this.email,
    this.username,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isResending = false;
  int _resendCountdown = 0;

  void _handleResendEmail() {
    setState(() {
      _isResending = true;
      _resendCountdown = 60;
    });

    // Simulate sending email
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _startResendCountdown();
      }
    });
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendCountdown();
      }
    });
  }

  void _handleBackToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Colored header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE4F0FF), Color(0xFFFFEEFC)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verify Email',
                    style: TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // White content card
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Verification icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4F0FF),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.email_outlined,
                              size: 40,
                              color: Color(0xFF7B95CF),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Center(
                        child: Text(
                          'Confirm Your Email',
                          style: const TextStyle(
                            color: Color(0xFF304369),
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Center(
                        child: Text(
                          'Kami telah mengirimkan link verifikasi ke\n${widget.email}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Instructions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE4F0FF),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Langkah selanjutnya:',
                              style: TextStyle(
                                color: Color(0xFF304369),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionItem(
                              '1',
                              'Buka email Anda',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionItem(
                              '2',
                              'Cari email dari PhotoKart',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionItem(
                              '3',
                              'Klik tombol verifikasi dalam email',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionItem(
                              '4',
                              'Akun Anda akan aktif setelah verifikasi',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Open email app button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleBackToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B95CF),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            'Kembali ke Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Resend email
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Tidak menerima email?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _resendCountdown == 0 && !_isResending 
                                  ? _handleResendEmail 
                                  : null,
                              child: Text(
                                _isResending
                                    ? 'Mengirim email...'
                                    : _resendCountdown > 0
                                        ? 'Kirim ulang dalam ${_resendCountdown}s'
                                        : 'Kirim ulang email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _resendCountdown > 0 || _isResending
                                      ? Colors.grey
                                      : const Color(0xFF7B95CF),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
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

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF7B95CF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF304369),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
