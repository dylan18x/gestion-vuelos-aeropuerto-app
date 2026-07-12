// lib/presentation/widgets/app_confirm_dialog.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

Future<bool> showConfirmDialog(BuildContext context, {required String title, required String content}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface2,
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      content: Text(content, style: const TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  return result ?? false;
}
