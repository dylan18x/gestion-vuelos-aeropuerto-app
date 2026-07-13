// lib/presentation/screens/public/information_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../widgets/custom_bottom_nav.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

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
            Text('Información'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cotopaxi Airlines',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Conectamos las principales ciudades del Ecuador con un servicio seguro, puntual y de calidad.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            _infoCard(
              Icons.business,
              '¿Quiénes somos?',
              'Cotopaxi Airlines es una aerolínea enfocada en brindar una experiencia de viaje segura, cómoda y eficiente para todos nuestros pasajeros.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              Icons.workspace_premium,
              'Misión',
              'Ofrecer un servicio de transporte aéreo confiable, moderno y orientado a la satisfacción del cliente.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              Icons.visibility,
              'Visión',
              'Ser una de las aerolíneas líderes del país, reconocida por su calidad, innovación y excelencia en el servicio.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              Icons.luggage,
              'Equipaje',
              'Cada pasajero puede llevar un equipaje de mano de hasta 10 kg y una maleta registrada según la tarifa adquirida.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              Icons.check_circle_outline,
              'Check-in',
              'Disponible en línea desde 24 horas hasta 1 hora antes de la salida del vuelo.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              Icons.policy,
              'Políticas',
              'Se recomienda presentarse al aeropuerto con al menos 2 horas de anticipación para vuelos nacionales.',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 2,
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.accent,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
