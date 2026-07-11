// lib/presentation/screens/estado_vuelo/estado_vuelo_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/estado_vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/estado_vuelo.dart';
import '../../providers/estado_vuelo_provider.dart';
import '../../providers/auth_provider.dart';

class EstadoVueloFormScreen extends ConsumerStatefulWidget {
  final EstadoVuelo? estadoVuelo; // null = crear, not null = editar
  const EstadoVueloFormScreen({super.key, this.estadoVuelo});

  @override
  ConsumerState<EstadoVueloFormScreen> createState() => _EstadoVueloFormScreenState();
}

class _EstadoVueloFormScreenState extends ConsumerState<EstadoVueloFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _nombreEstado;
  late final TextEditingController _descripcion;
  bool _loading = false;

  bool get isEdit => widget.estadoVuelo != null;

  @override
  void initState() {
    super.initState();
    _nombreEstado = TextEditingController(text: widget.estadoVuelo?.nombreEstado ?? '');
    _descripcion = TextEditingController(text: widget.estadoVuelo?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreEstado.dispose(); _descripcion.dispose();
    super.dispose();
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
      'nombre_estado': _nombreEstado.text.trim(),
      'descripcion': _descripcion.text.trim()
    };
    try {
      final repo = ref.read(estadoVueloRepositoryProvider);
      if (isEdit) {
        await repo.updateEstadoVuelo(widget.estadoVuelo!.idEstado, payload);
      } else {
        await repo.createEstadoVuelo(payload);
      }
      ref.invalidate(estadoVuelosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Estado de vuelo actualizado' : 'Estado de vuelo creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar Estado de Vuelo' : 'Nuevo Estado de Vuelo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nombreEstado, 'Nombre del Estado', Icons.flag_rounded),
              const SizedBox(height: 16),
              _field(_descripcion, 'Descripción', Icons.description_rounded),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Actualizar' : 'Crear Estado'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {String? hint}) =>
    TextFormField(
      controller: ctrl,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), hintText: hint),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label es obligatorio';
        return null;
      },
    );
}
