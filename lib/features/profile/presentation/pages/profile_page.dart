import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/bottom_navbar.dart';

import 'user_profile.dart';
import 'edit_profile_page.dart';
import 'role_selection_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4; // tab profile

  String _currentRole = 'Seller'; // contoh role awal

  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileFromSupabase();
  }

  Future<void> _loadProfileFromSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      final data = await supabase
          .from('users') 
          .select()      
          .eq('id', user.id)
          .maybeSingle(); 

      if (data != null) {
        _profile = UserProfile.fromMap(data);
        _currentRole = data['role'] as String? ?? 'Seller';
      } else {
        // kalau row belum ada, pakai data dari auth dan nanti bisa di-save
        _profile = UserProfile(
          name: user.userMetadata?['username']?.toString() ??
              user.email ??
              '',
          email: user.email ?? '',
          phone: '',
          password: '**************************',
          avatarPath: kDefaultAvatarPath,
        );
      }
    } catch (e) {
      debugPrint('Error load profile: $e');
      _profile = UserProfile(
        name: user.email ?? '',
        email: user.email ?? '',
        phone: '',
        password: '**************************',
        avatarPath: kDefaultAvatarPath,
      );
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    // TODO: isi navigasi tab lain di sini
  }

  Future<void> _openEditProfile() async {
    if (_profile == null) return;

    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(profile: _profile!),
      ),
    );

    if (updated != null) {
      setState(() {
        _profile = updated;
      });
    }
  }

  Future<void> _exitAccount() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    if (mounted) {
      context.go('/onboarding');
    }
  }

  Future<void> _deleteAccountConfirmed() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        await supabase.from('users').delete().eq('id', user.id);
      } catch (e) {
        debugPrint('Error delete user row: $e');
      }
    }

    await supabase.auth.signOut();
    if (mounted) {
      context.go('/onboarding');
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x33000000),
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.8,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Warning! If you delete your account now, you can't create a new account again with this email for 7 days!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _deleteAccountConfirmed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF304369),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
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
          ),
        );
      },
    );
  }

  void _showExitAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0x33000000),
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.8,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Exit account?',
                    style: TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You will be logged out from this device.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _exitAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF304369),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
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
          ),
        );
      },
    );
  }

  Future<void> _openSwitchRolePage() async {
    final selectedRole = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => RoleSelectionPage(initialRole: _currentRole),
      ),
    );

    if (selectedRole != null && selectedRole != _currentRole) {
      setState(() {
        _currentRole = selectedRole;
      });

      // Simpan role ke tabel users
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user != null) {
        try {
          await supabase
              .from('users')
              .update({'role': selectedRole})
              .eq('id', user.id);
        } catch (e) {
          debugPrint('Error update role: $e');
        }
      }
    }
  }

  ImageProvider _buildAvatarImage(String path) {
    final effectivePath = (path.isEmpty) ? kDefaultAvatarPath : path;

    if (effectivePath.startsWith('assets/')) {
      return AssetImage(effectivePath);
    }
    if (kIsWeb) {
      return NetworkImage(effectivePath);
    }
    return FileImage(File(effectivePath));
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_profile == null)
                      ? const Center(child: Text('No profile data'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: Column(
                            children: [
                              _ProfileHeaderCard(
                                profile: _profile!,
                                imageProvider:
                                    _buildAvatarImage(_profile!.avatarPath),
                              ),
                              const SizedBox(height: 20),
                              _MenuItemCard(
                                icon: Icons.person_outline,
                                title: 'Account',
                                onTap: _openEditProfile,
                              ),
                              const SizedBox(height: 12),
                              _MenuItemCard(
                                icon: Icons.attach_money,
                                title: 'Statistics',
                                onTap: () => context.go('/revenue'),
                              ),
                              const SizedBox(height: 12),
                              _MenuItemCard(
                                icon: Icons.delete_outline,
                                title: 'Delete Account',
                                showBadge: false,
                                onTap: _showDeleteAccountDialog,
                              ),
                              const SizedBox(height: 12),
                              _MenuItemCard(
                                icon: Icons.exit_to_app,
                                title: 'Exit Account',
                                onTap: _showExitAccountDialog,
                              ),
                              const SizedBox(height: 12),
                              _MenuItemCard(
                                icon: Icons.account_balance_outlined,
                                title: 'Bank Account',
                                onTap: () {},
                              ),
                              const SizedBox(height: 12),
                              _MenuItemCard(
                                icon: Icons.swap_horiz,
                                title: 'Switch Role',
                                onTap: _openSwitchRolePage,
                              ),
                              const SizedBox(height: 32),
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

class _ProfileHeaderCard extends StatelessWidget {
  final UserProfile profile;
  final ImageProvider imageProvider;

  const _ProfileHeaderCard({
    required this.profile,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFD9EEFF),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF304369),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showBadge;

  const _MenuItemCard({
    required this.icon,
    required this.title,
    this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFFD9EEFF),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF304369).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: const Color(0xFF304369),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF304369),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
