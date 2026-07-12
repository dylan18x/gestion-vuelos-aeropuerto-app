import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/torre_control_repository.dart';
import '../../data/repository/torre_control_repository_impl.dart';
import '../../data/remote/api/torre_control_remote_datasource.dart';
import '../../core/dio_provider.dart'; 

final torresControlProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  
  final datasource = TorreControlRemoteDatasource(dio);
  
  final repository = TorreControlRepositoryImpl(datasource);
  
  return await repository.getTorres();
});