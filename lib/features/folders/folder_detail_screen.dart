import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/features/folders/providers/folder_provider.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/widgets/note_card.dart';
import 'package:notesecret/shared/widgets/skeleton.dart';

class FolderDetailScreen extends ConsumerStatefulWidget {
  final int folderId;

  const FolderDetailScreen({super.key, required this.folderId});

  @override
  ConsumerState<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends ConsumerState<FolderDetailScreen> {
  
  Future<void> _showAddNotesSheet() async {
    final noteRepo = await ref.read(noteRepositoryProvider.future);
    // Get all notes to filter (in a real app, you might want a specific query for 'no folder' or 'all')
    final allNotes = await noteRepo.getAllNotes(); 
    // Filter notes that are NOT in this folder already
    final availableNotes = allNotes.where((n) => n.folderId != widget.folderId && n.deletedAt == null).toList();
    
    if (!mounted) return;

    if (availableNotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other notes available to add.')),
      );
      return;
    }

    final Set<int> selectedNoteIds = {};

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Notes to Folder', style: AppTypography.headingMedium),
                      TextButton(
                        onPressed: () async {
                          // Save changes
                          if (selectedNoteIds.isNotEmpty) {
                            for (final note in availableNotes) {
                              if (selectedNoteIds.contains(note.id)) {
                                note.folderId = widget.folderId;
                                await noteRepo.saveNote(note);
                              }
                            }
                            if (mounted) {
                              Navigator.pop(context);
                              // Refresh the list
                              ref.invalidate(notesInFolderProvider(widget.folderId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${selectedNoteIds.length} notes added to folder'),
                                  backgroundColor: AppColors.forestGreen,
                                ),
                              );
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableNotes.length,
                      itemBuilder: (context, index) {
                        final note = availableNotes[index];
                        final isSelected = selectedNoteIds.contains(note.id);
                        return CheckboxListTile(
                          title: Text(
                            note.title.isEmpty ? 'Untitled' : note.title,
                            style: AppTypography.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            note.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.warmGray),
                          ),
                          value: isSelected,
                          activeColor: AppColors.sageGreen,
                          onChanged: (val) {
                            setModalState(() {
                              if (val == true) {
                                selectedNoteIds.add(note.id);
                              } else {
                                selectedNoteIds.remove(note.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesInFolderProvider(widget.folderId));
    final folderAsync = ref.watch(folderProvider(widget.folderId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
        title: folderAsync.when(
          data: (folder) => Text(
            folder?.name ?? 'Folder',
            style: AppTypography.headingMedium,
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Folder'),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNotesSheet,
        backgroundColor: AppColors.sageGreen,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.folderOpen,
                    size: 64,
                    color: AppColors.warmGray.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Empty Folder',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showAddNotesSheet,
                    icon: const Icon(LucideIcons.plus),
                    label: const Text('Add Existing Notes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sageGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return MasonryGridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index],
              onTap: () => context.push('/note/${notes[index].id}'),
            ),
          );
        },
        loading: () => Padding(
          padding: const EdgeInsets.all(16),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: 4,
            itemBuilder: (context, index) => const SkeletonCard(height: 150),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
