import 'package:supabase_flutter/supabase_flutter.dart';
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
    required String role,
  }) async {
    try {
      // Sign up with Supabase Auth
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'phone': phone,
          'role': role,
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed: User is null');
      }

      // Create user profile in database
      await _supabaseService.client.from('users').insert({
        'id': response.user!.id,
        'username': username,
        'email': email,
        'phone': phone,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Fetch the created user profile
      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
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
        // Fetch email from username
        final result = await _supabaseService.client
            .from('users')
            .select('email')
            .eq('username', emailOrUsername)
            .single();
        
        email = result['email'] as String;
      }

      // Sign in with email and password
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: User is null');
      }

      // Fetch user profile
      final userProfile = await _supabaseService.client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    try {
      await _supabaseService.client.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseService.currentUser;
      
      if (user == null) {
        return null;
      }

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

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabaseService.isAuthenticated;
  }
}
