// lib/presentation/screens/pilotos/piloto_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/piloto_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/piloto.dart';
import '../../providers/piloto_provider.dart';
import '../../providers/auth_provider.dart';

class PilotoFormScreen extends ConsumerStatefulWidget {
  final Piloto? piloto; // null = crear, not null = editar
  const PilotoFormScreen({super.key, this.piloto});

  @override
  ConsumerState<PilotoFormScreen> createState() => _PilotoFormScreenState();
}

class _PilotoFormScreenState extends ConsumerState<PilotoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _licencia;
  late final TextEditingController _idEmpleado;
  bool _loading = false;

  bool get isEdit => widget.piloto != null;

  @override
  void initState() {
    super.initState();
    _licencia   = TextEditingController(text: widget.piloto?.licencia ?? '');
    _idEmpleado = TextEditingController(text: widget.piloto?.empleado.id.toString() ?? '');
  }

  @override
  void dispose() {
    _licencia.dispose();
    _idEmpleado.dispose();
    super.dispose();
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

    final payload = {
      'licencia':    _licencia.text.trim(),
      'id_empleado': int.parse(_idEmpleado.text.trim()),
    };

    try {
      final repo = ref.read(pilotoRepositoryProvider);
      if (isEdit) {
        await repo.updatePiloto(widget.piloto!.id, payload);
      } else {
        await repo.createPiloto(payload);
      }
      ref.invalidate(pilotosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Piloto actualizado' : 'Piloto creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar piloto' : 'Nuevo piloto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _licencia,
                decoration: const InputDecoration(
                  labelText: 'Licencia',
                  prefixIcon: Icon(Icons.badge_rounded),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Licencia es obligatoria' : null,
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear piloto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}