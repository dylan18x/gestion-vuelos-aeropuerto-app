// lib/data/remote/api/escala_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/escala.dart';
import 'dio_client.dart';

abstract class EscalaRemoteDatasource {
  /// Un vuelo puede tener 0, 1 o varias escalas -> devuelve lista.
  Future<List<Escala>> getEscalasByVuelo(int idVuelo);
  Future<Escala>        createEscala(Map<String, dynamic> payload);
  Future<void>           deleteEscala(int id);
}

class EscalaRemoteDatasourceImpl implements EscalaRemoteDatasource {
  final Dio _dio;
  EscalaRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Escala>> getEscalasByVuelo(int idVuelo) async {
    try {
      final res = await _dio.get('/escalas/', queryParameters: {'id_vuelo': idVuelo});
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Escala.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Escala> createEscala(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/escalas/', data: payload);
      return Escala.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteEscala(int id) async {
    try {
      await _dio.delete('/escalas/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final escalaDatasourceProvider = Provider<EscalaRemoteDatasource>((ref) {
  return EscalaRemoteDatasourceImpl(ref.watch(dioProvider));
});
