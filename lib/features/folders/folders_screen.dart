import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/core/database/models/folder.dart';
import 'package:notesecret/features/folders/providers/folder_provider.dart';
import 'package:notesecret/shared/widgets/buttons.dart';
import 'package:notesecret/shared/widgets/input_field.dart';

class FoldersScreen extends ConsumerStatefulWidget {
  const FoldersScreen({super.key});

  @override
  ConsumerState<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends ConsumerState<FoldersScreen> {
  void _showCreateFolderDialog() {
    final nameController = TextEditingController();
    String selectedEmoji = '📁';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.warmGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create Folder',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: 24),
              // Emoji selector
              StatefulBuilder(
                builder: (context, setModalState) => Row(
                  children: [
                    Text('Icon:', style: AppTypography.labelMedium),
                    const SizedBox(width: 16),
                    ...['📁', '📂', '🗂️', '📚', '📖', '📝', '💼', '🎯'].map(
                      (emoji) => GestureDetector(
                        onTap: () {
                          setModalState(() => selectedEmoji = emoji);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedEmoji == emoji
                                ? AppColors.sageGreen.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedEmoji == emoji
                                  ? AppColors.sageGreen
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InputTextField(
                controller: nameController,
                label: 'Folder Name',
                hint: 'e.g., Work, Personal',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Create',
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) return;

                        final folder = Folder()
                          ..name = nameController.text.trim()
                          ..emoji = selectedEmoji
                          ..createdAt = DateTime.now();

                        final repository = await ref.read(folderRepositoryProvider.future);
                        await repository.saveFolder(folder);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Folder "${folder.name}" created'),
                              backgroundColor: AppColors.forestGreen,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text('Are you sure you want to delete "${folder.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final repository = await ref.read(folderRepositoryProvider.future);
              await repository.deleteFolder(folder.id);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Folder "${folder.name}" deleted'),
                    backgroundColor: AppColors.terracotta,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.terracotta),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foldersAsync = ref.watch(allFoldersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Folders',
              style: AppTypography.headingLarge.copyWith(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.plus),
                onPressed: _showCreateFolderDialog,
                tooltip: 'Create Folder',
              ),
            ],
          ),
          foldersAsync.when(
            data: (folders) {
              if (folders.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.folder,
                          size: 64,
                          color: AppColors.warmGray.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Folders Yet',
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.warmGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to create your first folder',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.warmGray,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: 'Create Folder',
                          onPressed: _showCreateFolderDialog,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final folder = folders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkWarm : AppColors.softCream,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.sageGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                folder.emoji ?? '📁',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          title: Text(
                            folder.name,
                            style: AppTypography.headingMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Created ${_formatDate(folder.createdAt)}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.warmGray,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 20),
                            color: AppColors.terracotta,
                            onPressed: () => _showDeleteDialog(folder),
                          ),
                          onTap: () {
                            // Navigate to folder notes view
                            // TODO: Implement folder notes filtering
                          },
                        ),
                      );
                    },
                    childCount: folders.length,
                  ),
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: isDark ? AppColors.mutedSage : AppColors.sageGreen,
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error: $error',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.terracotta,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
