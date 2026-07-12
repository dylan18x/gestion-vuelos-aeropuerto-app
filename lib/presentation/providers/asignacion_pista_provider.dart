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