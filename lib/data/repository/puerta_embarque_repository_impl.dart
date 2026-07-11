// lib/data/repository/puerta_embarque_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/puerta_embarque.dart';
import '../../domain/repository/puerta_embarque_repository.dart';
import '../remote/api/puerta_embarque_remote_datasource.dart';

class PuertaEmbarqueRepositoryImpl implements PuertaEmbarqueRepository {
  final PuertaEmbarqueRemoteDatasource _ds;
  PuertaEmbarqueRepositoryImpl(this._ds);

  @override Future<List<PuertaEmbarque>> getPuertas() => _ds.getPuertas();
  @override Future<PuertaEmbarque> getPuerta(int id) => _ds.getPuerta(id);
  @override Future<PuertaEmbarque> createPuerta(Map<String, dynamic> p) => _ds.createPuerta(p);
  @override Future<PuertaEmbarque> updatePuerta(int id, Map<String, dynamic> p) => _ds.updatePuerta(id, p);
  @override Future<void> deletePuerta(int id) => _ds.deletePuerta(id);
}

final puertaEmbarqueRepositoryProvider = Provider<PuertaEmbarqueRepository>((ref) =>
  PuertaEmbarqueRepositoryImpl(ref.watch(puertaEmbarqueDatasourceProvider)));
