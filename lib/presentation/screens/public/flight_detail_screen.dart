// lib/presentation/screens/public/flight_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/custom_bottom_nav.dart';

class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.flight_takeoff_rounded,
              color: AppColors.accent,
              size: 20,
            ),
            SizedBox(width: 8),
            Text('Detalle del Vuelo'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/flights'),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.flight,
                  color: AppColors.accent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Vuelo CT-205",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                _infoRow(
                  Icons.flight_takeoff,
                  "Origen",
                  "Quito",
                ),
                const Divider(),
                _infoRow(
                  Icons.flight_land,
                  "Destino",
                  "Guayaquil",
                ),
                const Divider(),
                _infoRow(
                  Icons.schedule,
                  "Hora de salida",
                  "08:30",
                ),
                const Divider(),
                _infoRow(
                  Icons.event_seat,
                  "Puerta",
                  "A3",
                ),
                const Divider(),
                _infoRow(
                  Icons.airplanemode_active,
                  "Aeronave",
                  "Airbus A320",
                ),
                const Divider(),
                _infoRow(
                  Icons.info_outline,
                  "Estado",
                  "A tiempo",
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/flights'),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text(
                      "Volver al listado",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.accent,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
