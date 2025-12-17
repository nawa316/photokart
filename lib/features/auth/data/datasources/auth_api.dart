import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/user_model.dart';

class AuthApi {
  final SupabaseService _supabaseService;

  AuthApi(this._supabaseService);

  /// Register new user with Supabase Auth
  Future<UserModel> register({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // 1. CEK DUPLIKAT TERLEBIH DAHULU (PENTING)
      // Ini memastikan kita mendapat pesan error yang custom sesuai request Anda
      await _checkIsDuplicate(username, email);

      // 2. Jika lolos cek, baru daftar ke Supabase Auth
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'phone': phone,
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed: User is null');
      }

      // 3. Masukkan data ke tabel 'users'
      await _supabaseService.client.from('users').insert({
        'id': response.user!.id,
        'username': username,
        'email': email,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4. Ambil data profil yang baru dibuat
      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userProfile);

    } on AuthException catch (e) {
      // Menangkap error bawaan Supabase
      throw Exception(e.message);
    } catch (e) {
      // Membersihkan tulisan "Exception: " agar pesan di UI bersih
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// --- FUNGSI KHUSUS CEK DUPLIKAT ---
  Future<void> _checkIsDuplicate(String username, String email) async {
    // A. Cek Username
    final usernameCheck = await _supabaseService.client
        .from('users')
        .select('username')
        .eq('username', username)
        .limit(1) // <--- TAMBAHKAN INI (Ambil 1 saja cukup)
        .maybeSingle();

    if (usernameCheck != null) {
      throw Exception('Username already taken!');
    }

    // B. Cek Email
    final emailCheck = await _supabaseService.client
        .from('users')
        .select('email')
        .eq('email', email)
        .limit(1) // <--- TAMBAHKAN INI JUGA
        .maybeSingle();

    if (emailCheck != null) {
      throw Exception('Email already used! Use another email!');
    }
  }

  /// Sign in with email and password
  Future<UserModel> login({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      String email = emailOrUsername;

      // Check if input is username instead of email
      if (!emailOrUsername.contains('@')) {
        final result = await _supabaseService.client
            .from('users')
            .select('email')
            .eq('username', emailOrUsername)
            .maybeSingle();
        
        if (result == null) {
           throw Exception('Username not found');
        }
        email = result['email'] as String;
      }

      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: User is null');
      }

      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseService.client.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) return null;

      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(userProfile);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  bool isAuthenticated() {
    return _supabaseService.isAuthenticated;
  }

  /// ========== GOOGLE SIGN IN ==========
  /// Authenticate dengan Google dan return email
  /// Jika user belum ada di database, throw exception khusus
  Future<String> signInWithGoogle() async {
    try {
      // Use GoogleSignIn.instance for v7.0+
      final googleSignIn = GoogleSignIn.instance;
      
      // Initialize GoogleSignIn (required in v7.0+)
      await googleSignIn.initialize();
      
      // Create a completer to wait for authentication result
      final completer = Completer<GoogleSignInAccount?>();
      
      // Listen for authentication events
      final subscription = googleSignIn.authenticationEvents.listen(
        (event) {
          if (event is GoogleSignInAuthenticationEventSignIn) {
            if (!completer.isCompleted) {
              completer.complete(event.user);
            }
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          }
        },
        onError: (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );
      
      // Authenticate user (replaces signIn() in v7.0+)
      await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      
      // Wait for the authentication event
      final googleUser = await completer.future;
      subscription.cancel();
      
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Authenticate ke Supabase menggunakan Google token
      final response = await _supabaseService.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken ?? '',
      );

      if (response.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // Return email untuk ditampilkan di halaman selanjutnya
      return googleUser.email;
    } catch (e) {
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }

  /// Complete Google registration: simpan data user ke database
  Future<UserModel> completeGoogleRegistration({
    required String email,
    required String username,
    required String phone,
  }) async {
    try {
      final user = _supabaseService.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Cek username sudah ada atau tidak
      final usernameCheck = await _supabaseService.client
          .from('users')
          .select('username')
          .eq('username', username)
          .limit(1)
          .maybeSingle();

      if (usernameCheck != null) {
        throw Exception('Username already taken!');
      }

      // Insert ke tabel users
      await _supabaseService.client.from('users').insert({
        'id': user.id,
        'username': username,
        'email': email,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Ambil data user yang baru dibuat
      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Sign out dari Google dan Supabase
  Future<void> signOutGoogle() async {
    try {
      // Use GoogleSignIn.instance for v7.0+
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
      await _supabaseService.client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }
}