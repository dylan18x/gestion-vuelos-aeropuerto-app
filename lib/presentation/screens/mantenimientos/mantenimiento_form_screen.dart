// lib/presentation/screens/mantenimientos/mantenimiento_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/mantenimiento_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/mantenimiento.dart';
import '../../providers/mantenimiento_provider.dart';
import '../../providers/auth_provider.dart';

class MantenimientoFormScreen extends ConsumerStatefulWidget {
  final Mantenimiento? mantenimiento; // null = crear, not null = editar
  const MantenimientoFormScreen({super.key, this.mantenimiento});

  @override
  ConsumerState<MantenimientoFormScreen> createState() => _MantenimientoFormScreenState();
}

class _MantenimientoFormScreenState extends ConsumerState<MantenimientoFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _fecha;
  late final TextEditingController _estado;
  late final TextEditingController _idAvion;
  bool _loading = false;

  bool get isEdit => widget.mantenimiento != null;

  @override
  void initState() {
    super.initState();
    String initFecha = '';
    if (widget.mantenimiento != null && widget.mantenimiento!.fecha.length >= 10) {
      initFecha = widget.mantenimiento!.fecha.substring(0, 10);
    }
    _fecha = TextEditingController(text: initFecha);
    _estado = TextEditingController(text: widget.mantenimiento?.estado ?? '');
    _idAvion   = TextEditingController(text: widget.mantenimiento?.idAvion.toString() ?? '');
  }

  @override
  void dispose() {
    _fecha.dispose(); _estado.dispose(); _idAvion.dispose();
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
      'fecha': _fecha.text.trim(),
      'estado': _estado.text.trim(),
      'id_avion': int.parse(_idAvion.text.trim())
    };
    try {
      final repo = ref.read(mantenimientoRepositoryProvider);
      if (isEdit) {
        await repo.updateMantenimiento(widget.mantenimiento!.idMantenimiento, payload);
      } else {
        await repo.createMantenimiento(payload);
      }
      ref.invalidate(mantenimientosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Mantenimiento actualizado' : 'Mantenimiento creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar Mantenimiento' : 'Nuevo Mantenimiento')),
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
              DropdownButtonFormField<String>(
                initialValue: _estado.text.isEmpty ? null : _estado.text,
                decoration: const InputDecoration(labelText: 'Estado', prefixIcon: Icon(Icons.info_rounded)),
                items: const [
                  DropdownMenuItem(value: 'Programado', child: Text('Programado')),
                  DropdownMenuItem(value: 'En curso', child: Text('En curso')),
                  DropdownMenuItem(value: 'Completado', child: Text('Completado')),
                  DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                ],
                onChanged: (val) {
                  if (val != null) _estado.text = val;
                },
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Estado es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              _field(_idAvion, 'ID Avión', Icons.flight_rounded, isNum: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Actualizar' : 'Crear Mantenimiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {String? hint, bool isNum = false}) =>
    TextFormField(
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
