import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/tripulacion_repository_impl.dart';
import '../../domain/model/tripulacion.dart';

final tripulacionesProvider = FutureProvider.autoDispose<List<Tripulacion>>((ref) =>
    ref.watch(tripulacionRepositoryProvider).getTripulacion());

final tripulacionDetalleProvider = FutureProvider.autoDispose.family<Tripulacion, int>((ref, id) =>
    ref.watch(tripulacionRepositoryProvider).getTripulante(id));
