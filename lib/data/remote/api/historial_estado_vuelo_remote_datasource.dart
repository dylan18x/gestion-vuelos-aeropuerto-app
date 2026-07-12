// lib/data/remote/api/historial_estado_vuelo_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/historial_estado_vuelo.dart';
import 'dio_client.dart';

abstract class HistorialEstadoVueloRemoteDatasource {
  /// Historial global: TODOS los cambios de estado, de TODOS los vuelos.
  Future<List<HistorialEstadoVuelo>> getAllHistoriales();

  /// Historial de UN vuelo específico (por si luego lo necesitan
  /// dentro del detalle de un vuelo).
  Future<List<HistorialEstadoVuelo>> getHistorialByVuelo(int idVuelo);

  /// Registra un nuevo cambio de estado (lo hace el TECNICO).
  /// No hay update ni delete: el historial nunca se edita, solo crece.
  Future<HistorialEstadoVuelo> registrarCambioEstado(Map<String, dynamic> payload);
}

class HistorialEstadoVueloRemoteDatasourceImpl implements HistorialEstadoVueloRemoteDatasource {
  final Dio _dio;
  HistorialEstadoVueloRemoteDatasourceImpl(this._dio);

  @override
  Future<List<HistorialEstadoVuelo>> getAllHistoriales() async {
    try {
      final res = await _dio.get('/historial-estados-vuelo/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list
          .map((e) => HistorialEstadoVuelo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<HistorialEstadoVuelo>> getHistorialByVuelo(int idVuelo) async {
    try {
      final res = await _dio.get(
        '/historial-estados-vuelo/',
        queryParameters: {'id_vuelo': idVuelo},
      );
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list
          .map((e) => HistorialEstadoVuelo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<HistorialEstadoVuelo> registrarCambioEstado(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/historial-estados-vuelo/', data: payload);
      return HistorialEstadoVuelo.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final historialEstadoVueloDatasourceProvider =
    Provider<HistorialEstadoVueloRemoteDatasource>((ref) {
  return HistorialEstadoVueloRemoteDatasourceImpl(ref.watch(dioProvider));
});