// lib/presentation/providers/historial_estado_vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/historial_estado_vuelo_repository_impl.dart';
import '../../domain/model/historial_estado_vuelo.dart';

final allHistorialesEstadoVueloProvider =
    FutureProvider.autoDispose<List<HistorialEstadoVuelo>>((ref) async {
  final repo = ref.watch(historialEstadoVueloRepositoryProvider);
  return repo.getAllHistoriales();
});

final historialesEstadoVueloProvider =
    FutureProvider.autoDispose.family<List<HistorialEstadoVuelo>, int>((ref, idVuelo) async {
  final repo = ref.watch(historialEstadoVueloRepositoryProvider);
  return repo.getHistorialByVuelo(idVuelo);
});