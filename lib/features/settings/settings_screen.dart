import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/app/theme/theme_provider.dart';
import 'package:notesecret/core/auth/auth_service.dart';
import 'package:notesecret/core/backup/backup_provider.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/core/database/repositories/folder_provider.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<void> _showCreateBackupDialog() async {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your notes will be encrypted with AES-256 encryption.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.warmGray,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Backup Password',
                hintText: 'Enter a strong password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password cannot be empty')),
                );
                return;
              }
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.sageGreen),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      _createBackup(passwordController.text);
    }
  }

  Future<void> _createBackup(String password) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final backupService = ref.read(backupServiceProvider);
      final noteRepo = await ref.read(noteRepositoryProvider.future);
      final folderRepo = ref.read(folderRepositoryProvider);

      // Get all notes and folders
      final notes = await noteRepo.getAllNotes();
      final folders = await folderRepo.getAllFolders();

      // Create encrypted backup
      final backupFile = await backupService.createEncryptedBackup(
        notes: notes,
        folders: folders,
        password: password,
      );

      // Close loading
      if (mounted) Navigator.pop(context);

      // Share backup file
      await backupService.shareBackup(backupFile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Backup created successfully!'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create backup: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showRestoreBackupDialog() async {
    final passwordController = TextEditingController();

    // Pick backup file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) return;

    final filePath = result.files.first.path;
    if (filePath == null) return;

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will replace all your current notes and folders.',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Backup Password',
                hintText: 'Enter your backup password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.sageGreen),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _restoreBackup(filePath, passwordController.text);
    }
  }

  Future<void> _restoreBackup(String filePath, String password) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final backupService = ref.read(backupServiceProvider);
      final noteRepo = await ref.read(noteRepositoryProvider.future);
      final folderRepo = ref.read(folderRepositoryProvider);

      // Read backup file
      final file = File(filePath);
      final encryptedData = await file.readAsString();

      // Decrypt and parse
      final backupData = await backupService.restoreFromBackup(
        encryptedData: encryptedData,
        password: password,
      );

      // Parse notes and folders
      final notes = backupService.parseNotes(backupData['notes'] ?? []);
      final folders = backupService.parseFolders(backupData['folders'] ?? []);

      // Clear existing data and restore
      // Note: You may want to implement clearAll methods in repositories
      for (final folder in folders) {
        await folderRepo.saveFolder(folder);
      }
      
      for (final note in notes) {
        await noteRepo.saveNote(note);
      }

      // Close loading
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restored ${notes.length} notes and ${folders.length} folders!'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                  icon: LucideIcons.download,
                  title: 'Create Backup',
                  subtitle: 'Export encrypted backup file',
                  trailing: const Icon(LucideIcons.chevronRight, size: 20),
                  onTap: _showCreateBackupDialog,
                ),
                _buildListTile(
                  icon: LucideIcons.upload,
                  title: 'Restore Backup',
                  subtitle: 'Import from backup file',
                  trailing: const Icon(LucideIcons.chevronRight, size: 20),
                  onTap: _showRestoreBackupDialog,
                ),
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
