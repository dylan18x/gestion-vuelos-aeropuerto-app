// lib/domain/repository/auth_repository.dart
<<<<<<< HEAD
import '../model/auth_models.dart';

abstract class AuthRepository {
  Future<AuthTokens> login(String username, String password);
  
  Future<void> logout(String refreshToken);
  
  Future<LoggedUser> getProfile();
  
  Future<AuthTokens> refreshToken(String refreshToken);
}
=======
import '../model/user.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout(String refreshToken);
  Future<User> getProfile();
}
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
