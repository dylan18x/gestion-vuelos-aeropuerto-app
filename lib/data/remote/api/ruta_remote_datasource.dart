// lib/data/remote/api/ruta_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/ruta.dart';
import 'dio_client.dart';

abstract class RutaRemoteDatasource {
  Future<List<Ruta>> getRutas();
  Future<Ruta>        getRuta(int id);
  Future<Ruta>        createRuta(Map<String, dynamic> payload);
  Future<Ruta>        updateRuta(int id, Map<String, dynamic> payload);
  Future<void>         deleteRuta(int id);
}

class RutaRemoteDatasourceImpl implements RutaRemoteDatasource {
  final Dio _dio;
  RutaRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Ruta>> getRutas() async {
    try {
      final res = await _dio.get('/rutas/');
      // Ajusta esto si tu API pagina: usa res.data['results'] en vez de res.data
      return (res.data as List)
          .map((e) => Ruta.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Ruta> getRuta(int id) async {
    try {
      final res = await _dio.get('/rutas/$id/');
      return Ruta.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Ruta> createRuta(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/rutas/', data: payload);
      return Ruta.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Ruta> updateRuta(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/rutas/$id/', data: payload);
      return Ruta.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteRuta(int id) async {
    try {
      await _dio.delete('/rutas/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final rutaDatasourceProvider = Provider<RutaRemoteDatasource>((ref) {
  return RutaRemoteDatasourceImpl(ref.watch(dioProvider));
});