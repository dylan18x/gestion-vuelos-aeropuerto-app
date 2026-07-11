// lib/data/remote/interceptor/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../../local/secure_storage.dart';

/// Adjunta el Bearer token en cada petición y maneja errores 401.
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final void Function() onUnauthorized;

  AuthInterceptor(this._storage, {required this.onUnauthorized});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _storage.clearAll();
      onUnauthorized();
    }
    handler.next(err);
  }
}
