// lib/presentation/providers/clima_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/clima_repository_impl.dart';
import '../../domain/model/clima.dart';

final climasProvider = FutureProvider.autoDispose<List<Clima>>((ref) =>
  ref.watch(climaRepositoryProvider).getClimas());

final climaDetalleProvider = FutureProvider.autoDispose.family<Clima, int>((ref, id) =>
  ref.watch(climaRepositoryProvider).getClima(id));
