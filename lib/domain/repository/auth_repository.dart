// lib/domain/repository/auth_repository.dart
import '../model/user.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout(String refreshToken);
  Future<User> getProfile();
}
