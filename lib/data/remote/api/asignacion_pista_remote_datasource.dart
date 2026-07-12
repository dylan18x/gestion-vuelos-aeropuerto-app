import 'package:dio/dio.dart';
import '../../../domain/model/asignacion_pista.dart';

class AsignacionPistaRemoteDatasource {
  final Dio _dio;
  AsignacionPistaRemoteDatasource(this._dio);

  Future<List<AsignacionPista>> getAsignacionesPista() async {
    final response = await _dio.get('/asignacion-pista/');
    return (response.data as List)
        .map((e) => AsignacionPista.fromJson(e))
        .toList();
  }
}