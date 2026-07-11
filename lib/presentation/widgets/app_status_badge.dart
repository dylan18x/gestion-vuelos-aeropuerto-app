// lib/presentation/widgets/app_status_badge.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const AppStatusBadge({super.key, required this.label, required this.color});

  factory AppStatusBadge.forEstado(String estado) {
    final lower = estado.toLowerCase();
    Color color;
    if (lower.contains('program')) {
      color = AppColors.info;
    } else if (lower.contains('vuelo') || lower.contains('activ')) {
      color = AppColors.success;
    } else if (lower.contains('cancel')) {
      color = AppColors.error;
    } else if (lower.contains('demor') || lower.contains('retra')) {
      color = AppColors.warning;
    } else {
      color = AppColors.textSecondary;
    }
    return AppStatusBadge(label: estado, color: color);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}
