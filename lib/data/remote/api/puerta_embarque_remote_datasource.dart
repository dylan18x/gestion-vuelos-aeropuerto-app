// lib/data/remote/api/puerta_embarque_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/puerta_embarque.dart';
import 'dio_client.dart';

abstract class PuertaEmbarqueRemoteDatasource {
  Future<List<PuertaEmbarque>> getPuertas();
  Future<PuertaEmbarque>       getPuerta(int id);
  Future<PuertaEmbarque>       createPuerta(Map<String, dynamic> payload);
  Future<PuertaEmbarque>       updatePuerta(int id, Map<String, dynamic> payload);
  Future<void>                 deletePuerta(int id);
}

class PuertaEmbarqueRemoteDatasourceImpl implements PuertaEmbarqueRemoteDatasource {
  final Dio _dio;
  PuertaEmbarqueRemoteDatasourceImpl(this._dio);

  @override
  Future<List<PuertaEmbarque>> getPuertas() async {
    try {
      final res = await _dio.get('/puertas-embarque/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => PuertaEmbarque.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<PuertaEmbarque> getPuerta(int id) async {
    try {
      final res = await _dio.get('/puertas-embarque/$id/');
      return PuertaEmbarque.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<PuertaEmbarque> createPuerta(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/puertas-embarque/', data: payload);
      return PuertaEmbarque.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<PuertaEmbarque> updatePuerta(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/puertas-embarque/$id/', data: payload);
      return PuertaEmbarque.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deletePuerta(int id) async {
    try {
      await _dio.delete('/puertas-embarque/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final puertaEmbarqueDatasourceProvider = Provider<PuertaEmbarqueRemoteDatasource>((ref) =>
  PuertaEmbarqueRemoteDatasourceImpl(ref.watch(dioProvider)));
