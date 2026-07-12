// lib/data/remote/api/aeropuerto_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/aeropuerto.dart';
import 'dio_client.dart';

abstract class AeropuertoRemoteDatasource {
  Future<List<Aeropuerto>> getAeropuertos();
  Future<Aeropuerto>       getAeropuerto(int id);
  Future<Aeropuerto>       createAeropuerto(Map<String, dynamic> payload);
  Future<Aeropuerto>       updateAeropuerto(int id, Map<String, dynamic> payload);
  Future<void>             deleteAeropuerto(int id);
}

class AeropuertoRemoteDatasourceImpl implements AeropuertoRemoteDatasource {
  final Dio _dio;
  AeropuertoRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Aeropuerto>> getAeropuertos() async {
    try {
      final res = await _dio.get('/aeropuertos/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Aeropuerto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aeropuerto> getAeropuerto(int id) async {
    try {
      final res = await _dio.get('/aeropuertos/$id/');
      return Aeropuerto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aeropuerto> createAeropuerto(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/aeropuertos/', data: payload);
      return Aeropuerto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aeropuerto> updateAeropuerto(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/aeropuertos/$id/', data: payload);
      return Aeropuerto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteAeropuerto(int id) async {
    try {
      await _dio.delete('/aeropuertos/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final aeropuertoDatasourceProvider = Provider<AeropuertoRemoteDatasource>((ref) =>
  AeropuertoRemoteDatasourceImpl(ref.watch(dioProvider)));
