import '../remote/api/torre_control_remote_datasource.dart';
import '../../domain/model/torre_control.dart';

class TorreControlRepository {
  final TorreControlRemoteDatasource _datasource;
  TorreControlRepository(this._datasource);

  Future<List<TorreControl>> obtenerTorres() => _datasource.getTorres();
}