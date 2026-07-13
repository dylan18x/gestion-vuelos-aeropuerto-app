// lib/data/remote/api/avion_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/avion.dart';
import 'dio_client.dart';

abstract class AvionRemoteDatasource {
  Future<List<Avion>> getAviones();
  Future<Avion>       getAvion(int id);
  Future<Avion>       createAvion(Map<String, dynamic> payload);
  Future<Avion>       updateAvion(int id, Map<String, dynamic> payload);
  Future<void>        deleteAvion(int id);
}

class AvionRemoteDatasourceImpl implements AvionRemoteDatasource {
  final Dio _dio;
  AvionRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Avion>> getAviones() async {
    try {
      final res = await _dio.get('/aviones/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Avion.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Avion> getAvion(int id) async {
    try {
      final res = await _dio.get('/aviones/$id/');
      return Avion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Avion> createAvion(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/aviones/', data: payload);
      return Avion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Avion> updateAvion(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/aviones/$id/', data: payload);
      return Avion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteAvion(int id) async {
    try {
      await _dio.delete('/aviones/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final avionDatasourceProvider = Provider<AvionRemoteDatasource>((ref) =>
  AvionRemoteDatasourceImpl(ref.watch(dioProvider)));
