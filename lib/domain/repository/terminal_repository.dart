// lib/domain/repository/terminal_repository.dart
import '../model/terminal.dart';

abstract class TerminalRepository {
  Future<List<Terminal>> getTerminales();
  Future<Terminal> getTerminal(int id);
  Future<Terminal> createTerminal(Map<String, dynamic> payload);
  Future<Terminal> updateTerminal(int id, Map<String, dynamic> payload);
  Future<void> deleteTerminal(int id);
}
