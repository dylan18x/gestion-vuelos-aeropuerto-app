// lib/presentation/providers/pista_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/pista_repository_impl.dart';
import '../../domain/model/pista.dart';

final pistasProvider = FutureProvider.autoDispose<List<Pista>>(
  (ref) => ref.watch(pistaRepositoryProvider).getAllPistas(),
);

final pistaDetalleProvider =
    FutureProvider.autoDispose.family<Pista, int>(
  (ref, id) => ref.watch(pistaRepositoryProvider).getPistaById(id),
);