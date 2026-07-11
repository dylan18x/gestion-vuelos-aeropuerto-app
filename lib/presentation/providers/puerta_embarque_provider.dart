// lib/presentation/providers/puerta_embarque_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/puerta_embarque_repository_impl.dart';
import '../../domain/model/puerta_embarque.dart';

final puertasProvider = FutureProvider.autoDispose<List<PuertaEmbarque>>((ref) =>
  ref.watch(puertaEmbarqueRepositoryProvider).getPuertas());

final puertaDetalleProvider = FutureProvider.autoDispose.family<PuertaEmbarque, int>((ref, id) =>
  ref.watch(puertaEmbarqueRepositoryProvider).getPuerta(id));
