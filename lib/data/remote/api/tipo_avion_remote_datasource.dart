// lib/data/remote/api/tipo_avion_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/tipo_avion.dart';
import 'dio_client.dart';

abstract class TipoAvionRemoteDatasource {
  Future<List<TipoAvion>> getTiposAvion();
  Future<TipoAvion>       getTipoAvion(int id);
  Future<TipoAvion>       createTipoAvion(Map<String, dynamic> payload);
  Future<TipoAvion>       updateTipoAvion(int id, Map<String, dynamic> payload);
  Future<void>            deleteTipoAvion(int id);
}

class TipoAvionRemoteDatasourceImpl implements TipoAvionRemoteDatasource {
  final Dio _dio;
  TipoAvionRemoteDatasourceImpl(this._dio);

  @override
  Future<List<TipoAvion>> getTiposAvion() async {
    try {
      final res = await _dio.get('/tipos-avion/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => TipoAvion.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<TipoAvion> getTipoAvion(int id) async {
    try {
      final res = await _dio.get('/tipos-avion/$id/');
      return TipoAvion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<TipoAvion> createTipoAvion(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/tipos-avion/', data: payload);
      return TipoAvion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<TipoAvion> updateTipoAvion(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/tipos-avion/$id/', data: payload);
      return TipoAvion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteTipoAvion(int id) async {
    try {
      await _dio.delete('/tipos-avion/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final tipoAvionDatasourceProvider = Provider<TipoAvionRemoteDatasource>((ref) =>
  TipoAvionRemoteDatasourceImpl(ref.watch(dioProvider)));
