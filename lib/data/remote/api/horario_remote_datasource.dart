// lib/data/remote/api/horario_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/horario.dart';
import 'dio_client.dart';

abstract class HorarioRemoteDatasource {
  Future<Horario?> getHorarioByVuelo(int idVuelo);
  Future<Horario>  createHorario(Map<String, dynamic> payload);
  Future<Horario>  updateHorario(int id, Map<String, dynamic> payload);
  Future<void>     deleteHorario(int id);
}

class HorarioRemoteDatasourceImpl implements HorarioRemoteDatasource {
  final Dio _dio;
  HorarioRemoteDatasourceImpl(this._dio);

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
  Future<Horario?> getHorarioByVuelo(int idVuelo) async {
    try {
      final res = await _dio.get('/horarios/', queryParameters: {'id_vuelo': idVuelo});
      final list = _extractList(res.data);
      if (list.isEmpty) return null;
      return Horario.fromJson(list.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Horario> createHorario(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/horarios/', data: payload);
      return Horario.fromJson(_extractMap(res.data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Horario> updateHorario(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/horarios/$id/', data: payload);
      return Horario.fromJson(_extractMap(res.data));
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