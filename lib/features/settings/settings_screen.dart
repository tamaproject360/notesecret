import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/app/theme/theme_provider.dart';
import 'package:notesecret/core/auth/auth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _biometricEnabled = false;
  bool _hasPin = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final authService = ref.read(authServiceProvider);
    final biometric = await authService.isBiometricEnabled();
    final pin = await authService.hasPin();
    
    if (mounted) {
      setState(() {
        _biometricEnabled = biometric;
        _hasPin = pin;
      });
    }
  }

  void _showSetPinDialog() {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pinController,
              decoration: const InputDecoration(labelText: 'Enter PIN (4-6 digits)'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (pinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN must be at least 4 digits')),
                );
                return;
              }
              
              if (pinController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PINs do not match')),
                );
                return;
              }

              final authService = ref.read(authServiceProvider);
              await authService.setPin(pinController.text);
              
              if (context.mounted) {
                Navigator.pop(context);
                _loadSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('PIN set successfully'),
                    backgroundColor: AppColors.forestGreen,
                  ),
                );
              }
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Settings',
              style: AppTypography.headingLarge.copyWith(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSectionHeader('Appearance'),
                _buildThemeSelector(),
                
                _buildSectionHeader('Security'),
                _buildListTile(
                  icon: LucideIcons.lock,
                  title: 'PIN Protection',
                  subtitle: _hasPin ? 'Enabled' : 'Disabled',
                  trailing: _hasPin
                      ? const Icon(LucideIcons.check, color: AppColors.forestGreen)
                      : TextButton(
                          onPressed: _showSetPinDialog,
                          child: const Text('Set PIN'),
                        ),
                ),
                if (_hasPin)
                  _buildSwitchTile(
                    icon: LucideIcons.fingerprint,
                    title: 'Biometric Unlock',
                    subtitle: 'Use fingerprint or face ID',
                    value: _biometricEnabled,
                    onChanged: (value) async {
                      final authService = ref.read(authServiceProvider);
                      await authService.setBiometricEnabled(value);
                      setState(() => _biometricEnabled = value);
                    },
                  ),
                
                _buildSectionHeader('Data'),
                _buildListTile(
                  icon: LucideIcons.trash2,
                  title: 'Trash',
                  subtitle: 'Recently deleted notes',
                  trailing: const Icon(LucideIcons.chevronRight, size: 20),
                  onTap: () => context.push('/trash'),
                ),
                
                _buildSectionHeader('About'),
                _buildListTile(
                  icon: LucideIcons.info,
                  title: 'Version',
                  subtitle: '1.0.0+1',
                ),
                _buildListTile(
                  icon: LucideIcons.heart,
                  title: 'Built with passion',
                  subtitle: 'by tamadev © 2025',
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.sageGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.sageGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.sageGreen),
      ),
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.warmGray))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.sageGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.sageGreen),
      ),
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.warmGray))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.sageGreen,
      ),
    );
  }

  Widget _buildThemeSelector() {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    
    return themeModeAsync.when(
      data: (currentMode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  icon: LucideIcons.sun,
                  label: 'Light',
                  isSelected: currentMode == ThemeMode.light,
                  onTap: () async {
                    await ref.read(themeModeNotifierProvider.notifier).setThemeMode(ThemeMode.light);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOption(
                  icon: LucideIcons.moon,
                  label: 'Dark',
                  isSelected: currentMode == ThemeMode.dark,
                  onTap: () async {
                    await ref.read(themeModeNotifierProvider.notifier).setThemeMode(ThemeMode.dark);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOption(
                  icon: LucideIcons.monitor,
                  label: 'System',
                  isSelected: currentMode == ThemeMode.system,
                  onTap: () async {
                    await ref.read(themeModeNotifierProvider.notifier).setThemeMode(ThemeMode.system);
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.sageGreen.withOpacity(0.2)
              : AppColors.warmGray.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.sageGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.sageGreen : AppColors.warmGray,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.sageGreen : AppColors.warmGray,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
