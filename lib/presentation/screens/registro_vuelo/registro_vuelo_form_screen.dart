// lib/presentation/screens/registros_vuelo/registro_vuelo_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/registro_vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/registro_vuelo.dart';
import '../../providers/registro_vuelo_provider.dart';
import '../../providers/auth_provider.dart';

class RegistroVueloFormScreen extends ConsumerStatefulWidget {
  final RegistroVuelo? registro; // null = crear, not null = editar
  const RegistroVueloFormScreen({super.key, this.registro});

  @override
  ConsumerState<RegistroVueloFormScreen> createState() => _RegistroVueloFormScreenState();
}

class _RegistroVueloFormScreenState extends ConsumerState<RegistroVueloFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idVuelo;
  DateTime? _salidaReal;
  DateTime? _llegadaReal;
  bool _loading = false;

  bool get isEdit => widget.registro != null;

  @override
  void initState() {
    super.initState();
    _idVuelo = TextEditingController(text: widget.registro?.vuelo?.id.toString() ?? '');
    _salidaReal  = widget.registro?.horaRealSalida != null
      ? DateTime.tryParse(widget.registro!.horaRealSalida!)
      : null;
    _llegadaReal = widget.registro?.horaRealLlegada != null
      ? DateTime.tryParse(widget.registro!.horaRealLlegada!)
      : null;
  }

  @override
  void dispose() {
    _idVuelo.dispose();
    super.dispose();
  }

  String _fmt(DateTime? dt) => dt == null ? 'No marcada' : DateFormat('dd/MM/yyyy HH:mm').format(dt);

  Future<void> _pick(bool esSalida) async {
    final base = esSalida ? _salidaReal : _llegadaReal;
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
        _salidaReal = combinado;
      } else {
        _llegadaReal = combinado;
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
    setState(() => _loading = true);

    final payload = <String, dynamic>{
      'hora_real_salida':  _salidaReal?.toIso8601String(),
      'hora_real_llegada': _llegadaReal?.toIso8601String(),
      if (_idVuelo.text.trim().isNotEmpty) 'id_vuelo': int.parse(_idVuelo.text.trim()),
    };

    try {
      final repo = ref.read(registroVueloRepositoryProvider);
      if (isEdit) {
        await repo.updateRegistroVuelo(widget.registro!.id, payload);
      } else {
        await repo.createRegistroVuelo(payload);
      }
      ref.invalidate(registrosVueloProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Registro actualizado' : 'Registro creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar registro' : 'Nuevo registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              _HoraTile(
                label: 'Salida real',
                value: _fmt(_salidaReal),
                icon: Icons.flight_takeoff_rounded,
                onTap: () => _pick(true),
                onClear: _salidaReal == null ? null : () => setState(() => _salidaReal = null),
              ),
              const SizedBox(height: 12),
              _HoraTile(
                label: 'Llegada real',
                value: _fmt(_llegadaReal),
                icon: Icons.flight_land_rounded,
                onTap: () => _pick(false),
                onClear: _llegadaReal == null ? null : () => setState(() => _llegadaReal = null),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tile para seleccionar una hora real opcional, con botón para limpiarla.
class _HoraTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _HoraTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (onClear != null)
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 18),
              onPressed: onClear,
            ),
        ],
      ),
    ),
  );
}