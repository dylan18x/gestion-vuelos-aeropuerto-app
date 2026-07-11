import 'package:dio/dio.dart';
import '../../domain/model/asignacion_tripulacion.dart'; // Ajusta la ruta

class AsignacionTripulacionRemoteDatasource {
  final Dio _dio;

  AsignacionTripulacionRemoteDatasource(this._dio);

  Future<List<AsignacionTripulacion>> getAsignaciones() async {
    final response = await _dio.get('/asignacion-tripulacion/'); // Tu endpoint
    return (response.data as List)
        .map((e) => AsignacionTripulacion.fromJson(e))
        .toList();
  }
}