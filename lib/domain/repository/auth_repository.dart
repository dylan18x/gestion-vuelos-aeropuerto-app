// lib/domain/repository/auth_repository.dart
<<<<<<< HEAD
import '../model/user.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void> logout(String refreshToken);
  Future<User> getProfile();
}
=======
import '../model/auth_models.dart';

abstract class AuthRepository {
  Future<AuthTokens> login(String username, String password);
  
  Future<void> logout(String refreshToken);
  
  Future<LoggedUser> getProfile();
  
  Future<AuthTokens> refreshToken(String refreshToken);
}
>>>>>>> 2ac9d221a9c4dbd437bb849554b7fdb91de31fb7
