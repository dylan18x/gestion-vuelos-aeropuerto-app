// lib/data/repository/empleado_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/empleado.dart';
import '../../domain/repository/empleado_repository.dart';
import '../remote/api/empleado_remote_datasource.dart';

class EmpleadoRepositoryImpl implements EmpleadoRepository {
  final EmpleadoRemoteDatasource _datasource;
  EmpleadoRepositoryImpl(this._datasource);

  @override
  Future<PaginatedEmpleados> getEmpleados({String? cargo}) =>
      _datasource.getEmpleados(cargo: cargo);

  @override
  Future<Empleado> getEmpleado(int id) => _datasource.getEmpleado(id);

  @override
  Future<Empleado> createEmpleado(Map<String, dynamic> payload) =>
      _datasource.createEmpleado(payload);

  @override
  Future<Empleado> updateEmpleado(int id, Map<String, dynamic> payload) =>
      _datasource.updateEmpleado(id, payload);

  @override
  Future<void> deleteEmpleado(int id) => _datasource.deleteEmpleado(id);
}

final empleadoRepositoryProvider = Provider<EmpleadoRepository>((ref) {
  return EmpleadoRepositoryImpl(ref.watch(empleadoDatasourceProvider));
});