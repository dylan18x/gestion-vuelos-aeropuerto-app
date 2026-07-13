import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/torre_control.dart';
import 'dio_client.dart';

abstract class TorreControlRemoteDatasource {
  Future<List<TorreControl>> getTorres();
  Future<TorreControl> getTorre(int id);
  Future<TorreControl> createTorre(Map<String, dynamic> payload);
  Future<TorreControl> updateTorre(int id, Map<String, dynamic> payload);
  Future<void> deleteTorre(int id);
}

class TorreControlRemoteDatasourceImpl implements TorreControlRemoteDatasource {
  final Dio _dio;
  TorreControlRemoteDatasourceImpl(this._dio);

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
  Future<List<TorreControl>> getTorres() async {
    try {
      final response = await _dio.get('/torres-control/');
      return _extractList(response.data)
          .map((e) => TorreControl.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<TorreControl> getTorre(int id) async {
    try {
      final response = await _dio.get('/torres-control/$id/');
      return TorreControl.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<TorreControl> createTorre(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/torres-control/', data: payload);
      return TorreControl.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<TorreControl> updateTorre(int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch('/torres-control/$id/', data: payload);
      return TorreControl.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteTorre(int id) async {
    try {
      await _dio.delete('/torres-control/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final torreControlDatasourceProvider = Provider<TorreControlRemoteDatasource>((ref) {
  return TorreControlRemoteDatasourceImpl(ref.watch(dioProvider));
});