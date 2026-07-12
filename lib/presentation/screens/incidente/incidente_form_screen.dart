// lib/presentation/screens/incidentes/incidente_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/incidente_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/incidente.dart';
import '../../providers/incidente_provider.dart';
import '../../providers/auth_provider.dart';

class IncidenteFormScreen extends ConsumerStatefulWidget {
  final Incidente? incidente; // null = crear, not null = editar
  const IncidenteFormScreen({super.key, this.incidente});

  @override
  ConsumerState<IncidenteFormScreen> createState() => _IncidenteFormScreenState();
}

class _IncidenteFormScreenState extends ConsumerState<IncidenteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descripcion;
  late final TextEditingController _fecha;
  late final TextEditingController _idVuelo;
  bool _loading = false;

  bool get isEdit => widget.incidente != null;

  @override
  void initState() {
    super.initState();
    String initFecha = '';
    if (widget.incidente != null && widget.incidente!.fecha.length >= 10) {
      initFecha = widget.incidente!.fecha.substring(0, 10);
    }
    _descripcion = TextEditingController(text: widget.incidente?.descripcion ?? '');
    _fecha        = TextEditingController(text: initFecha);
    _idVuelo      = TextEditingController(text: widget.incidente?.vuelo?.id.toString() ?? '');
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _fecha.dispose();
    _idVuelo.dispose();
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

    final payload = <String, dynamic>{
      'descripcion': _descripcion.text.trim(),
      'fecha':       _fecha.text.trim(),
      // id_vuelo es opcional: solo se envía si el usuario lo llenó
      if (_idVuelo.text.trim().isNotEmpty) 'id_vuelo': int.parse(_idVuelo.text.trim()),
    };

    try {
      final repo = ref.read(incidenteRepositoryProvider);
      if (isEdit) {
        await repo.updateIncidente(widget.incidente!.id, payload);
      } else {
        await repo.createIncidente(payload);
      }
      ref.invalidate(incidentesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Incidente actualizado' : 'Incidente creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar incidente' : 'Nuevo incidente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descripcion,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description_rounded),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Descripción es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fecha,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Fecha es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idVuelo,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Vuelo (opcional)',
                  prefixIcon: Icon(Icons.flight_rounded),
                  hintText: 'Revisa el listado de Vuelos para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null; // opcional
                  if (int.tryParse(v.trim()) == null) return 'Debe ser un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear incidente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}