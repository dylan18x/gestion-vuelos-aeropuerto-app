import 'package:dio/dio.dart';
import '../../../domain/model/autorizacion_vuelo.dart';

class AutorizacionVueloRemoteDatasource {
  final Dio _dio;
  AutorizacionVueloRemoteDatasource(this._dio);

  Future<List<AutorizacionVuelo>> getAutorizaciones() async {
    final response = await _dio.get('/autorizacion-vuelo/');
    return (response.data as List).map((e) => AutorizacionVuelo.fromJson(e)).toList();
  }
}