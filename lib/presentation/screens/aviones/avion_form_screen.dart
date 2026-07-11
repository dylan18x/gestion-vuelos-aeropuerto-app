// lib/presentation/screens/aviones/avion_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/avion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/avion.dart';
import '../../providers/avion_provider.dart';
import '../../providers/auth_provider.dart';

class AvionFormScreen extends ConsumerStatefulWidget {
  final Avion? avion; // null = crear, not null = editar
  const AvionFormScreen({super.key, this.avion});

  @override
  ConsumerState<AvionFormScreen> createState() => _AvionFormScreenState();
}

class _AvionFormScreenState extends ConsumerState<AvionFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _modelo;
  late final TextEditingController _capacidad;
  late final TextEditingController _matricula;
  late final TextEditingController _idAerolinea;
  bool _loading = false;

  bool get isEdit => widget.avion != null;

  @override
  void initState() {
    super.initState();
    _modelo = TextEditingController(text: widget.avion?.modelo ?? '');
    _capacidad = TextEditingController(text: widget.avion?.capacidad.toString() ?? '');
    _matricula   = TextEditingController(text: widget.avion?.matricula   ?? '');
    _idAerolinea   = TextEditingController(text: widget.avion?.idAerolinea.toString() ?? '');
  }

  @override
  void dispose() {
    _modelo.dispose(); _capacidad.dispose(); _matricula.dispose(); _idAerolinea.dispose();
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
      'modelo': _modelo.text.trim(),
      'capacidad': int.parse(_capacidad.text.trim()),
      'matricula': _matricula.text.trim(),
      'aerolinea_id': int.parse(_idAerolinea.text.trim())
    };
    try {
      final repo = ref.read(avionRepositoryProvider);
      if (isEdit) {
        await repo.updateAvion(widget.avion!.idAvion, payload);
      } else {
        await repo.createAvion(payload);
      }
      ref.invalidate(avionesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Avión actualizado' : 'Avión creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar Avión' : 'Nuevo Avión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_modelo, 'Modelo', Icons.flight_rounded),
              const SizedBox(height: 16),
              _field(_capacidad, 'Capacidad', Icons.people_rounded, isNum: true),
              const SizedBox(height: 16),
              _field(_matricula, 'Matrícula', Icons.numbers_rounded),
              const SizedBox(height: 16),
              _field(_idAerolinea, 'ID Aerolínea', Icons.airlines_rounded, isNum: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Actualizar' : 'Crear Avión'),
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
