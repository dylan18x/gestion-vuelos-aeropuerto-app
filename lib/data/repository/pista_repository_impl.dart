<<<<<<< HEAD
import '../remote/api/pista_remote_datasource.dart';
import '../../domain/model/pista.dart';

class PistaRepository {
  final PistaRemoteDatasource _datasource;
  PistaRepository(this._datasource);

  Future<List<Pista>> obtenerPistas() async {
    return await _datasource.getPistas();
  }
}
=======
// lib/data/repository/pista_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/pista.dart';
import '../../domain/repository/pista_repository.dart';
import '../remote/api/pista_remote_datasource.dart';

class PistaRepositoryImpl implements PistaRepository {
  final PistaRemoteDatasource _datasource;
  PistaRepositoryImpl(this._datasource);

  @override
  Future<List<Pista>> getAllPistas() => _datasource.getPistas();

  @override
  Future<Pista> getPistaById(int id) => _datasource.getPista(id);

  @override
  Future<void> createPista(Pista pista) {
    // No mandamos id_pista al crear: el backend lo asigna.
    final payload = pista.toJson()..remove('id_pista');
    return _datasource.createPista(payload);
  }

  @override
  Future<void> updatePista(Pista pista) => _datasource.updatePista(pista.idPista, pista.toJson());

  @override
  Future<void> deletePista(int id) => _datasource.deletePista(id);
}

final pistaRepositoryProvider = Provider<PistaRepository>((ref) {
  return PistaRepositoryImpl(ref.watch(pistaDatasourceProvider));
});
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
