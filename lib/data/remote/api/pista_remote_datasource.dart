import 'package:dio/dio.dart';
import '../../../domain/model/pista.dart';

class PistaRemoteDatasource {
  final Dio _dio;
  PistaRemoteDatasource(this._dio);

  Future<List<Pista>> getPistas() async {
    final response = await _dio.get('/pista/'); // Asegúrate de que esta ruta coincida con tu backend
    return (response.data as List)
        .map((e) => Pista.fromJson(e))
        .toList();
  }
}