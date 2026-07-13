// lib/data/repository/terminal_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/terminal.dart';
import '../../domain/repository/terminal_repository.dart';
import '../remote/api/terminal_remote_datasource.dart';

class TerminalRepositoryImpl implements TerminalRepository {
  final TerminalRemoteDatasource _ds;
  TerminalRepositoryImpl(this._ds);

  @override Future<List<Terminal>> getTerminales() => _ds.getTerminales();
  @override Future<Terminal> getTerminal(int id) => _ds.getTerminal(id);
  @override Future<Terminal> createTerminal(Map<String, dynamic> p) => _ds.createTerminal(p);
  @override Future<Terminal> updateTerminal(int id, Map<String, dynamic> p) => _ds.updateTerminal(id, p);
  @override Future<void> deleteTerminal(int id) => _ds.deleteTerminal(id);
}

final terminalRepositoryProvider = Provider<TerminalRepository>((ref) =>
  TerminalRepositoryImpl(ref.watch(terminalDatasourceProvider)));
