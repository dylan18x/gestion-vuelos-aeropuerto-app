// lib/data/remote/api/mantenimiento_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/mantenimiento.dart';
import 'dio_client.dart';

abstract class MantenimientoRemoteDatasource {
  Future<List<Mantenimiento>> getMantenimientos();
  Future<Mantenimiento>       getMantenimiento(int id);
  Future<Mantenimiento>       createMantenimiento(Map<String, dynamic> payload);
  Future<Mantenimiento>       updateMantenimiento(int id, Map<String, dynamic> payload);
  Future<void>                deleteMantenimiento(int id);
}

class MantenimientoRemoteDatasourceImpl implements MantenimientoRemoteDatasource {
  final Dio _dio;
  MantenimientoRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Mantenimiento>> getMantenimientos() async {
    try {
      final res = await _dio.get('/mantenimientos/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Mantenimiento.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Mantenimiento> getMantenimiento(int id) async {
    try {
      final res = await _dio.get('/mantenimientos/$id/');
      return Mantenimiento.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Mantenimiento> createMantenimiento(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/mantenimientos/', data: payload);
      return Mantenimiento.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Mantenimiento> updateMantenimiento(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/mantenimientos/$id/', data: payload);
      return Mantenimiento.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteMantenimiento(int id) async {
    try {
      await _dio.delete('/mantenimientos/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final mantenimientoDatasourceProvider = Provider<MantenimientoRemoteDatasource>((ref) =>
  MantenimientoRemoteDatasourceImpl(ref.watch(dioProvider)));
