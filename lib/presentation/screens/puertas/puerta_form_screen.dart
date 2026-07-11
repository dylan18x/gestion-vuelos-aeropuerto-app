// lib/presentation/screens/puertas/puerta_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/puerta_embarque_repository_impl.dart';
import '../../providers/puerta_embarque_provider.dart';
import '../../providers/auth_provider.dart';

class PuertaFormScreen extends ConsumerStatefulWidget {
  final int? id;
  const PuertaFormScreen({super.key, this.id});

  @override
  ConsumerState<PuertaFormScreen> createState() => _PuertaFormScreenState();
}

class _PuertaFormScreenState extends ConsumerState<PuertaFormScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _numeroCtrl    = TextEditingController();
  final _terminalCtrl  = TextEditingController();
  bool _loading        = false;
  bool _initialized    = false;

  bool get _isEdit => widget.id != null;

  @override
  void dispose() {
    _numeroCtrl.dispose();
    _terminalCtrl.dispose();
    super.dispose();
  }

  void _initFromDetail(AsyncValue<dynamic> d) {
    if (_initialized) return;
    d.whenData((p) {
      _numeroCtrl.text   = p.numero;
      _terminalCtrl.text = p.idTerminal.toString();
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
      'numero':      _numeroCtrl.text.trim(),
      'id_terminal': int.parse(_terminalCtrl.text.trim()),
    };
    try {
      final repo = ref.read(puertaEmbarqueRepositoryProvider);
      if (_isEdit) {
        await repo.updatePuerta(widget.id!, payload);
      } else {
        await repo.createPuerta(payload);
      }
      ref.invalidate(puertasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Puerta actualizada' : 'Puerta creada'),
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
      detailAsync = ref.watch(puertaDetalleProvider(widget.id!));
      _initFromDetail(detailAsync!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Editar Puerta' : 'Nueva Puerta')),
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
                      labelText: 'Número de Puerta',
                      prefixIcon: Icon(Icons.door_sliding_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _terminalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID Terminal',
                      prefixIcon: Icon(Icons.apartment_rounded),
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
