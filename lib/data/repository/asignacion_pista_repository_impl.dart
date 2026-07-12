import '../remote/api/asignacion_pista_remote_datasource.dart';
import '../../domain/model/asignacion_pista.dart';

class AsignacionPistaRepository {
  final AsignacionPistaRemoteDatasource _datasource;
  AsignacionPistaRepository(this._datasource);

  Future<List<AsignacionPista>> obtenerAsignacionesPista() async {
    return await _datasource.getAsignacionesPista();
  }
}