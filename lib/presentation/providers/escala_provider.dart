// lib/presentation/providers/escala_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/escala_repository_impl.dart';
import '../../domain/model/escala.dart';

final escalasByVueloProvider = FutureProvider.autoDispose.family<List<Escala>, int>(
  (ref, idVuelo) => ref.watch(escalaRepositoryProvider).getEscalasByVuelo(idVuelo),
);