// lib/presentation/providers/estado_vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/estado_vuelo_repository_impl.dart';
import '../../domain/model/estado_vuelo.dart';

final estadoVuelosProvider = FutureProvider.autoDispose<List<EstadoVuelo>>((ref) =>
  ref.watch(estadoVueloRepositoryProvider).getEstadoVuelos());

final estadoVueloDetalleProvider = FutureProvider.autoDispose.family<EstadoVuelo, int>((ref, id) =>
  ref.watch(estadoVueloRepositoryProvider).getEstadoVuelo(id));
