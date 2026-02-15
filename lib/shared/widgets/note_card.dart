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
    final cardBg = isDark ? AppColors.darkWarm : AppColors.softCream;
    final textColor = isDark ? AppColors.darkTextCream : AppColors.deepCharcoal;
    final secondaryTextColor = isDark ? AppColors.ashGray : AppColors.warmGray;

    final noteColor = _getNoteColor(widget.note.color);
    
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
            boxShadow: [
              BoxShadow(
                color: isDark 
                  ? const Color.fromRGBO(0, 0, 0, 0.3) 
                  : const Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (noteColor != null)
                  Container(
                    width: 4,
                    color: noteColor,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.note.title.isEmpty ? 'Untitled' : widget.note.title,
                                style: AppTypography.headingMedium.copyWith(
                                  fontSize: 16,
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
                        const SizedBox(height: 8),
                        Text(
                          widget.note.body.isEmpty ? 'No content' : widget.note.body,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
