import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/ruta_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/ruta.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ruta_provider.dart';

class RutaFormScreen extends ConsumerStatefulWidget {
  final Ruta? ruta;
  const RutaFormScreen({super.key, this.ruta});

  @override
  ConsumerState<RutaFormScreen> createState() => _RutaFormScreenState();
}

class _RutaFormScreenState extends ConsumerState<RutaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _origen;
  late final TextEditingController _destino;
  bool _loading = false;

  bool get isEdit => widget.ruta != null;

  @override
  void initState() {
    super.initState();
    _origen = TextEditingController(text: widget.ruta?.origen.id.toString() ?? '');
    _destino = TextEditingController(text: widget.ruta?.destino.id.toString() ?? '');
  }

  @override
  void dispose() {
    _origen.dispose();
    _destino.dispose();
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
      'origen': int.parse(_origen.text.trim()),
      'destino': int.parse(_destino.text.trim()),
    };

    try {
      final repo = ref.read(rutaRepositoryProvider);
      if (isEdit) {
        await repo.updateRuta(widget.ruta!.id, payload);
      } else {
        await repo.createRuta(payload);
      }
      ref.invalidate(rutasProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Ruta actualizada' : 'Ruta creada'), backgroundColor: AppColors.success),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar ruta' : 'Nueva ruta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_origen, 'ID origen', Icons.flight_takeoff_rounded, isNum: true, hint: 'ID del aeropuerto de origen'),
              const SizedBox(height: 16),
              _field(_destino, 'ID destino', Icons.flight_land_rounded, isNum: true, hint: 'ID del aeropuerto de destino'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(isEdit ? 'Actualizar' : 'Crear ruta'),
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
