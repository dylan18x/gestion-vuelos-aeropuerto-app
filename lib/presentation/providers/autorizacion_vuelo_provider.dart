<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/autorizacion_vuelo_repository.dart';
import '../../data/repository/autorizacion_vuelo_repository_impl.dart';
import '../../data/remote/api/autorizacion_vuelo_remote_datasource.dart';
import '../../core/dio_provider.dart'; 

final autorizacionesVueloProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  
  final datasource = AutorizacionVueloRemoteDatasource(dio);
  
  final repository = AutorizacionVueloRepositoryImpl(datasource);
  
  return await repository.getAutorizaciones();
});
=======
// lib/presentation/providers/autorizacion_vuelo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/autorizacion_vuelo_repository_impl.dart';
import '../../domain/model/autorizacion_vuelo.dart';

final autorizacionesVueloProvider = FutureProvider.autoDispose<List<AutorizacionVuelo>>(
  (ref) => ref.watch(autorizacionVueloRepositoryProvider).getAllAutorizacionesVuelo(),
);

final autorizacionVueloDetalleProvider =
    FutureProvider.autoDispose.family<AutorizacionVuelo, int>(
  (ref, id) => ref.watch(autorizacionVueloRepositoryProvider).getAutorizacionVueloById(id),
);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
