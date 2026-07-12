// lib/presentation/screens/empleados/empleado_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/empleado_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/empleado.dart';
import '../../providers/empleado_provider.dart';
import '../../providers/auth_provider.dart';

class EmpleadoFormScreen extends ConsumerStatefulWidget {
  final Empleado? empleado; // null = crear, not null = editar
  const EmpleadoFormScreen({super.key, this.empleado});

  @override
  ConsumerState<EmpleadoFormScreen> createState() => _EmpleadoFormScreenState();
}

class _EmpleadoFormScreenState extends ConsumerState<EmpleadoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _cargo;
  bool _loading = false;

  bool get isEdit => widget.empleado != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.empleado?.nombre ?? '');
    _cargo  = TextEditingController(text: widget.empleado?.cargo ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _cargo.dispose();
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
      'nombre': _nombre.text.trim(),
      'cargo':  _cargo.text.trim(),
    };

    try {
      final repo = ref.read(empleadoRepositoryProvider);
      if (isEdit) {
        await repo.updateEmpleado(widget.empleado!.id, payload);
      } else {
        await repo.createEmpleado(payload);
      }
      ref.invalidate(empleadosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Empleado actualizado' : 'Empleado creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar empleado' : 'Nuevo empleado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_nombre, 'Nombre', Icons.person_rounded),
              const SizedBox(height: 16),
              _field(_cargo, 'Cargo', Icons.work_rounded, hint: 'Ej: Piloto, Mecánico, Torre de control'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear empleado'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {String? hint}) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), hintText: hint),
      validator: (v) => (v == null || v.trim().isEmpty) ? '$label es obligatorio' : null,
    );
  }
}