// lib/presentation/screens/asignacion_pista/asignacion_pista_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/asignacion_pista_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/asignacion_pista.dart';
import '../../providers/asignacion_pista_provider.dart';
import '../../providers/auth_provider.dart';

class AsignacionPistaFormScreen extends ConsumerStatefulWidget {
  final AsignacionPista? asignacion; // null = crear, not null = editar
  const AsignacionPistaFormScreen({super.key, this.asignacion});

  @override
  ConsumerState<AsignacionPistaFormScreen> createState() => _AsignacionPistaFormScreenState();
}

class _AsignacionPistaFormScreenState extends ConsumerState<AsignacionPistaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idPista;
  late final TextEditingController _idVuelo;
  late final TextEditingController _hora;
  DateTime? _horaSeleccionada;
  bool _loading = false;

  bool get isEdit => widget.asignacion != null;

  @override
  void initState() {
    super.initState();
    _idPista = TextEditingController(text: widget.asignacion?.idPista.toString() ?? '');
    _idVuelo = TextEditingController(text: widget.asignacion?.idVuelo.toString() ?? '');

    _horaSeleccionada = widget.asignacion != null
      ? DateTime.tryParse(widget.asignacion!.horaAsignacion)
      : null;
    _hora = TextEditingController(
      text: _horaSeleccionada != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(_horaSeleccionada!)
        : '',
    );
  }

  @override
  void dispose() {
    _idPista.dispose();
    _idVuelo.dispose();
    _hora.dispose();
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

    final asignacion = AsignacionPista(
      idAsignacionPista: isEdit ? widget.asignacion!.idAsignacionPista : 0,
      idPista: int.parse(_idPista.text.trim()),
      idVuelo: int.parse(_idVuelo.text.trim()),
      horaAsignacion: _horaSeleccionada!.toIso8601String(),
    );

    try {
      final repo = ref.read(asignacionPistaRepositoryProvider);
      if (isEdit) {
        await repo.updateAsignacionPista(asignacion);
      } else {
        await repo.createAsignacionPista(asignacion);
      }
      ref.invalidate(asignacionesPistaProvider);
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
                controller: _idPista,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Pista',
                  prefixIcon: Icon(Icons.flight_land_rounded),
                  hintText: 'Revisa el listado de Pistas para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'ID Pista es obligatorio';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idVuelo,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Vuelo',
                  prefixIcon: Icon(Icons.flight_rounded),
                  hintText: 'Revisa el listado de Vuelos para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'ID Vuelo es obligatorio';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hora,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Hora de asignación',
                  prefixIcon: Icon(Icons.access_time_rounded),
                ),
                onTap: () => _selectHora(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Hora es obligatoria' : null,
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