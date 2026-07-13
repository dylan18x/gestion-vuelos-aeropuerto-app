// lib/presentation/providers/mantenimiento_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/mantenimiento_repository_impl.dart';
import '../../domain/model/mantenimiento.dart';

final mantenimientosProvider = FutureProvider.autoDispose<List<Mantenimiento>>((ref) =>
  ref.watch(mantenimientoRepositoryProvider).getMantenimientos());

final mantenimientoDetalleProvider = FutureProvider.autoDispose.family<Mantenimiento, int>((ref, id) =>
  ref.watch(mantenimientoRepositoryProvider).getMantenimiento(id));
