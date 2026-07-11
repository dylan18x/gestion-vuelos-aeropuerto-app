import '../remote/api/autorizacion_vuelo_remote_datasource.dart';
import '../../domain/model/autorizacion_vuelo.dart';

class AutorizacionVueloRepository {
  final AutorizacionVueloRemoteDatasource _datasource;
  AutorizacionVueloRepository(this._datasource);

  Future<List<AutorizacionVuelo>> obtenerAutorizaciones() => _datasource.getAutorizaciones();
}