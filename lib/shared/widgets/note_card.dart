import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/core/database/models/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 0.0,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(_controller);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  Color? _getNoteColor(String hexColor) {
    if (hexColor.isEmpty) return null;
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultCardBg = isDark ? AppColors.darkWarm : AppColors.softCream;
    final noteColor = _getNoteColor(widget.note.color);
    
    // Use note color as background, or default if no color set
    final cardBg = noteColor ?? defaultCardBg;
    
    // Adjust text color based on background brightness
    final textColor = noteColor != null 
        ? _getContrastColor(noteColor)
        : (isDark ? AppColors.darkTextCream : AppColors.deepCharcoal);
    
    final secondaryTextColor = noteColor != null
        ? _getContrastColor(noteColor).withOpacity(0.7)
        : (isDark ? AppColors.ashGray : AppColors.warmGray);
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: noteColor == null 
                ? Border.all(
                    color: isDark 
                        ? AppColors.warmGray.withOpacity(0.1)
                        : AppColors.warmGray.withOpacity(0.05),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark 
                  ? const Color.fromRGBO(0, 0, 0, 0.3) 
                  : const Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.note.title.isEmpty ? 'Untitled' : widget.note.title,
                        style: AppTypography.headingMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.note.isPinned) ...[
                      const SizedBox(width: 8),
                      Icon(LucideIcons.pin, size: 14, color: secondaryTextColor),
                    ],
                    if (widget.note.isLocked) ...[
                      const SizedBox(width: 8),
                      Icon(LucideIcons.lock, size: 14, color: secondaryTextColor),
                    ],
                  ],
                ),
                if (widget.note.body.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.note.body,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      color: secondaryTextColor,
                      height: 1.4,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  DateFormat.yMMMd().format(widget.note.updatedAt),
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to determine text color based on background brightness
  Color _getContrastColor(Color background) {
    // Calculate luminance
    final luminance = (0.299 * background.red + 
                      0.587 * background.green + 
                      0.114 * background.blue) / 255;
    
    // Return dark text for light backgrounds, light text for dark backgrounds
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
