import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/tripulacion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/tripulacion.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tripulacion_provider.dart';

class TripulacionFormScreen extends ConsumerStatefulWidget {
  final Tripulacion? tripulacion;
  const TripulacionFormScreen({super.key, this.tripulacion});

  @override
  ConsumerState<TripulacionFormScreen> createState() => _TripulacionFormScreenState();
}

class _TripulacionFormScreenState extends ConsumerState<TripulacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cargo;
  late final TextEditingController _idEmpleado;
  bool _loading = false;

  bool get isEdit => widget.tripulacion != null;

  @override
  void initState() {
    super.initState();
    _cargo = TextEditingController(text: widget.tripulacion?.cargo ?? '');
    _idEmpleado = TextEditingController(text: widget.tripulacion?.empleado.id.toString() ?? '');
  }

  @override
  void dispose() {
    _cargo.dispose();
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
      'cargo': _cargo.text.trim(),
      'id_empleado': int.parse(_idEmpleado.text.trim()),
    };

    try {
      final repo = ref.read(tripulacionRepositoryProvider);
      if (isEdit) {
        await repo.updateTripulante(widget.tripulacion!.id, payload);
      } else {
        await repo.createTripulante(payload);
      }
      ref.invalidate(tripulacionesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Tripulación actualizada' : 'Tripulación creada'), backgroundColor: AppColors.success),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar tripulación' : 'Nueva tripulación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_cargo, 'Cargo', Icons.work_rounded, hint: 'Ej: Piloto, Sobrecargo'),
              const SizedBox(height: 16),
              _field(_idEmpleado, 'ID empleado', Icons.badge_rounded, isNum: true, hint: 'ID del empleado asociado'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(isEdit ? 'Actualizar' : 'Crear tripulación'),
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
