// lib/data/remote/api/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';

import '../../../domain/model/user.dart';
import 'dio_client.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<void>                 logout(String refreshToken);
  Future<User>                 getProfile();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final res = await _dio.post('/auth/login/', data: {
        'username': username,
        'password': password,
      });
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout/', data: {'refresh': refreshToken});
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      final res = await _dio.get('/users/profile/');
      return User.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) =>
  AuthRemoteDatasourceImpl(ref.watch(dioProvider)));
