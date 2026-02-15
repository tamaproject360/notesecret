import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/widgets/note_card.dart';
import 'package:notesecret/shared/widgets/skeleton.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinnedNotesAsync = ref.watch(pinnedNotesProvider);
    final normalNotesAsync = ref.watch(normalNotesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          
          // Pinned Notes Section
          pinnedNotesAsync.when(
            data: (notes) {
              if (notes.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'PINNED',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.warmGray,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      _buildNoteGridOrList(notes),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // Normal Notes Section
          normalNotesAsync.when(
            data: (notes) {
              if (notes.isEmpty && (pinnedNotesAsync.valueOrNull?.isEmpty ?? true)) {
                return const SliverFillRemaining(
                  child: _EmptyState(),
                );
              }
              if (notes.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: _isGridView 
                  ? SliverGrid(
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
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NoteCard(
                            note: notes[index],
                            onTap: () => context.push('/note/${notes[index].id}'),
                          ),
                        ),
                        childCount: notes.length,
                      ),
                    ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const SkeletonCard(height: 150),
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/note/new'),
        backgroundColor: AppColors.sageGreen,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'NoteSecret',
        style: AppTypography.headingMedium,
      ),
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.search),
          onPressed: () {
            // TODO: Open search view
          },
        ),
        IconButton(
          icon: Icon(_isGridView ? LucideIcons.list : LucideIcons.layoutGrid),
          onPressed: () => setState(() => _isGridView = !_isGridView),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 0.5,
          color: AppColors.warmGray.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildNoteGridOrList(List notes) {
    if (_isGridView) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) => NoteCard(
          note: notes[index],
          onTap: () => context.push('/note/${notes[index].id}'),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NoteCard(
            note: notes[index],
            onTap: () => context.push('/note/${notes[index].id}'),
          ),
        ),
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.bookOpen,
            size: 64,
            color: AppColors.warmGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.warmGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start writing',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.warmGray,
            ),
          ),
        ],
      ),
    );
  }
}
