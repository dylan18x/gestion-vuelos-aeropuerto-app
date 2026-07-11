// lib/presentation/providers/aerolinea_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/aerolinea_repository_impl.dart';
import '../../domain/model/aerolinea.dart';

final aerolineasProvider = FutureProvider.autoDispose<List<Aerolinea>>((ref) =>
  ref.watch(aerolineaRepositoryProvider).getAerolineas());

final aerolineaDetalleProvider = FutureProvider.autoDispose.family<Aerolinea, int>((ref, id) =>
  ref.watch(aerolineaRepositoryProvider).getAerolinea(id));
