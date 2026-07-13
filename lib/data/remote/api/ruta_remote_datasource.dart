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

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final results = data['results'];
      if (results is List) return results;
      if (results is Map) return [results];
      return [data];
    }
    throw FormatException('Respuesta inesperada del servidor: $data');
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    throw FormatException('Respuesta inesperada del servidor: $data');
  }

  @override
  Future<List<Ruta>> getRutas() async {
    try {
      final res = await _dio.get('/rutas/');
      return _extractList(res.data)
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
      return Ruta.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Ruta> createRuta(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/rutas/', data: payload);
      return Ruta.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Ruta> updateRuta(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/rutas/$id/', data: payload);
      return Ruta.fromJson(_extractMap(res.data));
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