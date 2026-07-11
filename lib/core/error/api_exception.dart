// lib/core/error/api_exception.dart
import 'package:dio/dio.dart';
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('El servidor tardó demasiado en responder.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException('No hay conexión con el servidor.');
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (status == 401) {
      return ApiException('Sesión expirada, inicia sesión de nuevo.', statusCode: 401);
    }
    if (status == 403) {
      return ApiException('No tienes permiso para hacer esto.', statusCode: 403);
    }
    if (status == 404) {
      return ApiException('No se encontró el recurso.', statusCode: 404);
    }

    if (data is Map && data.isNotEmpty) {
      final firstError = data.values.first;
      final msg = firstError is List ? firstError.first.toString() : firstError.toString();
      return ApiException(msg, statusCode: status);
    }

    return ApiException('Ocurrió un error inesperado.', statusCode: status);
  }

  @override
  String toString() => message;
}