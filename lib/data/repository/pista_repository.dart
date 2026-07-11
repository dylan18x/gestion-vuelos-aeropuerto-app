import '../remote/api/pista_remote_datasource.dart';
import '../../domain/model/pista.dart';

class PistaRepository {
  final PistaRemoteDatasource _datasource;
  PistaRepository(this._datasource);

  Future<List<Pista>> obtenerPistas() async {
    return await _datasource.getPistas();
  }
}