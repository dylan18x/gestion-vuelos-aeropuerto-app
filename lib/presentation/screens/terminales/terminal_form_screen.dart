// lib/presentation/screens/terminales/terminal_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/terminal_repository_impl.dart';
import '../../providers/terminal_provider.dart';
import '../../providers/auth_provider.dart';

class TerminalFormScreen extends ConsumerStatefulWidget {
  final int? id;
  const TerminalFormScreen({super.key, this.id});

  @override
  ConsumerState<TerminalFormScreen> createState() => _TerminalFormScreenState();
}

class _TerminalFormScreenState extends ConsumerState<TerminalFormScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _numeroCtrl   = TextEditingController();
  final _aeropuertoCtrl = TextEditingController();
  bool _loading       = false;
  bool _initialized   = false;

  bool get _isEdit => widget.id != null;

  @override
  void dispose() {
    _numeroCtrl.dispose();
    _aeropuertoCtrl.dispose();
    super.dispose();
  }

  void _initFromDetail(AsyncValue<dynamic> detailAsync) {
    if (_initialized) return;
    detailAsync.whenData((t) {
      _numeroCtrl.text     = t.numero;
      _aeropuertoCtrl.text = t.idAeropuerto.toString();
      _initialized = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!ref.read(authProvider).isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sin permisos'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _loading = true);
    final payload = {
      'numero':        _numeroCtrl.text.trim(),
      'id_aeropuerto': int.parse(_aeropuertoCtrl.text.trim()),
    };
    try {
      final repo = ref.read(terminalRepositoryProvider);
      if (_isEdit) {
        await repo.updateTerminal(widget.id!, payload);
      } else {
        await repo.createTerminal(payload);
      }
      ref.invalidate(terminalesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Terminal actualizada' : 'Terminal creada'),
          backgroundColor: AppColors.success,
        ));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<dynamic>? detailAsync;
    if (_isEdit) {
      detailAsync = ref.watch(terminalDetalleProvider(widget.id!));
      _initFromDetail(detailAsync!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Editar Terminal' : 'Nueva Terminal')),
      body: _isEdit && detailAsync!.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _numeroCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.apartment_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _aeropuertoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID Aeropuerto',
                      prefixIcon: Icon(Icons.location_city_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Campo requerido';
                      if (int.tryParse(v.trim()) == null) return 'Debe ser un número';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                        ? const SizedBox(height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(_isEdit ? 'Actualizar' : 'Crear'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
