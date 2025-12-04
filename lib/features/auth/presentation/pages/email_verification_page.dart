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
  late List<TextEditingController> _codeControllers;
  bool _isVerifying = false;
  String? _errorMessage;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(6, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _verificationCode {
    return _codeControllers.map((c) => c.text).join();
  }

  Future<void> _handleVerify() async {
    if (_verificationCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the 6-digit code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate verification process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
    });

    // For now, navigate to home on success
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/');
    }
  }

  void _handleResendCode() {
    setState(() {
      _errorMessage = null;
      _resendCountdown = 30;
    });

    // Clear the code fields
    for (var controller in _codeControllers) {
      controller.clear();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Start countdown
    _startResendCountdown();
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown > 0) {
          _startResendCountdown();
        }
      }
    });
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
                          'We sent a verification code to\n${widget.email}',
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

                      // Code input fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 50,
                            height: 60,
                            child: TextField(
                              controller: _codeControllers[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _errorMessage != null
                                        ? Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: _errorMessage != null
                                        ? Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF7B95CF),
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF304369),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Error message
                      if (_errorMessage != null)
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

                      if (_errorMessage != null) const SizedBox(height: 16),

                      const SizedBox(height: 8),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isVerifying ? null : _handleVerify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B95CF),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: _isVerifying
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Verify Email',
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

                      // Resend code
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Didn\'t receive the code?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _resendCountdown == 0 ? _handleResendCode : null,
                              child: Text(
                                _resendCountdown > 0
                                    ? 'Resend code in ${_resendCountdown}s'
                                    : 'Resend code',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _resendCountdown > 0
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
}
