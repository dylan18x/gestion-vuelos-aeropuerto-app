// lib/data/remote/api/clima_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/clima.dart';
import 'dio_client.dart';

abstract class ClimaRemoteDatasource {
  Future<List<Clima>> getClimas();
  Future<Clima>       getClima(int id);
  Future<Clima>       createClima(Map<String, dynamic> payload);
  Future<Clima>       updateClima(int id, Map<String, dynamic> payload);
  Future<void>        deleteClima(int id);
}

class ClimaRemoteDatasourceImpl implements ClimaRemoteDatasource {
  final Dio _dio;
  ClimaRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Clima>> getClimas() async {
    try {
      final res = await _dio.get('/Clima/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Clima.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Clima> getClima(int id) async {
    try {
      final res = await _dio.get('/Clima/$id/');
      return Clima.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Clima> createClima(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/Clima/', data: payload);
      return Clima.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Clima> updateClima(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/Clima/$id/', data: payload);
      return Clima.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteClima(int id) async {
    try {
      await _dio.delete('/Clima/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final climaDatasourceProvider = Provider<ClimaRemoteDatasource>((ref) =>
  ClimaRemoteDatasourceImpl(ref.watch(dioProvider)));
