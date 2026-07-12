import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/ruta_repository_impl.dart';
import '../../domain/model/ruta.dart';

final rutasProvider = FutureProvider.autoDispose<List<Ruta>>((ref) =>
    ref.watch(rutaRepositoryProvider).getRutas());

final rutaDetalleProvider = FutureProvider.autoDispose.family<Ruta, int>((ref, id) =>
    ref.watch(rutaRepositoryProvider).getRuta(id));
