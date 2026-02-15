import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/features/notes/providers/search_provider.dart';
import 'package:notesecret/shared/widgets/note_card.dart';
import 'package:notesecret/shared/widgets/skeleton.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce 200ms as per design spec
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _searchController.text == query) {
        ref.read(searchQueryProvider.notifier).updateQuery(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search your notes...',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.warmGray,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.x),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: searchResults.when(
        data: (notes) {
          if (_searchController.text.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.search,
                    size: 64,
                    color: AppColors.warmGray.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search your notes',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start typing to find notes',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                ],
              ),
            );
          }

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.searchX,
                    size: 64,
                    color: AppColors.warmGray.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try different keywords',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.warmGray,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onTap: () => context.push('/note/${note.id}'),
              );
            },
          );
        },
        loading: () => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: CircularProgressIndicator(
              color: isDark ? AppColors.mutedSage : AppColors.sageGreen,
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.terracotta,
            ),
          ),
        ),
      ),
    );
  }
}
