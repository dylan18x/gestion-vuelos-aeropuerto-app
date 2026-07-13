// lib/presentation/screens/public/flights_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/custom_bottom_nav.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> flights = [
      {
        "flight": "CT-205",
        "origin": "Quito",
        "destination": "Guayaquil",
        "time": "08:30",
        "status": "A tiempo",
      },
      {
        "flight": "CT-310",
        "origin": "Quito",
        "destination": "Cuenca",
        "time": "10:45",
        "status": "Embarcando",
      },
      {
        "flight": "CT-412",
        "origin": "Quito",
        "destination": "Manta",
        "time": "13:20",
        "status": "Retrasado",
      },
      {
        "flight": "CT-520",
        "origin": "Guayaquil",
        "destination": "Quito",
        "time": "17:15",
        "status": "A tiempo",
      },
    ];

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
            Text('Vuelos Disponibles'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];

          return Card(
            color: AppColors.surface,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                backgroundColor: AppColors.accent,
                child: Icon(
                  Icons.flight,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "${flight["origin"]} → ${flight["destination"]}",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Vuelo: ${flight["flight"]}\n"
                  "Hora: ${flight["time"]}\n"
                  "Estado: ${flight["status"]}",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 18,
              ),
              onTap: () {
                context.go('/flight-detail');
              },
            ),
          );
        },
      ),

      // Barra de navegación inferior
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}
