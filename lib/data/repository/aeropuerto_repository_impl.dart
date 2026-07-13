// lib/data/repository/aeropuerto_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/aeropuerto.dart';
import '../../domain/repository/aeropuerto_repository.dart';
import '../remote/api/aeropuerto_remote_datasource.dart';

class AeropuertoRepositoryImpl implements AeropuertoRepository {
  final AeropuertoRemoteDatasource _ds;
  AeropuertoRepositoryImpl(this._ds);

  @override Future<List<Aeropuerto>> getAeropuertos() => _ds.getAeropuertos();
  @override Future<Aeropuerto> getAeropuerto(int id) => _ds.getAeropuerto(id);
  @override Future<Aeropuerto> createAeropuerto(Map<String, dynamic> p) => _ds.createAeropuerto(p);
  @override Future<Aeropuerto> updateAeropuerto(int id, Map<String, dynamic> p) => _ds.updateAeropuerto(id, p);
  @override Future<void> deleteAeropuerto(int id) => _ds.deleteAeropuerto(id);
}

final aeropuertoRepositoryProvider = Provider<AeropuertoRepository>((ref) =>
  AeropuertoRepositoryImpl(ref.watch(aeropuertoDatasourceProvider)));
