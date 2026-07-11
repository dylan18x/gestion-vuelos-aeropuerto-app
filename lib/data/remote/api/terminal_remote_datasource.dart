// lib/data/remote/api/terminal_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/api_exception.dart';
import '../../../domain/model/terminal.dart';
import 'dio_client.dart';

abstract class TerminalRemoteDatasource {
  Future<List<Terminal>> getTerminales();
  Future<Terminal>       getTerminal(int id);
  Future<Terminal>       createTerminal(Map<String, dynamic> payload);
  Future<Terminal>       updateTerminal(int id, Map<String, dynamic> payload);
  Future<void>           deleteTerminal(int id);
}

class TerminalRemoteDatasourceImpl implements TerminalRemoteDatasource {
  final Dio _dio;
  TerminalRemoteDatasourceImpl(this._dio);

  @override
  Future<List<Terminal>> getTerminales() async {
    try {
      final res = await _dio.get('/terminales/');
      final list = res.data is List ? res.data as List : (res.data['results'] as List);
      return list.map((e) => Terminal.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Terminal> getTerminal(int id) async {
    try {
      final res = await _dio.get('/terminales/$id/');
      return Terminal.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Terminal> createTerminal(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post('/terminales/', data: payload);
      return Terminal.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<Terminal> updateTerminal(int id, Map<String, dynamic> payload) async {
    try {
      final res = await _dio.put('/terminales/$id/', data: payload);
      return Terminal.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }

  @override
  Future<void> deleteTerminal(int id) async {
    try {
      await _dio.delete('/terminales/$id/');
    } on DioException catch (e) { throw ApiException.fromDioError(e); }
  }
}

final terminalDatasourceProvider = Provider<TerminalRemoteDatasource>((ref) =>
  TerminalRemoteDatasourceImpl(ref.watch(dioProvider)));
