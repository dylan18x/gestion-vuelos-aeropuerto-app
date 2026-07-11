// lib/presentation/screens/clima/clima_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/clima_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/clima.dart';
import '../../providers/clima_provider.dart';
import '../../providers/auth_provider.dart';

class ClimaFormScreen extends ConsumerStatefulWidget {
  final Clima? clima; // null = crear, not null = editar
  const ClimaFormScreen({super.key, this.clima});

  @override
  ConsumerState<ClimaFormScreen> createState() => _ClimaFormScreenState();
}

class _ClimaFormScreenState extends ConsumerState<ClimaFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _fecha;
  late final TextEditingController _temperatura;
  late final TextEditingController _condicion;
  late final TextEditingController _velocidadViento;
  late final TextEditingController _idAeropuerto;
  bool _loading = false;

  bool get isEdit => widget.clima != null;

  @override
  void initState() {
    super.initState();
    _fecha = TextEditingController(text: widget.clima?.fecha.length == 24 ? widget.clima?.fecha.substring(0, 10) : widget.clima?.fecha.substring(0, 10) ?? '');
    _temperatura = TextEditingController(text: widget.clima?.temperatura.toString() ?? '');
    _condicion   = TextEditingController(text: widget.clima?.condicion   ?? '');
    _velocidadViento   = TextEditingController(text: widget.clima?.velocidadViento.toString() ?? '');
    _idAeropuerto   = TextEditingController(text: widget.clima?.idAeropuerto.toString() ?? '');
  }

  @override
  void dispose() {
    _fecha.dispose(); _temperatura.dispose(); _condicion.dispose(); _velocidadViento.dispose(); _idAeropuerto.dispose();
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
      setState(() {
        _fecha.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!ref.read(authProvider).isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sin permiso para esta acción'), backgroundColor: AppColors.error));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final payload = {
      'fecha': '${_fecha.text.trim()}T00:00:00Z',
      'temperatura': double.parse(_temperatura.text.trim()),
      'condicion': _condicion.text.trim(),
      'velocidad_viento': double.parse(_velocidadViento.text.trim()),
      'aeropuerto_id': int.parse(_idAeropuerto.text.trim())
    };
    try {
      final repo = ref.read(climaRepositoryProvider);
      if (isEdit) {
        await repo.updateClima(widget.clima!.idClima, payload);
      } else {
        await repo.createClima(payload);
      }
      ref.invalidate(climasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Clima actualizado' : 'Clima creado'),
            backgroundColor: AppColors.success));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(isEdit ? 'Editar Clima' : 'Nuevo Reporte de Clima')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fecha,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Fecha', prefixIcon: Icon(Icons.calendar_today_rounded)),
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Fecha es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              _field(_temperatura, 'Temperatura (°C)', Icons.thermostat_rounded, isDouble: true),
              const SizedBox(height: 16),
              _field(_condicion, 'Condición (ej. Soleado)', Icons.wb_sunny_rounded),
              const SizedBox(height: 16),
              _field(_velocidadViento, 'Velocidad de Viento', Icons.air_rounded, isDouble: true),
              const SizedBox(height: 16),
              _field(_idAeropuerto, 'ID Aeropuerto', Icons.location_city_rounded, isNum: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Actualizar' : 'Crear Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {String? hint, bool isNum = false, bool isDouble = false}) =>
    TextFormField(
      controller: ctrl,
      keyboardType: (isNum || isDouble) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), hintText: hint),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label es obligatorio';
        if (isNum && int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
        if (isDouble && double.tryParse(v.trim()) == null) return 'Debe ser un número válido';
        return null;
      },
    );
}
