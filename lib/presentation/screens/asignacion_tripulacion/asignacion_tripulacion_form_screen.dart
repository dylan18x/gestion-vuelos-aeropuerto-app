<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsignacionTripulacionFormScreen extends ConsumerWidget {
  const AsignacionTripulacionFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Asignación Tripulación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'ID Tripulación')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Guardar'))
          ],
=======
// lib/presentation/screens/asignacion_tripulacion/asignacion_tripulacion_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/asignacion_tripulacion_repository_impl.dart';
import '../../../domain/model/asignacion_tripulacion.dart';
import '../../../theme/app_colors.dart';
import '../../providers/asignacion_tripulacion_provider.dart';
import '../../providers/auth_provider.dart';

class AsignacionTripulacionFormScreen extends ConsumerStatefulWidget {
  final AsignacionTripulacion? asignacion;

  const AsignacionTripulacionFormScreen({
    super.key,
    this.asignacion,
  });

  @override
  ConsumerState<AsignacionTripulacionFormScreen> createState() =>
      _AsignacionTripulacionFormScreenState();
}

class _AsignacionTripulacionFormScreenState
    extends ConsumerState<AsignacionTripulacionFormScreen> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _idVuelo;
  late final TextEditingController _idEmpleado;

  bool _loading = false;

  bool get isEdit => widget.asignacion != null;

  @override
  void initState() {
    super.initState();

    _idVuelo = TextEditingController(
      text: widget.asignacion?.idVuelo.toString() ?? '',
    );

    _idEmpleado = TextEditingController(
      text: widget.asignacion?.idEmpleado.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _idVuelo.dispose();
    _idEmpleado.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!ref.read(authProvider).isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para esta acción'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final asignacion = AsignacionTripulacion(
      idAsignacion: isEdit ? widget.asignacion!.idAsignacion : 0,
      idVuelo: int.parse(_idVuelo.text.trim()),
      idEmpleado: int.parse(_idEmpleado.text.trim()),
    );

    try {
      final repo = ref.read(asignacionTripulacionRepositoryProvider);

      if (isEdit) {
        await repo.updateAsignacionTripulacion(asignacion);
      } else {
        await repo.createAsignacionTripulacion(asignacion);
      }

      ref.invalidate(asignacionesTripulacionProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Asignación actualizada'
                  : 'Asignación creada',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Editar asignación'
              : 'Nueva asignación',
        ),
      ),
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
                  prefixIcon: Icon(Icons.flight_takeoff),
                  hintText: 'Ingrese el ID del vuelo',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El ID del vuelo es obligatorio';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Debe ingresar un número válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _idEmpleado,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Empleado',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Ingrese el ID del empleado',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El ID del empleado es obligatorio';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Debe ingresar un número válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEdit
                            ? 'Actualizar'
                            : 'Crear asignación',
                      ),
              ),
            ],
          ),
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
        ),
      ),
    );
  }
}