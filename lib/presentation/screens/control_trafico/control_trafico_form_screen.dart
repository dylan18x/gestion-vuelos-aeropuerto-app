// lib/presentation/screens/control_trafico/control_trafico_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/control_trafico_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/control_trafico.dart';
import '../../providers/control_trafico_provider.dart';
import '../../providers/auth_provider.dart';

class ControlTraficoFormScreen extends ConsumerStatefulWidget {
  final ControlTrafico? control; // null = crear, not null = editar
  const ControlTraficoFormScreen({super.key, this.control});

  @override
  ConsumerState<ControlTraficoFormScreen> createState() => _ControlTraficoFormScreenState();
}

class _ControlTraficoFormScreenState extends ConsumerState<ControlTraficoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _autorizacion;
  late final TextEditingController _hora;
  late final TextEditingController _idVuelo;
  DateTime? _horaSeleccionada;
  bool _loading = false;

  bool get isEdit => widget.control != null;

  @override
  void initState() {
    super.initState();
    _autorizacion = TextEditingController(text: widget.control?.autorizacion ?? '');
    _idVuelo      = TextEditingController(text: widget.control?.vuelo?.id.toString() ?? '');

    _horaSeleccionada = widget.control != null ? DateTime.tryParse(widget.control!.hora) : null;
    _hora = TextEditingController(
      text: _horaSeleccionada != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(_horaSeleccionada!)
        : '',
    );
  }

  @override
  void dispose() {
    _autorizacion.dispose();
    _hora.dispose();
    _idVuelo.dispose();
    super.dispose();
  }

  Future<void> _selectHora(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _horaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (fecha == null || !context.mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada != null
        ? TimeOfDay.fromDateTime(_horaSeleccionada!)
        : TimeOfDay.now(),
    );
    if (hora == null) return;

    final combinado = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
    setState(() {
      _horaSeleccionada = combinado;
      _hora.text = DateFormat('dd/MM/yyyy HH:mm').format(combinado);
    });
  }

  Future<void> _submit() async {
    if (!ref.read(authProvider).isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para esta acción'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la hora'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _loading = true);

    final payload = {
      'autorizacion': _autorizacion.text.trim(),
      'hora':         _horaSeleccionada!.toIso8601String(),
      'id_vuelo':     int.parse(_idVuelo.text.trim()),
    };

    try {
      final repo = ref.read(controlTraficoRepositoryProvider);
      if (isEdit) {
        await repo.updateControlTrafico(widget.control!.id, payload);
      } else {
        await repo.createControlTrafico(payload);
      }
      ref.invalidate(controlesTraficoProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Control actualizado' : 'Control creado'),
            backgroundColor: AppColors.success,
          ),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar control' : 'Nuevo control')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_autorizacion, 'Autorización', Icons.verified_user_rounded),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hora,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  prefixIcon: Icon(Icons.access_time_rounded),
                ),
                onTap: () => _selectHora(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Hora es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              _field(_idVuelo, 'ID Vuelo', Icons.flight_rounded, isNum: true,
                  hint: 'Revisa el listado de Vuelos para el ID correcto'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear control'),
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