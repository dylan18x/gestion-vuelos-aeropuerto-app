<<<<<<< HEAD
import '../remote/api/torre_control_remote_datasource.dart';
import '../../domain/model/torre_control.dart';

class TorreControlRepository {
  final TorreControlRemoteDatasource _datasource;
  TorreControlRepository(this._datasource);

  Future<List<TorreControl>> obtenerTorres() => _datasource.getTorres();
}
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/torre_control.dart';
import '../../domain/repository/torre_control_repository.dart';
import '../remote/api/torre_control_remote_datasource.dart';

class TorreControlRepositoryImpl implements TorreControlRepository {
  final TorreControlRemoteDatasource _datasource;
  TorreControlRepositoryImpl(this._datasource);

  @override
  Future<List<TorreControl>> getAllTorresControl() => _datasource.getTorres();

  @override
  Future<TorreControl> getTorreControlById(int id) => _datasource.getTorre(id);

  @override
  Future<void> createTorreControl(TorreControl torre) => _datasource.createTorre(torre.toJson());

  @override
  Future<void> updateTorreControl(TorreControl torre) => _datasource.updateTorre(torre.idTorre, torre.toJson());

  @override
  Future<void> deleteTorreControl(int id) => _datasource.deleteTorre(id);
}

final torreControlRepositoryProvider = Provider<TorreControlRepository>((ref) {
  return TorreControlRepositoryImpl(ref.watch(torreControlDatasourceProvider));
});
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
