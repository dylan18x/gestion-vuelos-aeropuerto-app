// lib/data/remote/api/horario_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/horario.dart';
import 'dio_client.dart';

abstract class HorarioRemoteDatasource {
  Future<Horario> getHorarioByVuelo(int idVuelo);
  Future<Horario> createHorario(Map<String, dynamic> payload);
  Future<Horario> updateHorario(int id, Map<String, dynamic> payload);
  Future<void>     deleteHorario(int id);
}

class HorarioRemoteDatasourceImpl implements HorarioRemoteDatasource {
  final Dio _dio;
  HorarioRemoteDatasourceImpl(this._dio);

  @override
  Future<Horario> getHorarioByVuelo(int idVuelo) async {
    try {
      // Ajusta el filtro al que use tu API: puede ser query param o ruta anidada
      final res = await _dio.get('/horarios/', queryParameters: {'id_vuelo': idVuelo});
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return Horario.fromJson(list.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Horario> createHorario(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/horarios/', data: payload);
      return Horario.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Horario> updateHorario(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/horarios/$id/', data: payload);
      return Horario.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteHorario(int id) async {
    try {
      await _dio.delete('/horarios/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final horarioDatasourceProvider = Provider<HorarioRemoteDatasource>((ref) {
  return HorarioRemoteDatasourceImpl(ref.watch(dioProvider));
});