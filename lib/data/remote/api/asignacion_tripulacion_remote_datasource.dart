import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/asignacion_tripulacion.dart';
import 'dio_client.dart';

abstract class AsignacionTripulacionRemoteDatasource {
  Future<List<AsignacionTripulacion>> getAsignaciones();
  Future<AsignacionTripulacion> getAsignacion(int id);
  Future<AsignacionTripulacion> createAsignacion(Map<String, dynamic> payload);
  Future<AsignacionTripulacion> updateAsignacion(int id, Map<String, dynamic> payload);
  Future<void> deleteAsignacion(int id);
}

class AsignacionTripulacionRemoteDatasourceImpl implements AsignacionTripulacionRemoteDatasource {
  final Dio _dio;
  AsignacionTripulacionRemoteDatasourceImpl(this._dio);

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
  Future<List<AsignacionTripulacion>> getAsignaciones() async {
    try {
      final response = await _dio.get('/asignacion-tripulacion/');
      return _extractList(response.data)
          .map((e) => AsignacionTripulacion.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionTripulacion> getAsignacion(int id) async {
    try {
      final response = await _dio.get('/asignacion-tripulacion/$id/');
      return AsignacionTripulacion.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionTripulacion> createAsignacion(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/asignacion-tripulacion/', data: payload);
      return AsignacionTripulacion.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AsignacionTripulacion> updateAsignacion(int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch('/asignacion-tripulacion/$id/', data: payload);
      return AsignacionTripulacion.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteAsignacion(int id) async {
    try {
      await _dio.delete('/asignacion-tripulacion/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final asignacionTripulacionDatasourceProvider = Provider<AsignacionTripulacionRemoteDatasource>((ref) {
  return AsignacionTripulacionRemoteDatasourceImpl(ref.watch(dioProvider));
});