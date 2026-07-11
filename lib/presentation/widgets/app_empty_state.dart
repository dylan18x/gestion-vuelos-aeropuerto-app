// lib/presentation/widgets/app_empty_state.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const AppEmptyState({super.key, required this.message, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 64, color: AppColors.textFaint),
        const SizedBox(height: 16),
        Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
      ],
    ),
  );
}
