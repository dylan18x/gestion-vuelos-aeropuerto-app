<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repository/asignacion_pista_repository.dart';
import '../../../data/repository/asignacion_pista_repository_impl.dart';
import '../../../data/remote/api/asignacion_pista_remote_datasource.dart';

final asignacionPistaDatasourceProvider = Provider<AsignacionPistaRemoteDatasource>((ref) {
  // Asegúrate de que 'dioProvider' esté exportado desde tu archivo de configuración de Dio
  final dio = ref.watch(dioProvider); 
  return AsignacionPistaRemoteDatasource(dio);
});

final asignacionPistaRepositoryProvider = Provider<AsignacionPistaRepository>((ref) {
  return AsignacionPistaRepositoryImpl(ref.watch(asignacionPistaDatasourceProvider));
});

final asignacionesPistaProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(asignacionPistaRepositoryProvider);
  return await repository.getAsignacionesPista(); // Este es el método que definimos antes
});
=======
// lib/presentation/providers/asignacion_pista_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/asignacion_pista_repository_impl.dart';
import '../../domain/model/asignacion_pista.dart';

final asignacionesPistaProvider = FutureProvider.autoDispose<List<AsignacionPista>>(
  (ref) => ref.watch(asignacionPistaRepositoryProvider).getAllAsignacionesPista(),
);

final asignacionPistaDetalleProvider =
    FutureProvider.autoDispose.family<AsignacionPista, int>(
  (ref, id) => ref.watch(asignacionPistaRepositoryProvider).getAsignacionPistaById(id),
);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
