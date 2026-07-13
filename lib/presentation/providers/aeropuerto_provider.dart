// lib/presentation/providers/aeropuerto_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/aeropuerto_repository_impl.dart';
import '../../domain/model/aeropuerto.dart';

final aeropuertosProvider = FutureProvider.autoDispose<List<Aeropuerto>>((ref) =>
  ref.watch(aeropuertoRepositoryProvider).getAeropuertos());

final aeropuertoDetalleProvider = FutureProvider.autoDispose.family<Aeropuerto, int>((ref, id) =>
  ref.watch(aeropuertoRepositoryProvider).getAeropuerto(id));
