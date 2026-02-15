import 'package:flutter/material.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const InputTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkWarm : AppColors.softCream;
    final textColor = isDark ? AppColors.darkTextCream : AppColors.deepCharcoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: AppTypography.bodyLarge.copyWith(color: textColor),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.warmGray),
              labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.warmGray),
              floatingLabelStyle: AppTypography.labelSmall.copyWith(color: AppColors.sageGreen),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorText: null, // We display error text below manually for custom styling
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTypography.labelSmall.copyWith(color: AppColors.terracotta),
            ),
          ),
        ],
      ],
    );
  }
}
