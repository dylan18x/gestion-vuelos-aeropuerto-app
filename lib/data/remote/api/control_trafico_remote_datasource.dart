// lib/data/remote/api/control_trafico_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/control_trafico.dart';
import 'dio_client.dart';

abstract class ControlTraficoRemoteDatasource {
  Future<PaginatedControlesTrafico> getControlesTrafico({int? idVuelo});
  Future<ControlTrafico> getControlTrafico(int id);
  Future<ControlTrafico> createControlTrafico(Map<String, dynamic> payload);
  Future<ControlTrafico> updateControlTrafico(int id, Map<String, dynamic> payload);
  Future<void> deleteControlTrafico(int id);
}

class ControlTraficoRemoteDatasourceImpl implements ControlTraficoRemoteDatasource {
  final Dio _dio;
  ControlTraficoRemoteDatasourceImpl(this._dio);

  @override
  Future<PaginatedControlesTrafico> getControlesTrafico({int? idVuelo}) async {
    try {
      final params = <String, dynamic>{
        if (idVuelo != null) 'id_vuelo': idVuelo,
      };
      final res = await _dio.get('/controles-trafico/', queryParameters: params);
      return PaginatedControlesTrafico.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ControlTrafico> getControlTrafico(int id) async {
    try {
      final res = await _dio.get('/controles-trafico/$id/');
      return ControlTrafico.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ControlTrafico> createControlTrafico(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/controles-trafico/', data: payload);
      return ControlTrafico.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ControlTrafico> updateControlTrafico(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/controles-trafico/$id/', data: payload);
      return ControlTrafico.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteControlTrafico(int id) async {
    try {
      await _dio.delete('/controles-trafico/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final controlTraficoDatasourceProvider = Provider<ControlTraficoRemoteDatasource>((ref) {
  return ControlTraficoRemoteDatasourceImpl(ref.watch(dioProvider));
});