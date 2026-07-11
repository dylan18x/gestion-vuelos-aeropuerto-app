// lib/presentation/widgets/app_error_widget.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const AppErrorWidget({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    ),
  );
}
