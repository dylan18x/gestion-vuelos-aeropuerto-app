// lib/presentation/providers/control_trafico_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/control_trafico_repository_impl.dart';
import '../../domain/model/control_trafico.dart';

final controlesTraficoProvider = FutureProvider.autoDispose<PaginatedControlesTrafico>(
  (ref) => ref.watch(controlTraficoRepositoryProvider).getControlesTrafico(),
);

final controlTraficoDetalleProvider =
    FutureProvider.autoDispose.family<ControlTrafico, int>(
  (ref, id) => ref.watch(controlTraficoRepositoryProvider).getControlTrafico(id),
);