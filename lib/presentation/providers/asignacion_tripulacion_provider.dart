<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart'; // O el archivo donde definiste tu dioProvider
import 'asignacion_tripulacion_remote_datasource.dart'; // Ajusta el nombre del archivo si es necesario

final asignacionTripulacionDatasourceProvider = Provider<AsignacionTripulacionRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider); 
  return AsignacionTripulacionRemoteDatasource(dio);
});
=======
// lib/presentation/providers/asignacion_tripulacion_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/asignacion_tripulacion_repository_impl.dart';
import '../../domain/model/asignacion_tripulacion.dart';

final asignacionesTripulacionProvider = FutureProvider.autoDispose<List<AsignacionTripulacion>>(
  (ref) => ref.watch(asignacionTripulacionRepositoryProvider).getAllAsignacionesTripulacion(),
);

final asignacionTripulacionDetalleProvider =
    FutureProvider.autoDispose.family<AsignacionTripulacion, int>(
  (ref, id) => ref.watch(asignacionTripulacionRepositoryProvider).getAsignacionTripulacionById(id),
);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
