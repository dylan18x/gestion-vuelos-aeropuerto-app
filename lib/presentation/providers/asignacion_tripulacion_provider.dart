import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart'; // O el archivo donde definiste tu dioProvider
import 'asignacion_tripulacion_remote_datasource.dart'; // Ajusta el nombre del archivo si es necesario

final asignacionTripulacionDatasourceProvider = Provider<AsignacionTripulacionRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider); 
  return AsignacionTripulacionRemoteDatasource(dio);
});