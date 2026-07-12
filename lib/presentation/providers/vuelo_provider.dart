// lib/presentation/providers/vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/vuelo_repository_impl.dart';
import '../../domain/model/vuelo.dart';

final vuelosProvider = FutureProvider.autoDispose<PaginatedVuelos>(
  (ref) => ref.watch(vueloRepositoryProvider).getVuelos(),
);

final vueloDetalleProvider =
    FutureProvider.autoDispose.family<Vuelo, int>(
  (ref, id) => ref.watch(vueloRepositoryProvider).getVuelo(id),
);