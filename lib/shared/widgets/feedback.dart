import 'package:flutter/material.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';

class AppToast {
  static void show(BuildContext context, String message, {bool isError = false}) {
    final scaffold = ScaffoldMessenger.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? (isDark ? AppColors.softTerracotta : AppColors.terracotta)
            : (isDark ? AppColors.lightForest : AppColors.forestGreen),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showUndo(BuildContext context, String message, VoidCallback onUndo) {
    final scaffold = ScaffoldMessenger.of(context);
    
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.sageGreen,
          onPressed: onUndo,
        ),
        backgroundColor: const Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

class AppBottomSheet {
  static Future<T?> show<T>(BuildContext context, Widget child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: isDark ? AppColors.darkWarm : AppColors.softCream,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.warmGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
