// lib/data/remote/api/aerolinea_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/aerolinea.dart';
import 'dio_client.dart';

abstract class AerolineaRemoteDatasource {
  Future<List<Aerolinea>> getAerolineas();
  Future<Aerolinea>       getAerolinea(int id);
  Future<Aerolinea>       createAerolinea(Map<String, dynamic> payload);
  Future<Aerolinea>       updateAerolinea(int id, Map<String, dynamic> payload);
  Future<void>            deleteAerolinea(int id);
}

class AerolineaRemoteDatasourceImpl implements AerolineaRemoteDatasource {
  final Dio _dio;
  AerolineaRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Aerolinea>> getAerolineas() async {
    try {
      final res = await _dio.get('/aerolineas/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Aerolinea.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aerolinea> getAerolinea(int id) async {
    try {
      final res = await _dio.get('/aerolineas/$id/');
      return Aerolinea.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aerolinea> createAerolinea(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/aerolineas/', data: payload);
      return Aerolinea.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Aerolinea> updateAerolinea(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/aerolineas/$id/', data: payload);
      return Aerolinea.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteAerolinea(int id) async {
    try {
      await _dio.delete('/aerolineas/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final aerolineaDatasourceProvider = Provider<AerolineaRemoteDatasource>((ref) =>
  AerolineaRemoteDatasourceImpl(ref.watch(dioProvider)));
