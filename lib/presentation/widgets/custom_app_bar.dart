import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            )
          : null,
      title: Row(
        children: [
          const Icon(
            Icons.flight_takeoff_rounded,
            color: AppColors.accent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
