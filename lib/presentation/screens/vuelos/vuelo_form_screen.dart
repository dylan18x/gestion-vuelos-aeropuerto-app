// lib/presentation/screens/vuelos/vuelo_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/vuelo.dart';
import '../../providers/vuelo_provider.dart';
import '../../providers/auth_provider.dart';

class VueloFormScreen extends ConsumerStatefulWidget {
  final Vuelo? vuelo; // null = crear, not null = editar
  const VueloFormScreen({super.key, this.vuelo});

  @override
  ConsumerState<VueloFormScreen> createState() => _VueloFormScreenState();
}

class _VueloFormScreenState extends ConsumerState<VueloFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoVuelo;
  late final TextEditingController _fecha;
  late final TextEditingController _estado;
  late final TextEditingController _idAvion;
  bool _loading = false;

  bool get isEdit => widget.vuelo != null;

  // Ajusta estos valores si tu API usa otros nombres para el estado.
  static const _estados = ['programado', 'retrasado', 'cancelado', 'en vuelo', 'finalizado'];

  @override
  void initState() {
    super.initState();
    String initFecha = '';
    if (widget.vuelo != null && widget.vuelo!.fecha.length >= 10) {
      initFecha = widget.vuelo!.fecha.substring(0, 10);
    }
    _codigoVuelo = TextEditingController(text: widget.vuelo?.codigoVuelo ?? '');
    _fecha       = TextEditingController(text: initFecha);
    _estado      = TextEditingController(text: widget.vuelo?.estado ?? '');
    _idAvion     = TextEditingController(text: widget.vuelo?.avion?.id.toString() ?? '');
  }

  @override
  void dispose() {
    _codigoVuelo.dispose();
    _fecha.dispose();
    _estado.dispose();
    _idAvion.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _fecha.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _submit() async {
    // TECNICO y ADMIN pueden crear/editar vuelos (a diferencia de Mantenimiento,
    // que solo permite is_staff). Ajusta si tu regla de negocio es distinta.
    if (!ref.read(authProvider).isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para esta acción'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final payload = {
      'codigo_vuelo': _codigoVuelo.text.trim(),
      'fecha':        _fecha.text.trim(),
      'estado':       _estado.text.trim(),
      'id_avion':     int.parse(_idAvion.text.trim()),
    };

    try {
      final repo = ref.read(vueloRepositoryProvider);
      if (isEdit) {
        await repo.updateVuelo(widget.vuelo!.id, payload);
      } else {
        await repo.createVuelo(payload);
      }
      ref.invalidate(vuelosProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Vuelo actualizado' : 'Vuelo creado'),
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
      appBar: AppBar(title: Text(isEdit ? 'Editar vuelo' : 'Nuevo vuelo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(_codigoVuelo, 'Código de vuelo (ej: LA102)', Icons.confirmation_number_rounded),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fecha,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                onTap: () => _selectDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Fecha es obligatoria' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _estados.contains(_estado.text) ? _estado.text : null,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.flag_rounded),
                ),
                items: _estados
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _estado.text = val);
                },
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Estado es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              _field(_idAvion, 'ID Avión', Icons.flight_rounded, isNum: true,
                  hint: 'Revisa el listado de Aviones para el ID correcto'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEdit ? 'Actualizar' : 'Crear vuelo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {String? hint, bool isNum = false}) {
    return TextFormField(
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
}