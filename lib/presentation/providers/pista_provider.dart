<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/pista_repository.dart';
import '../../data/repository/pista_repository_impl.dart';
import '../../data/remote/api/pista_remote_datasource.dart';
import '../../core/dio_provider.dart'; 

final pistasProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  
  final datasource = PistaRemoteDatasource(dio);
  
  final repository = PistaRepositoryImpl(datasource);
  
  return await repository.getPistas();
});
=======
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
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
