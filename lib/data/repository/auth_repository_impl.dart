// lib/data/repository/auth_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../remote/api/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _ds;
  AuthRepositoryImpl(this._ds);

  @override Future<Map<String, dynamic>> login(String u, String p) => _ds.login(u, p);
  @override Future<void> logout(String r) => _ds.logout(r);
  @override Future<User> getProfile() => _ds.getProfile();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
  AuthRepositoryImpl(ref.watch(authDatasourceProvider)));
<<<<<<< HEAD
=======

>>>>>>> 2ac9d221a9c4dbd437bb849554b7fdb91de31fb7
