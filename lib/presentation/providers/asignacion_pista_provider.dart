// lib/presentation/providers/asignacion_pista_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/asignacion_pista_repository_impl.dart';
import '../../domain/model/asignacion_pista.dart';

final asignacionesPistaProvider = FutureProvider.autoDispose<List<AsignacionPista>>(
  (ref) => ref.watch(asignacionPistaRepositoryProvider).getAllAsignacionesPista(),
);

final asignacionPistaDetalleProvider =
    FutureProvider.autoDispose.family<AsignacionPista, int>(
  (ref, id) => ref.watch(asignacionPistaRepositoryProvider).getAsignacionPistaById(id),
);