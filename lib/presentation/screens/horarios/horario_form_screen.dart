// lib/presentation/screens/horarios/horario_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/horario_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/horario.dart';
import '../../providers/horario_provider.dart';
import '../../providers/auth_provider.dart';

class HorarioFormScreen extends ConsumerStatefulWidget {
  final int idVuelo;
  final Horario? horario; // null = crear, not null = editar
  const HorarioFormScreen({super.key, required this.idVuelo, this.horario});

  @override
  ConsumerState<HorarioFormScreen> createState() => _HorarioFormScreenState();
}

class _HorarioFormScreenState extends ConsumerState<HorarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _salida;
  late final TextEditingController _llegada;
  DateTime? _salidaDt;
  DateTime? _llegadaDt;
  bool _loading = false;

  bool get isEdit => widget.horario != null;

  @override
  void initState() {
    super.initState();
    _salidaDt  = widget.horario != null ? DateTime.tryParse(widget.horario!.salidaProgramada) : null;
    _llegadaDt = widget.horario != null ? DateTime.tryParse(widget.horario!.llegadaProgramada) : null;
    _salida  = TextEditingController(text: _fmt(_salidaDt));
    _llegada = TextEditingController(text: _fmt(_llegadaDt));
  }

  String _fmt(DateTime? dt) => dt == null ? '' : DateFormat('dd/MM/yyyy HH:mm').format(dt);

  @override
  void dispose() {
    _salida.dispose();
    _llegada.dispose();
    super.dispose();
  }

  Future<void> _pick(bool esSalida) async {
    final base = esSalida ? _salidaDt : _llegadaDt;
    final fecha = await showDatePicker(
      context: context,
      initialDate: base ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (fecha == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: base != null ? TimeOfDay.fromDateTime(base) : TimeOfDay.now(),
    );
    if (hora == null) return;

    final combinado = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
    setState(() {
      if (esSalida) {
        _salidaDt = combinado;
        _salida.text = _fmt(combinado);
      } else {
        _llegadaDt = combinado;
        _llegada.text = _fmt(combinado);
      }
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
    if (_salidaDt == null || _llegadaDt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona salida y llegada'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _loading = true);

    final payload = {
      'salida_programada':  _salidaDt!.toIso8601String(),
      'llegada_programada': _llegadaDt!.toIso8601String(),
      'id_vuelo':           widget.idVuelo,
    };

    try {
      final repo = ref.read(horarioRepositoryProvider);
      if (isEdit) {
        await repo.updateHorario(widget.horario!.id, payload);
      } else {
        await repo.createHorario(payload);
      }
      ref.invalidate(horarioByVueloProvider(widget.idVuelo));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Horario actualizado' : 'Horario creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar horario' : 'Nuevo horario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _salida,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Salida programada',
                  prefixIcon: Icon(Icons.flight_takeoff_rounded),
                ),
                onTap: () => _pick(true),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Salida es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _llegada,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Llegada programada',
                  prefixIcon: Icon(Icons.flight_land_rounded),
                ),
                onTap: () => _pick(false),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Llegada es obligatoria' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear horario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}