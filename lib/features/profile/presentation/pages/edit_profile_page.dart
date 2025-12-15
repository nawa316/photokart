import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';

import 'user_profile.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  int _currentIndex = 4;
  late String _avatarPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _passwordController = TextEditingController(text: widget.profile.password);

    _avatarPath = widget.profile.avatarPath.isEmpty
        ? kDefaultAvatarPath
        : widget.profile.avatarPath;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
  }

  ImageProvider _buildAvatarImageProvider() {
    final effectivePath =
        _avatarPath.isEmpty ? kDefaultAvatarPath : _avatarPath;

    if (effectivePath.startsWith('assets/')) {
      return AssetImage(effectivePath);
    }
    if (kIsWeb) {
      return NetworkImage(effectivePath);
    }
    return FileImage(File(effectivePath));
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarPath = picked.path;
      });
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: const Color(0x33000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BottomSheetButton(
                  text: 'Upload Photo',
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickFromGallery();
                  },
                ),
                const SizedBox(height: 8),
                _BottomSheetButton(
                  text: 'See Photo',
                  onTap: () {
                    Navigator.pop(ctx);
                    showDialog(
                      context: context,
                      barrierColor: const Color(0x33000000),
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image(
                            image: _buildAvatarImageProvider(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batalkan',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final updated = widget.profile.copyWith(
      name: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      avatarPath: _avatarPath.isEmpty ? kDefaultAvatarPath : _avatarPath,
    );

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        await supabase
            .from('users') // ⬅️ tabel users
            .update(updated.toUpdateMap())
            .eq('id', user.id);
      } catch (e) {
        debugPrint('Failed to update profile: $e');
      }
    }

    if (mounted) {
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'PhotoKart',
              showSearch: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Color(0xFF7B95CF),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF7B95CF),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: _AvatarCard(
                        imageProvider: _buildAvatarImageProvider(),
                        onTapPlus: _showPhotoOptions,
                      ),
                    ),
                    const SizedBox(height: 32),

                    const _FieldLabel('Username'),
                    const SizedBox(height: 6),
                    _OutlinedTextField(controller: _usernameController),
                    const SizedBox(height: 18),

                    const _FieldLabel('Email'),
                    const SizedBox(height: 6),
                    _OutlinedTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    const _FieldLabel('Phone Number'),
                    const SizedBox(height: 6),
                    _OutlinedTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),

                    const _FieldLabel('Password'),
                    const SizedBox(height: 6),
                    _OutlinedTextField(
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B95CF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PhotoKartBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  final ImageProvider imageProvider;
  final VoidCallback onTapPlus;

  const _AvatarCard({
    required this.imageProvider,
    required this.onTapPlus,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0x7F7B95CF),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x337B95CF),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                image: imageProvider,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: GestureDetector(
              onTap: onTapPlus,
              child: Container(
                width: 30,
                height: 31,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF304369),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Color(0xFF304369),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF304369),
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _OutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _OutlinedTextField({
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF304369),
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        filled: true,
        fillColor: const Color(0xFFF6F7F9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF7B95CF),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF7B95CF),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _BottomSheetButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _BottomSheetButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF6F7F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF304369),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
