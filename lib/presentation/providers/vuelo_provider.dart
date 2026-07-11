// lib/presentation/providers/vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/vuelo_repository_impl.dart';
import '../../domain/model/vuelo.dart';

final vuelosProvider = FutureProvider.autoDispose<PaginatedVuelos>((ref) async {
  final repo = ref.watch(vueloRepositoryProvider);
  return repo.getVuelos();
});

final vueloDetalleProvider =
    FutureProvider.autoDispose.family<Vuelo, int>((ref, id) async {
  final repo = ref.watch(vueloRepositoryProvider);
  return repo.getVuelo(id);
});