import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/torre_control_repository_impl.dart';
import '../../../domain/model/torre_control.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/torre_control_provider.dart';

class TorreControlFormScreen extends ConsumerStatefulWidget {
  final int? id;
  const TorreControlFormScreen({super.key, this.id});

  @override
  ConsumerState<TorreControlFormScreen> createState() => _TorreControlFormScreenState();
}

class _TorreControlFormScreenState extends ConsumerState<TorreControlFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _frecuenciaCtrl = TextEditingController();
  final _idAeropuertoCtrl = TextEditingController();
  bool _loading = false;
  bool _initialized = false;

  bool get _isEdit => widget.id != null;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _frecuenciaCtrl.dispose();
    _idAeropuertoCtrl.dispose();
    super.dispose();
  }

  void _initFromDetail(AsyncValue<dynamic> detailAsync) {
    if (_initialized) return;
    detailAsync.whenData((torre) {
      _nombreCtrl.text = torre.nombre;
      _frecuenciaCtrl.text = torre.frecuencia;
      _idAeropuertoCtrl.text = torre.idAeropuerto.toString();
      _initialized = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!ref.read(authProvider).isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sin permisos'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _loading = true);
    final torre = TorreControl(
      idTorre: _isEdit ? widget.id! : 0,
      nombre: _nombreCtrl.text.trim(),
      frecuencia: _frecuenciaCtrl.text.trim(),
      idAeropuerto: int.parse(_idAeropuertoCtrl.text.trim()),
    );

    try {
      final repo = ref.read(torreControlRepositoryProvider);
      if (_isEdit) {
        await repo.updateTorreControl(torre);
      } else {
        await repo.createTorreControl(torre);
      }
      ref.invalidate(torresControlProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Torre actualizada' : 'Torre creada'),
          backgroundColor: AppColors.success,
        ));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<dynamic>? detailAsync;
    if (_isEdit) {
      detailAsync = ref.watch(torreControlDetalleProvider(widget.id!));
      _initFromDetail(detailAsync!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEdit ? 'Editar Torre de Control' : 'Nueva Torre de Control')),
      body: _isEdit && detailAsync!.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field('Nombre', _nombreCtrl, Icons.flight_rounded),
                    const SizedBox(height: 14),
                    _field('Frecuencia (ej: 118.1)', _frecuenciaCtrl, Icons.radio_rounded),
                    const SizedBox(height: 14),
                    _field(
                      'ID Aeropuerto',
                      _idAeropuertoCtrl,
                      Icons.location_on_rounded,
                      isNum: true,
                      hint: 'Revisa el listado de Aeropuertos para el ID correcto',
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
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
      {bool isNum = false, String? hint}) => TextFormField(
        controller: ctrl,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          hintText: hint,
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Campo requerido';
          if (isNum && int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
          return null;
        },
      );
}