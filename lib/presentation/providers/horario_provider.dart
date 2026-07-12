// lib/presentation/providers/horario_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/horario_repository_impl.dart';
import '../../domain/model/horario.dart';

final horarioByVueloProvider = FutureProvider.autoDispose.family<Horario?, int>(
  (ref, idVuelo) => ref.watch(horarioRepositoryProvider).getHorarioByVuelo(idVuelo),
);