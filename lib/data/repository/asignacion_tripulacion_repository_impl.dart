import '../remote/api/asignacion_tripulacion_remote_datasource.dart';
import '../../domain/model/asignacion_tripulacion.dart';

class AsignacionTripulacionRepository {
  final AsignacionTripulacionRemoteDatasource _datasource;

  AsignacionTripulacionRepository(this._datasource);

  Future<List<AsignacionTripulacion>> obtenerAsignaciones() => 
      _datasource.getAsignaciones();
}