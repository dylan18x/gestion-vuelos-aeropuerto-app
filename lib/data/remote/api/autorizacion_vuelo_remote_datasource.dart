import 'package:dio/dio.dart';
<<<<<<< HEAD
import '../../../domain/model/autorizacion_vuelo.dart';

class AutorizacionVueloRemoteDatasource {
  final Dio _dio;
  AutorizacionVueloRemoteDatasource(this._dio);

  Future<List<AutorizacionVuelo>> getAutorizaciones() async {
    final response = await _dio.get('/autorizacion-vuelo/');
    return (response.data as List).map((e) => AutorizacionVuelo.fromJson(e)).toList();
  }
}
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/autorizacion_vuelo.dart';
import 'dio_client.dart';

abstract class AutorizacionVueloRemoteDatasource {
  Future<List<AutorizacionVuelo>> getAutorizaciones();
  Future<AutorizacionVuelo> getAutorizacion(int id);
  Future<AutorizacionVuelo> createAutorizacion(Map<String, dynamic> payload);
  Future<AutorizacionVuelo> updateAutorizacion(int id, Map<String, dynamic> payload);
  Future<void> deleteAutorizacion(int id);
}

class AutorizacionVueloRemoteDatasourceImpl implements AutorizacionVueloRemoteDatasource {
  final Dio _dio;
  AutorizacionVueloRemoteDatasourceImpl(this._dio);

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
  Future<List<AutorizacionVuelo>> getAutorizaciones() async {
    try {
      final response = await _dio.get('/autorizacion-vuelo/');
      return _extractList(response.data)
          .map((e) => AutorizacionVuelo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AutorizacionVuelo> getAutorizacion(int id) async {
    try {
      final response = await _dio.get('/autorizacion-vuelo/$id/');
      return AutorizacionVuelo.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AutorizacionVuelo> createAutorizacion(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/autorizacion-vuelo/', data: payload);
      return AutorizacionVuelo.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AutorizacionVuelo> updateAutorizacion(int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch('/autorizacion-vuelo/$id/', data: payload);
      return AutorizacionVuelo.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteAutorizacion(int id) async {
    try {
      await _dio.delete('/autorizacion-vuelo/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final autorizacionVueloDatasourceProvider = Provider<AutorizacionVueloRemoteDatasource>((ref) {
  return AutorizacionVueloRemoteDatasourceImpl(ref.watch(dioProvider));
});
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
