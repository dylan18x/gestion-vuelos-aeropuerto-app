import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/torre_control_repository_impl.dart';
import '../../domain/model/torre_control.dart';

final torresControlProvider = FutureProvider.autoDispose<List<TorreControl>>((ref) {
  final repository = ref.watch(torreControlRepositoryProvider);
  return repository.getAllTorresControl();
});

final torreControlDetalleProvider = FutureProvider.autoDispose.family<TorreControl, int>((ref, id) {
  final repository = ref.watch(torreControlRepositoryProvider);
  return repository.getTorreControlById(id);
});