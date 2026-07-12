// lib/presentation/screens/historial_estado_vuelo/historial_estado_vuelo_detalle_screen.dart
import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/historial_estado_vuelo.dart';

/// Detalle de UN registro de historial (recibe el objeto ya cargado
/// desde la lista, no vuelve a pedirlo a la API).
class HistorialEstadoVueloDetalleScreen extends StatelessWidget {
  final HistorialEstadoVuelo historial;
  const HistorialEstadoVueloDetalleScreen({super.key, required this.historial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Detalle del historial')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _Row('Vuelo ID',      historial.idVuelo.toString()),
                _Row('Fecha cambio',  formatDate(historial.fechaCambio)),
                _Row('Estado',        historial.estado.nombreEstado),
                _Row('Observación',   historial.observacion.isEmpty
                    ? 'Sin observaciones' : historial.observacion),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}