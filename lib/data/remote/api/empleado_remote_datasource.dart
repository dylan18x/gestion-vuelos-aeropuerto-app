// lib/data/remote/api/empleado_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/empleado.dart';
import 'dio_client.dart';

abstract class EmpleadoRemoteDatasource {
  Future<PaginatedEmpleados> getEmpleados({String? cargo});
  Future<Empleado>           getEmpleado(int id);
  Future<Empleado>           createEmpleado(Map<String, dynamic> payload);
  Future<Empleado>           updateEmpleado(int id, Map<String, dynamic> payload);
  Future<void>                deleteEmpleado(int id);
}

class EmpleadoRemoteDatasourceImpl implements EmpleadoRemoteDatasource {
  final Dio _dio;
  EmpleadoRemoteDatasourceImpl(this._dio);

  @override
  Future<PaginatedEmpleados> getEmpleados({String? cargo}) async {
    try {
      final params = <String, dynamic>{
        if (cargo != null) 'cargo': cargo,
      };
      final res = await _dio.get('/empleados/', queryParameters: params);
      return PaginatedEmpleados.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Empleado> getEmpleado(int id) async {
    try {
      final res = await _dio.get('/empleados/$id/');
      return Empleado.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Empleado> createEmpleado(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/empleados/', data: payload);
      return Empleado.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<Empleado> updateEmpleado(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.patch('/empleados/$id/', data: payload);
      return Empleado.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteEmpleado(int id) async {
    try {
      await _dio.delete('/empleados/$id/');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final empleadoDatasourceProvider = Provider<EmpleadoRemoteDatasource>((ref) {
  return EmpleadoRemoteDatasourceImpl(ref.watch(dioProvider));
});