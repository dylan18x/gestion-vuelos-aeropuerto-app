// lib/data/remote/api/vuelo_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/vuelo.dart';
import 'dio_client.dart';

abstract class VueloRemoteDatasource {
  Future<PaginatedVuelos> getVuelos({String? estado});
  Future<Vuelo>           getVuelo(int id);
  Future<Vuelo>           createVuelo(Map<String, dynamic> payload);
  Future<Vuelo>           updateVuelo(int id, Map<String, dynamic> payload);
  Future<void>            deleteVuelo(int id);
  Future<Vuelo>           assignAvion(int idVuelo, int idAvion);
}

class VueloRemoteDatasourceImpl implements VueloRemoteDatasource {
  final Dio _dio;
  VueloRemoteDatasourceImpl(this._dio);

  @override
  Future<PaginatedVuelos> getVuelos({String? estado}) async {
    try {
      final params = <String, dynamic>{
        if (estado != null) 'estado': estado,
      };
      final res = await _dio.get('/vuelos/', queryParameters: params);
      return PaginatedVuelos.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Vuelo> getVuelo(int id) async {
    try {
      final res = await _dio.get('/vuelos/$id/');
      return Vuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Vuelo> createVuelo(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/vuelos/', data: payload);
      return Vuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Vuelo> updateVuelo(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/vuelos/$id/', data: payload);
      return Vuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteVuelo(int id) async {
    try {
      await _dio.delete('/vuelos/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Vuelo> assignAvion(int idVuelo, int idAvion) async {
    try {
      final res = await _dio.patch(
        '/vuelos/$idVuelo/',
        data: {'id_avion': idAvion},
      );
      return Vuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final vueloDatasourceProvider = Provider<VueloRemoteDatasource>((ref) {
  return VueloRemoteDatasourceImpl(ref.watch(dioProvider));
});