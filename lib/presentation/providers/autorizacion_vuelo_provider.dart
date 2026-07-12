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