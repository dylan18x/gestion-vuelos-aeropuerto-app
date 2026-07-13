<<<<<<< HEAD
import '../remote/api/autorizacion_vuelo_remote_datasource.dart';
import '../../domain/model/autorizacion_vuelo.dart';

class AutorizacionVueloRepository {
  final AutorizacionVueloRemoteDatasource _datasource;
  AutorizacionVueloRepository(this._datasource);

  Future<List<AutorizacionVuelo>> obtenerAutorizaciones() => _datasource.getAutorizaciones();
}
=======
// lib/data/repository/autorizacion_vuelo_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/autorizacion_vuelo.dart';
import '../../domain/repository/autorizacion_vuelo_repository.dart';
import '../remote/api/autorizacion_vuelo_remote_datasource.dart';

class AutorizacionVueloRepositoryImpl implements AutorizacionVueloRepository {
  final AutorizacionVueloRemoteDatasource _datasource;
  AutorizacionVueloRepositoryImpl(this._datasource);

  @override
  Future<List<AutorizacionVuelo>> getAllAutorizacionesVuelo() => _datasource.getAutorizaciones();

  @override
  Future<AutorizacionVuelo> getAutorizacionVueloById(int id) => _datasource.getAutorizacion(id);

  @override
  Future<void> createAutorizacionVuelo(AutorizacionVuelo autorizacion) {
    final payload = autorizacion.toJson()..remove('id_autorizacion');
    return _datasource.createAutorizacion(payload);
  }

  @override
  Future<void> updateAutorizacionVuelo(AutorizacionVuelo autorizacion) =>
      _datasource.updateAutorizacion(autorizacion.idAutorizacion, autorizacion.toJson());

  @override
  Future<void> deleteAutorizacionVuelo(int id) => _datasource.deleteAutorizacion(id);
}

final autorizacionVueloRepositoryProvider = Provider<AutorizacionVueloRepository>((ref) {
  return AutorizacionVueloRepositoryImpl(ref.watch(autorizacionVueloDatasourceProvider));
});
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
