import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Calculate current index based on location
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/home')) currentIndex = 0;
    else if (location.startsWith('/vault')) currentIndex = 1;
    else if (location.startsWith('/folders')) currentIndex = 2;
    else if (location.startsWith('/settings')) currentIndex = 3;

    final navBarBg = isDark ? AppColors.warmBlack : AppColors.parchmentWhite;
    final borderColor = isDark ? AppColors.ashGray : AppColors.warmGray;

    return Container(
      decoration: BoxDecoration(
        color: navBarBg,
        border: Border(
          top: BorderSide(
            color: borderColor.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: LucideIcons.book,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavBarItem(
                icon: LucideIcons.lock,
                label: 'Vault',
                isActive: currentIndex == 1,
                onTap: () => context.go('/vault'),
              ),
              _NavBarItem(
                icon: LucideIcons.folder,
                label: 'Folders',
                isActive: currentIndex == 2,
                onTap: () => context.go('/folders'),
              ),
              _NavBarItem(
                icon: LucideIcons.settings,
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.mutedSage : AppColors.sageGreen;
    final inactiveColor = isDark ? AppColors.ashGray : AppColors.warmGray;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ] else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
