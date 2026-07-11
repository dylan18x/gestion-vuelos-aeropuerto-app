// lib/presentation/providers/tipo_avion_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/tipo_avion_repository_impl.dart';
import '../../domain/model/tipo_avion.dart';

final tiposAvionProvider = FutureProvider.autoDispose<List<TipoAvion>>((ref) =>
  ref.watch(tipoAvionRepositoryProvider).getTiposAvion());

final tipoAvionDetalleProvider = FutureProvider.autoDispose.family<TipoAvion, int>((ref, id) =>
  ref.watch(tipoAvionRepositoryProvider).getTipoAvion(id));
