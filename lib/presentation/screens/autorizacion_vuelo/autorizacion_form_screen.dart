import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutorizacionFormScreen extends ConsumerStatefulWidget {
  const AutorizacionFormScreen({super.key});

  @override
  ConsumerState<AutorizacionFormScreen> createState() => _AutorizacionFormScreenState();
}

class _AutorizacionFormScreenState extends ConsumerState<AutorizacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos del formulario
  final _idVueloController = TextEditingController();
  final _estadoController = TextEditingController();

  @override
  void dispose() {
    _idVueloController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Autorización')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idVueloController,
                decoration: const InputDecoration(labelText: 'ID de Vuelo'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica para enviar al repositorio/provider:
                    // ref.read(autorizacionesVueloProvider.notifier).create(...);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Guardando autorización...')),
                    );
                  }
                },
                child: const Text('Registrar Autorización'),
              )
            ],
          ),
        ),
      ),
    );
  }
}