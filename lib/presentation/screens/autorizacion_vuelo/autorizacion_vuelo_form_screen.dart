// lib/presentation/screens/autorizacion_vuelo/autorizacion_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/autorizacion_vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/autorizacion_vuelo.dart';
import '../../providers/autorizacion_vuelo_provider.dart';
import '../../providers/auth_provider.dart';

class AutorizacionFormScreen extends ConsumerStatefulWidget {
  final AutorizacionVuelo? autorizacion; // null = crear, not null = editar
  const AutorizacionFormScreen({super.key, this.autorizacion});

  @override
  ConsumerState<AutorizacionFormScreen> createState() => _AutorizacionFormScreenState();
}

class _AutorizacionFormScreenState extends ConsumerState<AutorizacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idVuelo;
  late final TextEditingController _tipo;
  late final TextEditingController _estado;
  late final TextEditingController _fecha;
  bool _loading = false;

  bool get isEdit => widget.autorizacion != null;

  @override
  void initState() {
    super.initState();
    String initFecha = '';
    if (widget.autorizacion != null && widget.autorizacion!.fecha.length >= 10) {
      initFecha = widget.autorizacion!.fecha.substring(0, 10);
    }
    _idVuelo = TextEditingController(text: widget.autorizacion?.idVuelo.toString() ?? '');
    _tipo    = TextEditingController(text: widget.autorizacion?.tipoAutorizacion ?? '');
    _estado  = TextEditingController(text: widget.autorizacion?.estado ?? '');
    _fecha   = TextEditingController(text: initFecha);
  }

  @override
  void dispose() {
    _idVuelo.dispose();
    _tipo.dispose();
    _estado.dispose();
    _fecha.dispose();
    super.dispose();
  }

  Future<void> _selectFecha(BuildContext context) async {
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

    final autorizacion = AutorizacionVuelo(
      idAutorizacion: isEdit ? widget.autorizacion!.idAutorizacion : 0,
      idVuelo: int.parse(_idVuelo.text.trim()),
      tipoAutorizacion: _tipo.text.trim(),
      estado: _estado.text.trim(),
      fecha: _fecha.text.trim(),
    );

    try {
      final repo = ref.read(autorizacionVueloRepositoryProvider);
      if (isEdit) {
        await repo.updateAutorizacionVuelo(autorizacion);
      } else {
        await repo.createAutorizacionVuelo(autorizacion);
      }
      ref.invalidate(autorizacionesVueloProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Autorización actualizada' : 'Autorización creada'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar autorización' : 'Nueva autorización')),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo de autorización',
                  prefixIcon: Icon(Icons.category_rounded),
                  hintText: 'Ej: despegue, aterrizaje',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tipo es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.verified_rounded),
                  hintText: 'Ej: pendiente, aprobado, rechazado',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Estado es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fecha,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                onTap: () => _selectFecha(context),
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
                  : Text(isEdit ? 'Actualizar' : 'Registrar autorización'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}