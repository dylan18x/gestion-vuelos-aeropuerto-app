<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PistaFormScreen extends ConsumerWidget {
  const PistaFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Pista')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Estado')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Guardar'))
          ],
=======
// lib/presentation/screens/pistas/pista_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/pista_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/pista.dart';
import '../../providers/pista_provider.dart';
import '../../providers/auth_provider.dart';

class PistaFormScreen extends ConsumerStatefulWidget {
  final Pista? pista; // null = crear, not null = editar
  const PistaFormScreen({super.key, this.pista});

  @override
  ConsumerState<PistaFormScreen> createState() => _PistaFormScreenState();
}

class _PistaFormScreenState extends ConsumerState<PistaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigo;
  late final TextEditingController _estado;
  bool _loading = false;

  bool get isEdit => widget.pista != null;

  @override
  void initState() {
    super.initState();
    _codigo = TextEditingController(text: widget.pista?.codigo ?? '');
    _estado = TextEditingController(text: widget.pista?.estado ?? '');
  }

  @override
  void dispose() {
    _codigo.dispose();
    _estado.dispose();
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

    final pista = Pista(
      idPista: isEdit ? widget.pista!.idPista : 0,
      codigo:  _codigo.text.trim(),
      estado:  _estado.text.trim(),
    );

    try {
      final repo = ref.read(pistaRepositoryProvider);
      if (isEdit) {
        await repo.updatePista(pista);
      } else {
        await repo.createPista(pista);
      }
      ref.invalidate(pistasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Pista actualizada' : 'Pista creada'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar pista' : 'Nueva pista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codigo,
                decoration: const InputDecoration(
                  labelText: 'Código',
                  prefixIcon: Icon(Icons.confirmation_number_rounded),
                  hintText: 'Ej: 09L/27R',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Código es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.flag_rounded),
                  hintText: 'Ej: operativa, mantenimiento, cerrada',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Estado es obligatorio' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear pista'),
              ),
            ],
          ),
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
        ),
      ),
    );
  }
}