// lib/presentation/providers/empleado_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/empleado_repository_impl.dart';
import '../../domain/model/empleado.dart';

final empleadosProvider = FutureProvider.autoDispose<PaginatedEmpleados>(
  (ref) => ref.watch(empleadoRepositoryProvider).getEmpleados(),
);

final empleadoDetalleProvider =
    FutureProvider.autoDispose.family<Empleado, int>(
  (ref, id) => ref.watch(empleadoRepositoryProvider).getEmpleado(id),
);