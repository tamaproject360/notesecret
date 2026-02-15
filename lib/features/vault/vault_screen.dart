import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/core/auth/auth_service.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/widgets/buttons.dart';
import 'package:notesecret/shared/widgets/note_card.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  bool _isAuthenticated = false;
  bool _hasSecuritySetup = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    final authService = ref.read(authServiceProvider);
    final hasPin = await authService.hasPin();
    
    if (mounted) {
      setState(() {
        _hasSecuritySetup = hasPin;
        _isLoading = false;
      });

      if (_hasSecuritySetup) {
        _authenticate();
      }
    }
  }

  Future<void> _authenticate() async {
    final authService = ref.read(authServiceProvider);
    final biometricEnabled = await authService.isBiometricEnabled();
    
    bool authenticated = false;

    if (biometricEnabled) {
      authenticated = await authService.authenticateWithBiometrics();
    }

    // If biometric failed or not enabled, fallback to PIN (conceptual UI for now)
    // For this phase, we'll assume biometric success or skip to content for dev if no pin
    // In a real app, we'd show a PIN input screen here.
    
    if (authenticated) {
      if (mounted) setState(() => _isAuthenticated = true);
    } else {
      // Show PIN dialog or error
      if (mounted) _showUnlockDialog();
    }
  }

  void _showUnlockDialog() {
    final pinController = TextEditingController();
    bool isError = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Unlock Vault'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please enter your PIN'),
                const SizedBox(height: 16),
                TextField(
                  controller: pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'PIN',
                    errorText: isError ? 'Incorrect PIN' : null,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/home'); // Go back home if cancelled
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  final isValid = await authService.verifyPin(pinController.text);
                  
                  if (isValid) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      this.setState(() => _isAuthenticated = true);
                    }
                  } else {
                    setState(() => isError = true);
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: AppColors.sageGreen),
                child: const Text('Unlock'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasSecuritySetup) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vault')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.shieldAlert, size: 64, color: AppColors.warmGray),
              const SizedBox(height: 16),
              Text(
                'Vault Not Configured',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Set up a PIN in Settings to use the Vault.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.warmGray),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Go to Settings',
                onPressed: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.lock, size: 64, color: AppColors.sageGreen),
              const SizedBox(height: 24),
              Text('Vault Locked', style: AppTypography.headingMedium),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Unlock',
                onPressed: _authenticate,
              ),
            ],
          ),
        ),
      );
    }

    final lockedNotesAsync = ref.watch(lockedNotesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Vault', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
            centerTitle: true,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.lock),
                onPressed: () {
                  setState(() => _isAuthenticated = false);
                },
              ),
            ],
          ),
          lockedNotesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.shield, size: 64, color: AppColors.warmGray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Vault is Empty',
                          style: AppTypography.headingMedium.copyWith(color: AppColors.warmGray),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lock notes to move them here',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.warmGray),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => NoteCard(
                      note: notes[index],
                      onTap: () => context.push('/note/${notes[index].id}'),
                    ),
                    childCount: notes.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}
