import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FlightCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String time;
  final String status;
  final VoidCallback onTap;

  const FlightCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Icon(Icons.flight, color: Colors.white),
        ),
        title: Text(
          "$origin → $destination",
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Hora: $time\nEstado: $status",
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.accent,
        ),
        onTap: onTap,
      ),
    );
  }
}
