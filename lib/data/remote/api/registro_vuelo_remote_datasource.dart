// lib/data/remote/api/registro_vuelo_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/registro_vuelo.dart';
import 'dio_client.dart';

abstract class RegistroVueloRemoteDatasource {
  Future<PaginatedRegistrosVuelo> getRegistrosVuelo({int? idVuelo});
  Future<RegistroVuelo> getRegistroVuelo(int id);
  Future<RegistroVuelo> createRegistroVuelo(Map<String, dynamic> payload);
  Future<RegistroVuelo> updateRegistroVuelo(int id, Map<String, dynamic> payload);
  Future<void> deleteRegistroVuelo(int id);
}

class RegistroVueloRemoteDatasourceImpl implements RegistroVueloRemoteDatasource {
  final Dio _dio;
  RegistroVueloRemoteDatasourceImpl(this._dio);

  @override
  Future<PaginatedRegistrosVuelo> getRegistrosVuelo({int? idVuelo}) async {
    try {
      final params = <String, dynamic>{
        if (idVuelo != null) 'id_vuelo': idVuelo,
      };
      final res = await _dio.get('/registros-vuelo/', queryParameters: params);
      return PaginatedRegistrosVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<RegistroVuelo> getRegistroVuelo(int id) async {
    try {
      final res = await _dio.get('/registros-vuelo/$id/');
      return RegistroVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<RegistroVuelo> createRegistroVuelo(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/registros-vuelo/', data: payload);
      return RegistroVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<RegistroVuelo> updateRegistroVuelo(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/registros-vuelo/$id/', data: payload);
      return RegistroVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteRegistroVuelo(int id) async {
    try {
      await _dio.delete('/registros-vuelo/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final registroVueloDatasourceProvider = Provider<RegistroVueloRemoteDatasource>((ref) {
  return RegistroVueloRemoteDatasourceImpl(ref.watch(dioProvider));
});