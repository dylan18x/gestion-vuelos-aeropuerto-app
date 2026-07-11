// lib/data/remote/api/incidente_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/incidente.dart';
import 'dio_client.dart';

abstract class IncidenteRemoteDatasource {
  Future<PaginatedIncidentes> getIncidentes({int? idVuelo});
  Future<Incidente> getIncidente(int id);
  Future<Incidente> createIncidente(Map<String, dynamic> payload);
  Future<Incidente> updateIncidente(int id, Map<String, dynamic> payload);
  Future<void> deleteIncidente(int id);
}

class IncidenteRemoteDatasourceImpl implements IncidenteRemoteDatasource {
  final Dio _dio;
  IncidenteRemoteDatasourceImpl(this._dio);

  @override
  Future<PaginatedIncidentes> getIncidentes({int? idVuelo}) async {
    try {
      final params = <String, dynamic>{
        if (idVuelo != null) 'id_vuelo': idVuelo,
      };
      final res = await _dio.get('/incidentes/', queryParameters: params);
      return PaginatedIncidentes.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Incidente> getIncidente(int id) async {
    try {
      final res = await _dio.get('/incidentes/$id/');
      return Incidente.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Incidente> createIncidente(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/incidentes/', data: payload);
      return Incidente.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Incidente> updateIncidente(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/incidentes/$id/', data: payload);
      return Incidente.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteIncidente(int id) async {
    try {
      await _dio.delete('/incidentes/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final incidenteDatasourceProvider = Provider<IncidenteRemoteDatasource>((ref) {
  return IncidenteRemoteDatasourceImpl(ref.watch(dioProvider));
});