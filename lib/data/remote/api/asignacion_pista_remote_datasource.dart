import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/asignacion_pista.dart';
import 'dio_client.dart';

abstract class AsignacionPistaRemoteDatasource {
  Future<List<AsignacionPista>> getAsignacionesPista();
  Future<AsignacionPista> getAsignacionPista(int id);
  Future<AsignacionPista> createAsignacionPista(Map<String, dynamic> payload);
  Future<AsignacionPista> updateAsignacionPista(int id, Map<String, dynamic> payload);
  Future<void> deleteAsignacionPista(int id);
}

class AsignacionPistaRemoteDatasourceImpl implements AsignacionPistaRemoteDatasource {
  final Dio _dio;
  AsignacionPistaRemoteDatasourceImpl(this._dio);

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
  Future<List<AsignacionPista>> getAsignacionesPista() async {
    try {
      final response = await _dio.get('/asignacion-pista/');
      return _extractList(response.data)
          .map((e) => AsignacionPista.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionPista> getAsignacionPista(int id) async {
    try {
      final response = await _dio.get('/asignacion-pista/$id/');
      return AsignacionPista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionPista> createAsignacionPista(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/asignacion-pista/', data: payload);
      return AsignacionPista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionPista> updateAsignacionPista(int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch('/asignacion-pista/$id/', data: payload);
      return AsignacionPista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteAsignacionPista(int id) async {
    try {
      await _dio.delete('/asignacion-pista/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final asignacionPistaDatasourceProvider = Provider<AsignacionPistaRemoteDatasource>((ref) {
  return AsignacionPistaRemoteDatasourceImpl(ref.watch(dioProvider));
});