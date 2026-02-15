import 'package:flutter/material.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isFullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.isFullWidth = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller.view;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDestructive
        ? AppColors.terracotta
        : AppColors.sageGreen;

    Widget button = Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.onPressed == null ? color.withOpacity(0.5) : color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: widget.onPressed == null
            ? []
            : [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        widget.label,
        style: AppTypography.labelLarge.copyWith(color: Colors.white),
      ),
    );

    if (!widget.isFullWidth) {
      button = IntrinsicWidth(child: button);
    }

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }
}

class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;

  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller.view;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isDestructive
        ? AppColors.terracotta
        : AppColors.sageGreen;

    return GestureDetector(
      onTapDown: (details) => _controller.reverse(),
      onTapUp: (details) {
        _controller.forward();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.onPressed == null
                  ? AppColors.warmGray
                  : color,
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: AppTypography.labelLarge.copyWith(
              color: widget.onPressed == null ? AppColors.warmGray : color,
            ),
          ),
        ),
      ),
    );
  }
}
