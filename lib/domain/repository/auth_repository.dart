// lib/domain/repository/auth_repository.dart
import '../model/auth_models.dart';

abstract class AuthRepository {
  Future<AuthTokens> login(String username, String password);
  
  Future<void> logout(String refreshToken);
  
  Future<LoggedUser> getProfile();
  
  Future<AuthTokens> refreshToken(String refreshToken);
}