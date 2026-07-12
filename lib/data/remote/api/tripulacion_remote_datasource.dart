// lib/data/remote/api/tripulacion_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/tripulacion.dart';
import 'dio_client.dart';

abstract class TripulacionRemoteDatasource {
  Future<List<Tripulacion>> getTripulacion();
  Future<Tripulacion>        getTripulante(int id);
  Future<Tripulacion>        createTripulante(Map<String, dynamic> payload);
  Future<Tripulacion>        updateTripulante(int id, Map<String, dynamic> payload);
  Future<void>                 deleteTripulante(int id);
}

class TripulacionRemoteDatasourceImpl implements TripulacionRemoteDatasource {
  final Dio _dio;
  TripulacionRemoteDatasourceImpl(this._dio);

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
  Future<List<Tripulacion>> getTripulacion() async {
    try {
      final res = await _dio.get('/tripulacion/');
      return _extractList(res.data)
          .map((e) => Tripulacion.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Tripulacion> getTripulante(int id) async {
    try {
      final res = await _dio.get('/tripulacion/$id/');
      return Tripulacion.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Tripulacion> createTripulante(Map<String, dynamic> payload) async {
    try {
      // payload esperado: { 'cargo': 'Sobrecargo', 'id_empleado': 8 }
      final res = await _dio.post('/tripulacion/', data: payload);
      return Tripulacion.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Tripulacion> updateTripulante(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/tripulacion/$id/', data: payload);
      return Tripulacion.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteTripulante(int id) async {
    try {
      await _dio.delete('/tripulacion/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final tripulacionDatasourceProvider = Provider<TripulacionRemoteDatasource>((ref) {
  return TripulacionRemoteDatasourceImpl(ref.watch(dioProvider));
});