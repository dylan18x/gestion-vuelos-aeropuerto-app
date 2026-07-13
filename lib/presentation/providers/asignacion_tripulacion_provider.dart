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