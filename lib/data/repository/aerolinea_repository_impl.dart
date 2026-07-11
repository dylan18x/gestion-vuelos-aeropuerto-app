// lib/data/repository/aerolinea_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/aerolinea.dart';
import '../../domain/repository/aerolinea_repository.dart';
import '../remote/api/aerolinea_remote_datasource.dart';

class AerolineaRepositoryImpl implements AerolineaRepository {
  final AerolineaRemoteDatasource _ds;
  AerolineaRepositoryImpl(this._ds);

  @override Future<List<Aerolinea>> getAerolineas() => _ds.getAerolineas();
  @override Future<Aerolinea> getAerolinea(int id) => _ds.getAerolinea(id);
  @override Future<Aerolinea> createAerolinea(Map<String, dynamic> p) => _ds.createAerolinea(p);
  @override Future<Aerolinea> updateAerolinea(int id, Map<String, dynamic> p) => _ds.updateAerolinea(id, p);
  @override Future<void> deleteAerolinea(int id) => _ds.deleteAerolinea(id);
}

final aerolineaRepositoryProvider = Provider<AerolineaRepository>((ref) =>
  AerolineaRepositoryImpl(ref.watch(aerolineaDatasourceProvider)));
