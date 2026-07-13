// lib/presentation/screens/asignacion_tripulacion/asignacion_tripulacion_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/asignacion_tripulacion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/asignacion_tripulacion.dart';
import '../../providers/asignacion_tripulacion_provider.dart';
import '../../providers/auth_provider.dart';

class AsignacionTripulacionFormScreen extends ConsumerStatefulWidget {
  final AsignacionTripulacion? asignacion; // null = crear, not null = editar
  const AsignacionTripulacionFormScreen({super.key, this.asignacion});

  @override
  ConsumerState<AsignacionTripulacionFormScreen> createState() => _AsignacionTripulacionFormScreenState();
}

class _AsignacionTripulacionFormScreenState extends ConsumerState<AsignacionTripulacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idTripulacion;
  late final TextEditingController _idEmpleado;
  late final TextEditingController _fecha;
  bool _loading = false;

  bool get isEdit => widget.asignacion != null;

  @override
  void initState() {
    super.initState();
    String initFecha = '';
    if (widget.asignacion != null && widget.asignacion!.fechaAsignacion.length >= 10) {
      initFecha = widget.asignacion!.fechaAsignacion.substring(0, 10);
    }
    _idTripulacion = TextEditingController(text: widget.asignacion?.idTripulacion.toString() ?? '');
    _idEmpleado    = TextEditingController(text: widget.asignacion?.idEmpleado.toString() ?? '');
    _fecha         = TextEditingController(text: initFecha);
  }

  @override
  void dispose() {
    _idTripulacion.dispose();
    _idEmpleado.dispose();
    _fecha.dispose();
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
      setState(() => _fecha.text = DateFormat('yyyy-MM-dd').format(picked));
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

    final asignacion = AsignacionTripulacion(
      idAsignacion: isEdit ? widget.asignacion!.idAsignacion : 0,
      idTripulacion: int.parse(_idTripulacion.text.trim()),
      idEmpleado:    int.parse(_idEmpleado.text.trim()),
      fechaAsignacion: _fecha.text.trim(),
    );

    try {
      final repo = ref.read(asignacionTripulacionRepositoryProvider);
      if (isEdit) {
        await repo.updateAsignacionTripulacion(asignacion);
      } else {
        await repo.createAsignacionTripulacion(asignacion);
      }
      ref.invalidate(asignacionesTripulacionProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Asignación actualizada' : 'Asignación creada'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
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
      appBar: AppBar(title: Text(isEdit ? 'Editar asignación' : 'Nueva asignación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idTripulacion,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Tripulación',
                  prefixIcon: Icon(Icons.groups_rounded),
                  hintText: 'Revisa el listado de Tripulación para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'ID Tripulación es obligatorio';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idEmpleado,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Empleado',
                  prefixIcon: Icon(Icons.person_rounded),
                  hintText: 'Revisa el listado de Empleados para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'ID Empleado es obligatorio';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fecha,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de asignación',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Fecha es obligatoria' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear asignación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}