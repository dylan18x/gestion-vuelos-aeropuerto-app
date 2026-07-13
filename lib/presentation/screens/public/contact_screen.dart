// lib/presentation/screens/public/contact_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../widgets/custom_bottom_nav.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
            Text('Cotopaxi Airlines'),
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
              'Contáctanos',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estamos disponibles para ayudarte con cualquier consulta.',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            _contactCard(
              icon: Icons.phone,
              title: 'Teléfono',
              subtitle: '+593 2 123 4567',
            ),
            const SizedBox(height: 16),
            _contactCard(
              icon: Icons.email,
              title: 'Correo',
              subtitle: 'contacto@cotopaxiairlines.com',
            ),
            const SizedBox(height: 16),
            _contactCard(
              icon: Icons.location_on,
              title: 'Dirección',
              subtitle:
                  'Aeropuerto Internacional Mariscal Sucre\nQuito, Ecuador',
            ),
            const SizedBox(height: 16),
            _contactCard(
              icon: Icons.schedule,
              title: 'Horario de atención',
              subtitle: 'Lunes a Domingo\n08:00 - 20:00',
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(
                  Icons.home,
                ),
                label: const Text(
                  'Volver al Inicio',
                ),
              ),
            ),
          ],
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.accent,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
