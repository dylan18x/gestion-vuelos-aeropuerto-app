// lib/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/secure_storage.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/model/user.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.isStaff ?? false;

  AuthState copyWith({User? user, bool? isLoading, String? error, bool clearUser = false}) => AuthState(
    user:      clearUser ? null : (user ?? this.user),
    isLoading: isLoading ?? this.isLoading,
    error:     error,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AuthState());

  Future<void> checkAuth() async {
    final storage = _ref.read(secureStorageProvider);
    final hasToken = await storage.hasToken();
    if (!hasToken) return;
    try {
      state = state.copyWith(isLoading: true);
      final role = await storage.getUserRole();
      final idStr = await storage.getUserId();
      final user = User(
        id: int.tryParse(idStr ?? '') ?? 0,
        username: 'Usuario Logueado',
        email: '',
        firstName: '',
        lastName: '',
        isStaff: role == 'admin',
        isActive: true,
        dateJoined: '',
        numOrders: 0,
      );
      state = AuthState(user: user);
    } catch (_) {
      await storage.clearAll();
      state = const AuthState();
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo    = _ref.read(authRepositoryProvider);
      final storage = _ref.read(secureStorageProvider);
      final data    = await repo.login(username, password);
      
      await storage.saveAccessToken(data['access']  as String);
      await storage.saveRefreshToken(data['refresh'] as String);
      
      final user = User.fromJson(data);
      await storage.saveUserId(user.id.toString());
      await storage.saveUserRole(user.isStaff ? 'admin' : 'torre');
      
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final refresh = await storage.getRefreshToken();
      if (refresh != null) {
        await _ref.read(authRepositoryProvider).logout(refresh);
      }
    } catch (_) {}
    await _ref.read(secureStorageProvider).clearAll();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref));
