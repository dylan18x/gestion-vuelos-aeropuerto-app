// lib/presentation/providers/piloto_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/piloto_repository_impl.dart';
import '../../domain/model/piloto.dart';

final pilotosProvider = FutureProvider.autoDispose<List<Piloto>>(
  (ref) => ref.watch(pilotoRepositoryProvider).getPilotos(),
);

final pilotoDetalleProvider =
    FutureProvider.autoDispose.family<Piloto, int>(
  (ref, id) => ref.watch(pilotoRepositoryProvider).getPiloto(id),
);