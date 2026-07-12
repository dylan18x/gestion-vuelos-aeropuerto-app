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