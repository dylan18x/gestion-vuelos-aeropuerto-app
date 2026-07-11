// lib/presentation/screens/aeropuertos/aeropuerto_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/aeropuerto_repository_impl.dart';
import '../../providers/aeropuerto_provider.dart';
import '../../providers/auth_provider.dart';

class AeropuertoFormScreen extends ConsumerStatefulWidget {
  final int? id;
  const AeropuertoFormScreen({super.key, this.id});

  @override
  ConsumerState<AeropuertoFormScreen> createState() => _AeropuertoFormScreenState();
}

class _AeropuertoFormScreenState extends ConsumerState<AeropuertoFormScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _nombreCtrl  = TextEditingController();
  final _ciudadCtrl  = TextEditingController();
  final _paisCtrl    = TextEditingController();
  final _iataCtrl    = TextEditingController();
  bool _loading      = false;
  bool _initialized  = false;

  bool get _isEdit => widget.id != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _ciudadCtrl.dispose();
    _paisCtrl.dispose();
    _iataCtrl.dispose();
    super.dispose();
  }

  void _initFromDetail(AsyncValue<dynamic> detailAsync) {
    if (_initialized) return;
    detailAsync.whenData((a) {
      _nombreCtrl.text = a.nombre;
      _ciudadCtrl.text = a.ciudad;
      _paisCtrl.text   = a.pais;
      _iataCtrl.text   = a.codigoIata;
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
      'nombre':      _nombreCtrl.text.trim(),
      'ciudad':      _ciudadCtrl.text.trim(),
      'pais':        _paisCtrl.text.trim(),
      'codigo_iata': _iataCtrl.text.trim().toUpperCase(),
    };
    try {
      final repo = ref.read(aeropuertoRepositoryProvider);
      if (_isEdit) {
        await repo.updateAeropuerto(widget.id!, payload);
      } else {
        await repo.createAeropuerto(payload);
      }
      ref.invalidate(aeropuertosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Aeropuerto actualizado' : 'Aeropuerto creado'),
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
      detailAsync = ref.watch(aeropuertoDetalleProvider(widget.id!));
      _initFromDetail(detailAsync!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Editar Aeropuerto' : 'Nuevo Aeropuerto')),
      body: _isEdit && detailAsync!.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _field('Nombre', _nombreCtrl, Icons.location_city_rounded),
                  const SizedBox(height: 14),
                  _field('Ciudad', _ciudadCtrl, Icons.location_on_rounded),
                  const SizedBox(height: 14),
                  _field('País', _paisCtrl, Icons.public_rounded),
                  const SizedBox(height: 14),
                  _field('Código IATA', _iataCtrl, Icons.confirmation_number_rounded,
                    hint: 'Ej: GYE', maxLength: 3),
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

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {String? hint, int? maxLength}) =>
    TextFormField(
      controller: ctrl,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        counterText: '',
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
    );
}
