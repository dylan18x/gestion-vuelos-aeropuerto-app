// lib/core/utils/formatters.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

String formatDate(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    return DateFormat('dd MMM yyyy', 'es').format(dt);
  } catch (_) {
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }
}

String formatDateTime(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    return DateFormat('dd MMM yyyy · HH:mm', 'es').format(dt);
  } catch (_) {
    return iso.length >= 16 ? iso.substring(0, 16) : iso;
  }
}

String truncate(String text, int max) =>
  text.length <= max ? text : '${text.substring(0, max).trimRight()}…';

Color vueloEstadoColor(String estado) {
  final e = estado.toLowerCase();
  if (e.contains('program'))   return AppColors.info;
  if (e.contains('vuelo'))     return AppColors.success;
  if (e.contains('aterriz'))   return AppColors.success;
  if (e.contains('cancel'))    return AppColors.error;
  if (e.contains('demor') || e.contains('retra')) return AppColors.warning;
  return AppColors.textSecondary;
}