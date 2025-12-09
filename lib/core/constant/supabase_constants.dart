import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConstants {
  // You can find these in your Supabase project settings
  static String get supabaseUrl => dotenv.env['SUPABASE_URL']!;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_KEY']!;
  
  // Table names
  static const String usersTable = 'users';
  
  // Auth error messages
  static const String emailAlreadyExists = 'Email already registered';
  static const String invalidCredentials = 'Invalid email or password';
  static const String weakPassword = 'Password should be at least 6 characters';
  static const String networkError = 'Network connection error';
}
