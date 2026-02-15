import 'package:flutter/material.dart';
import 'package:notesecret/app/theme/color_scheme.dart';

class SkeletonCard extends StatefulWidget {
  final double height;
  
  const SkeletonCard({super.key, this.height = 100});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkWarm : AppColors.softCream;
    final highlightColor = isDark 
        ? AppColors.darkWarm.withOpacity(0.5) 
        : Colors.white.withOpacity(0.5);

    _colorAnimation = ColorTween(
      begin: baseColor,
      end: highlightColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
