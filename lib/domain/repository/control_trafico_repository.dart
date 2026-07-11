// lib/domain/repository/control_trafico_repository.dart
import '../model/control_trafico.dart';

abstract class ControlTraficoRepository {
  Future<PaginatedControlesTrafico> getControlesTrafico({int? idVuelo});
  Future<ControlTrafico> getControlTrafico(int id);
  Future<ControlTrafico> createControlTrafico(Map<String, dynamic> payload);
  Future<ControlTrafico> updateControlTrafico(int id, Map<String, dynamic> payload);
  Future<void> deleteControlTrafico(int id);
}