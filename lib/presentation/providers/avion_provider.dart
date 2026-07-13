// lib/presentation/providers/avion_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/avion_repository_impl.dart';
import '../../domain/model/avion.dart';

final avionesProvider = FutureProvider.autoDispose<List<Avion>>((ref) =>
  ref.watch(avionRepositoryProvider).getAviones());

final avionDetalleProvider = FutureProvider.autoDispose.family<Avion, int>((ref, id) =>
  ref.watch(avionRepositoryProvider).getAvion(id));
