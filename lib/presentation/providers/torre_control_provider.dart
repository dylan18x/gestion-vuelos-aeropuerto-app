import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
import '../../domain/repository/torre_control_repository.dart';
import '../../data/repository/torre_control_repository_impl.dart';
import '../../data/remote/api/torre_control_remote_datasource.dart';
import '../../core/dio_provider.dart'; 

final torresControlProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  
  final datasource = TorreControlRemoteDatasource(dio);
  
  final repository = TorreControlRepositoryImpl(datasource);
  
  return await repository.getTorres();
=======
import '../../data/repository/torre_control_repository_impl.dart';
import '../../domain/model/torre_control.dart';

final torresControlProvider = FutureProvider.autoDispose<List<TorreControl>>((ref) {
  final repository = ref.watch(torreControlRepositoryProvider);
  return repository.getAllTorresControl();
});

final torreControlDetalleProvider = FutureProvider.autoDispose.family<TorreControl, int>((ref, id) {
  final repository = ref.watch(torreControlRepositoryProvider);
  return repository.getTorreControlById(id);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
});