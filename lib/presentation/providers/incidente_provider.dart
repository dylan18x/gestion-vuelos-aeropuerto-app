// lib/presentation/providers/incidente_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/incidente_repository_impl.dart';
import '../../domain/model/incidente.dart';

final incidentesProvider = FutureProvider.autoDispose<PaginatedIncidentes>(
  (ref) => ref.watch(incidenteRepositoryProvider).getIncidentes(),
);

final incidenteDetalleProvider =
    FutureProvider.autoDispose.family<Incidente, int>(
  (ref, id) => ref.watch(incidenteRepositoryProvider).getIncidente(id),
);