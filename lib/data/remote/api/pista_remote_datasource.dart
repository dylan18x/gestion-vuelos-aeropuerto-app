import 'package:dio/dio.dart';
<<<<<<< HEAD
import '../../../domain/model/pista.dart';

class PistaRemoteDatasource {
  final Dio _dio;
  PistaRemoteDatasource(this._dio);

  Future<List<Pista>> getPistas() async {
    final response = await _dio.get('/pista/'); // Asegúrate de que esta ruta coincida con tu backend
    return (response.data as List)
        .map((e) => Pista.fromJson(e))
        .toList();
  }
}
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/pista.dart';
import 'dio_client.dart';

abstract class PistaRemoteDatasource {
  Future<List<Pista>> getPistas();
  Future<Pista> getPista(int id);
  Future<Pista> createPista(Map<String, dynamic> payload);
  Future<Pista> updatePista(int id, Map<String, dynamic> payload);
  Future<void> deletePista(int id);
}

class PistaRemoteDatasourceImpl implements PistaRemoteDatasource {
  final Dio _dio;
  PistaRemoteDatasourceImpl(this._dio);

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
  Future<List<Pista>> getPistas() async {
    try {
      final response = await _dio.get('/pistas/');
      return _extractList(response.data)
          .map((e) => Pista.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Pista> getPista(int id) async {
    try {
      final response = await _dio.get('/pistas/$id/');
      return Pista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Pista> createPista(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/pistas/', data: payload);
      return Pista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Pista> updatePista(int id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch('/pistas/$id/', data: payload);
      return Pista.fromJson(_extractMap(response.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deletePista(int id) async {
    try {
      await _dio.delete('/pistas/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final pistaDatasourceProvider = Provider<PistaRemoteDatasource>((ref) {
  return PistaRemoteDatasourceImpl(ref.watch(dioProvider));
});
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
