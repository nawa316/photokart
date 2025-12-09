import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_model.dart';

abstract class AuthRepository {
  /// Register a new user
  /// 
  /// Returns [Right(UserModel)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, UserModel>> register({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String role,
  });

  /// Sign in with email and password
  /// 
  /// Returns [Right(UserModel)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, UserModel>> login({
    required String emailOrUsername,
    required String password,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// Check if user is authenticated
  bool isAuthenticated();
}
