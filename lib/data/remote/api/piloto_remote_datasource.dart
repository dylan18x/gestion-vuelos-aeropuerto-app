// lib/data/remote/api/piloto_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/piloto.dart';
import 'dio_client.dart';

abstract class PilotoRemoteDatasource {
  Future<List<Piloto>> getPilotos();
  Future<Piloto>        getPiloto(int id);
  Future<Piloto>        createPiloto(Map<String, dynamic> payload);
  Future<Piloto>        updatePiloto(int id, Map<String, dynamic> payload);
  Future<void>            deletePiloto(int id);
}

class PilotoRemoteDatasourceImpl implements PilotoRemoteDatasource {
  final Dio _dio;
  PilotoRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Piloto>> getPilotos() async {
    try {
      final res = await _dio.get('/pilotos/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Piloto.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Piloto> getPiloto(int id) async {
    try {
      final res = await _dio.get('/pilotos/$id/');
      return Piloto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Piloto> createPiloto(Map<String, dynamic> payload) async {
    try {
      // payload esperado: { 'licencia': '...', 'id_empleado': 5 }
      final res = await _dio.post('/pilotos/', data: payload);
      return Piloto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Piloto> updatePiloto(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/pilotos/$id/', data: payload);
      return Piloto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deletePiloto(int id) async {
    try {
      await _dio.delete('/pilotos/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final pilotoDatasourceProvider = Provider<PilotoRemoteDatasource>((ref) {
  return PilotoRemoteDatasourceImpl(ref.watch(dioProvider));
});