// lib/presentation/providers/terminal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/terminal_repository_impl.dart';
import '../../domain/model/terminal.dart';

final terminalesProvider = FutureProvider.autoDispose<List<Terminal>>((ref) =>
  ref.watch(terminalRepositoryProvider).getTerminales());

final terminalDetalleProvider = FutureProvider.autoDispose.family<Terminal, int>((ref, id) =>
  ref.watch(terminalRepositoryProvider).getTerminal(id));
