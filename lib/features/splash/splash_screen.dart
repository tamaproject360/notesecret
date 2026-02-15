import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesecret/app/theme/color_scheme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Wait for 1.5 seconds as per design system specification
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      // Navigate to home (skip onboarding for now, implement later with SharedPreferences)
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.warmBlack : AppColors.parchmentWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon placeholder - you can add actual icon/logo here
            Icon(
              Icons.lock_outline,
              size: 80,
              color: isDark ? AppColors.mutedSage : AppColors.sageGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'NoteSecret',
              style: GoogleFonts.lora(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextCream : AppColors.deepCharcoal,
              ),
            ),
            const SizedBox(height: 48),
            // Footer as per design system
            Text(
              'Built with passion by tamadev © 2025',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.warmGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
