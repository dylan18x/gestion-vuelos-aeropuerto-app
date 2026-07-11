// lib/data/remote/api/estado_vuelo_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/estado_vuelo.dart';
import 'dio_client.dart';

abstract class EstadoVueloRemoteDatasource {
  Future<List<EstadoVuelo>> getEstadoVuelos();
  Future<EstadoVuelo>       getEstadoVuelo(int id);
  Future<EstadoVuelo>       createEstadoVuelo(Map<String, dynamic> payload);
  Future<EstadoVuelo>       updateEstadoVuelo(int id, Map<String, dynamic> payload);
  Future<void>              deleteEstadoVuelo(int id);
}

class EstadoVueloRemoteDatasourceImpl implements EstadoVueloRemoteDatasource {
  final Dio _dio;
  EstadoVueloRemoteDatasourceImpl(this._dio);

  @override
  Future<List<EstadoVuelo>> getEstadoVuelos() async {
    try {
      final res = await _dio.get('/Estado_vuelo/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => EstadoVuelo.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<EstadoVuelo> getEstadoVuelo(int id) async {
    try {
      final res = await _dio.get('/Estado_vuelo/$id/');
      return EstadoVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<EstadoVuelo> createEstadoVuelo(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/Estado_vuelo/', data: payload);
      return EstadoVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<EstadoVuelo> updateEstadoVuelo(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/Estado_vuelo/$id/', data: payload);
      return EstadoVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteEstadoVuelo(int id) async {
    try {
      await _dio.delete('/Estado_vuelo/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final estadoVueloDatasourceProvider = Provider<EstadoVueloRemoteDatasource>((ref) =>
  EstadoVueloRemoteDatasourceImpl(ref.watch(dioProvider)));
