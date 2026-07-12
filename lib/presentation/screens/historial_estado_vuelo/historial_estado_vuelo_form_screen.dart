// lib/presentation/screens/historial_estado_vuelo/historial_estado_vuelo_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/repository/historial_estado_vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/historial_estado_vuelo_provider.dart';

class HistorialEstadoVueloFormScreen extends ConsumerStatefulWidget {
  const HistorialEstadoVueloFormScreen({super.key});

  @override
  ConsumerState<HistorialEstadoVueloFormScreen> createState() =>
      _HistorialFormScreenState();
}

class _HistorialFormScreenState extends ConsumerState<HistorialEstadoVueloFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idVuelo = TextEditingController();
  final _fechaCambio = TextEditingController();
  final _observacion = TextEditingController();
  final _idEstado = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _idVuelo.dispose();
    _fechaCambio.dispose();
    _observacion.dispose();
    _idEstado.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _fechaCambio.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _submit() async {
    if (!ref.read(authProvider).isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para esta acción'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final payload = {
      'id_vuelo':     int.parse(_idVuelo.text.trim()),
      'fecha_cambio': _fechaCambio.text.trim(),
      'observacion':  _observacion.text.trim(),
      'id_estado':    int.parse(_idEstado.text.trim()),
    };

    try {
      final repo = ref.read(historialEstadoVueloRepositoryProvider);
      await repo.registrarCambioEstado(payload);
      // Refresca el listado GLOBAL (ya no el filtrado por un vuelo).
      ref.invalidate(allHistorialesEstadoVueloProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historial creado'), backgroundColor: AppColors.success),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nuevo historial')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_idVuelo, 'ID Vuelo', Icons.flight_rounded, isNum: true),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaCambio,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de cambio',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Fecha obligatoria' : null,
              ),
              const SizedBox(height: 16),
              _field(_idEstado, 'ID Estado', Icons.flag_rounded, isNum: true,
                  hint: 'ID correspondiente del estado del vuelo'),
              const SizedBox(height: 16),
              _field(_observacion, 'Observación', Icons.comment_rounded),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crear historial'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {String? hint, bool isNum = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), hintText: hint),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label es obligatorio';
        if (isNum && int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
        return null;
      },
    );
  }
}