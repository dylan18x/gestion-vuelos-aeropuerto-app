// lib/presentation/screens/escalas/escala_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/escala_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/escala_provider.dart';
import '../../providers/auth_provider.dart';

class EscalaFormScreen extends ConsumerStatefulWidget {
  final int idVuelo;
  const EscalaFormScreen({super.key, required this.idVuelo});

  @override
  ConsumerState<EscalaFormScreen> createState() => _EscalaFormScreenState();
}

class _EscalaFormScreenState extends ConsumerState<EscalaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idAeropuerto = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _idAeropuerto.dispose();
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
      'id_vuelo':          widget.idVuelo,
      'aeropuerto_escala': int.parse(_idAeropuerto.text.trim()),
    };

    try {
      await ref.read(escalaRepositoryProvider).createEscala(payload);
      ref.invalidate(escalasByVueloProvider(widget.idVuelo));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Escala creada'), backgroundColor: AppColors.success),
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
      appBar: AppBar(title: const Text('Nueva escala')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idAeropuerto,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Aeropuerto de escala',
                  prefixIcon: Icon(Icons.location_on_rounded),
                  hintText: 'Revisa el listado de Aeropuertos para el ID correcto',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'ID Aeropuerto es obligatorio';
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
                  : const Text('Crear escala'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}