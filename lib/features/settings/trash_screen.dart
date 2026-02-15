import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/widgets/note_card.dart';
import 'package:notesecret/shared/widgets/buttons.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allNotesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trash',
          style: AppTypography.headingLarge.copyWith(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: notesAsync.when(
        data: (allNotes) {
          final deletedNotes = allNotes.where((note) => note.deletedAt != null).toList();

          if (deletedNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.trash2,
                    size: 64,
                    color: AppColors.warmGray.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trash is Empty',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deleted notes will appear here',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.terracotta.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, size: 16, color: AppColors.terracotta),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Notes are permanently deleted after 30 days',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: deletedNotes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final note = deletedNotes[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkWarm : AppColors.softCream,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              note.title.isEmpty ? 'Untitled' : note.title,
                              style: AppTypography.headingMedium.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  note.body,
                                  style: AppTypography.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Deleted ${_formatDate(note.deletedAt!)}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.terracotta,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GhostButton(
                                    label: 'Restore',
                                    onPressed: () async {
                                      final repository = await ref.read(noteRepositoryProvider.future);
                                      await repository.restoreNote(note.id);
                                      
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Note restored'),
                                            backgroundColor: AppColors.forestGreen,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: PrimaryButton(
                                    label: 'Delete Forever',
                                    isDestructive: true,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Forever'),
                                          content: const Text('This note will be permanently deleted. This action cannot be undone.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final repository = await ref.read(noteRepositoryProvider.future);
                                                await repository.permanentDeleteNote(note.id);
                                                
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Note permanently deleted'),
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
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: isDark ? AppColors.mutedSage : AppColors.sageGreen,
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.terracotta),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'today';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }
}
