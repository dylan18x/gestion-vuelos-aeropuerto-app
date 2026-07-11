// lib/presentation/screens/tipos_avion/tipo_avion_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/tipo_avion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/tipo_avion.dart';
import '../../providers/tipo_avion_provider.dart';
import '../../providers/auth_provider.dart';

class TipoAvionFormScreen extends ConsumerStatefulWidget {
  final TipoAvion? tipoAvion; // null = crear, not null = editar
  const TipoAvionFormScreen({super.key, this.tipoAvion});

  @override
  ConsumerState<TipoAvionFormScreen> createState() => _TipoAvionFormScreenState();
}

class _TipoAvionFormScreenState extends ConsumerState<TipoAvionFormScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _fabricante;
  late final TextEditingController _modelo;
  late final TextEditingController _alcance;
  bool _loading = false;

  bool get isEdit => widget.tipoAvion != null;

  @override
  void initState() {
    super.initState();
    _fabricante = TextEditingController(text: widget.tipoAvion?.fabricante ?? '');
    _modelo = TextEditingController(text: widget.tipoAvion?.modelo ?? '');
    _alcance   = TextEditingController(text: widget.tipoAvion?.alcance   ?? '');
  }

  @override
  void dispose() {
    _fabricante.dispose(); _modelo.dispose(); _alcance.dispose();
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
      'fabricante': _fabricante.text.trim(),
      'modelo': _modelo.text.trim(),
      'alcance': _alcance.text.trim()
    };
    try {
      final repo = ref.read(tipoAvionRepositoryProvider);
      if (isEdit) {
        await repo.updateTipoAvion(widget.tipoAvion!.idTipo, payload);
      } else {
        await repo.createTipoAvion(payload);
      }
      ref.invalidate(tiposAvionProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Tipo de Avión actualizado' : 'Tipo de Avión creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar Tipo de Avión' : 'Nuevo Tipo de Avión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_fabricante, 'Fabricante', Icons.factory_rounded),
              const SizedBox(height: 16),
              _field(_modelo, 'Modelo', Icons.flight_rounded),
              const SizedBox(height: 16),
              _field(_alcance, 'Alcance', Icons.map_rounded),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Actualizar' : 'Crear Tipo'),
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
