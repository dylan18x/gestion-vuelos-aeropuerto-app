// lib/presentation/screens/aerolineas/aerolinea_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/aerolinea_repository_impl.dart';
import '../../providers/aerolinea_provider.dart';
import '../../providers/auth_provider.dart';

class AerolineaFormScreen extends ConsumerStatefulWidget {
  final int? id;
  const AerolineaFormScreen({super.key, this.id});

  @override
  ConsumerState<AerolineaFormScreen> createState() => _AerolineaFormScreenState();
}

class _AerolineaFormScreenState extends ConsumerState<AerolineaFormScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _paisCtrl   = TextEditingController();
  bool _loading     = false;
  bool _initialized = false;

  bool get _isEdit => widget.id != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _paisCtrl.dispose();
    super.dispose();
  }

  void _initFromDetail(AsyncValue<dynamic> d) {
    if (_initialized) return;
    d.whenData((a) {
      _nombreCtrl.text = a.nombre;
      _paisCtrl.text   = a.pais;
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
      'nombre': _nombreCtrl.text.trim(),
      'pais':   _paisCtrl.text.trim(),
    };
    try {
      final repo = ref.read(aerolineaRepositoryProvider);
      if (_isEdit) {
        await repo.updateAerolinea(widget.id!, payload);
      } else {
        await repo.createAerolinea(payload);
      }
      ref.invalidate(aerolineasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Aerolínea actualizada' : 'Aerolínea creada'),
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
      detailAsync = ref.watch(aerolineaDetalleProvider(widget.id!));
      _initFromDetail(detailAsync!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Editar Aerolínea' : 'Nueva Aerolínea')),
      body: _isEdit && detailAsync!.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.airlines_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _paisCtrl,
                    decoration: const InputDecoration(
                      labelText: 'País',
                      prefixIcon: Icon(Icons.public_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
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
