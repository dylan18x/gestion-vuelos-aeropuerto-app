// lib/presentation/providers/autorizacion_vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/autorizacion_vuelo_repository_impl.dart';
import '../../domain/model/autorizacion_vuelo.dart';

final autorizacionesVueloProvider = FutureProvider.autoDispose<List<AutorizacionVuelo>>(
  (ref) => ref.watch(autorizacionVueloRepositoryProvider).getAllAutorizacionesVuelo(),
);

final autorizacionVueloDetalleProvider =
    FutureProvider.autoDispose.family<AutorizacionVuelo, int>(
  (ref, id) => ref.watch(autorizacionVueloRepositoryProvider).getAutorizacionVueloById(id),
);