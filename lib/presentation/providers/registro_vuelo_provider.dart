// lib/presentation/providers/registro_vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/registro_vuelo_repository_impl.dart';
import '../../domain/model/registro_vuelo.dart';

final registrosVueloProvider = FutureProvider.autoDispose<PaginatedRegistrosVuelo>(
  (ref) => ref.watch(registroVueloRepositoryProvider).getRegistrosVuelo(),
);

final registroVueloDetalleProvider =
    FutureProvider.autoDispose.family<RegistroVuelo, int>(
  (ref, id) => ref.watch(registroVueloRepositoryProvider).getRegistroVuelo(id),
);