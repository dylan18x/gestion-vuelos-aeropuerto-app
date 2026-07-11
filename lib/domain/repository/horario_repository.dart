// lib/domain/repository/horario_repository.dart
import '../model/horario.dart';

abstract class HorarioRepository {
  Future<Horario> getHorarioByVuelo(int idVuelo);
  Future<Horario> createHorario(Map<String, dynamic> payload);
  Future<Horario> updateHorario(int id, Map<String, dynamic> payload);
  Future<void>     deleteHorario(int id);
}