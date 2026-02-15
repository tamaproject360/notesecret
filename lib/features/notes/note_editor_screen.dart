import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/widgets/feedback.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final int? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  
  Note? _currentNote;
  Timer? _autoSaveTimer;
  bool _isDirty = false;
  bool _isLoading = true;
  int _wordCount = 0;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      final note = await ref.read(noteProvider(widget.noteId!).future);
      if (note != null) {
        setState(() {
          _currentNote = note;
          _titleController.text = note.title;
          _bodyController.text = note.body;
          _updateCounts();
          _isLoading = false;
        });
      } else {
         setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveNote(); // Final save
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _updateCounts() {
    final text = _bodyController.text;
    setState(() {
      _charCount = text.length;
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _onTextChanged() {
    _updateCounts();
    setState(() => _isDirty = true);
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _saveNote);
  }

  void _insertMarkdown(String prefix, [String suffix = '']) {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    
    if (!selection.isValid) return; // No selection or cursor

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);
    
    final newText = text.replaceRange(start, end, '$prefix$selectedText$suffix');
    final newSelectionIndex = start + prefix.length + selectedText.length + suffix.length;

    setState(() {
      _bodyController.text = newText;
      _bodyController.selection = TextSelection.collapsed(offset: newSelectionIndex);
      _onTextChanged();
    });
  }

  Future<void> _saveNote() async {
    if (!_isDirty && _currentNote != null) return;
    if (_titleController.text.isEmpty && _bodyController.text.isEmpty) return;

    final repository = await ref.read(noteRepositoryProvider.future);
    
    final note = _currentNote ?? Note()
      ..title = _titleController.text
      ..body = _bodyController.text
      ..color = _currentNote?.color ?? '' // Default no color
      ..createdAt = DateTime.now();

    // Update fields
    note.title = _titleController.text;
    note.body = _bodyController.text;
    note.updatedAt = DateTime.now();

    await repository.saveNote(note);

    if (mounted) {
      setState(() {
        _currentNote = note;
        _isDirty = false;
      });
    }
  }

  Future<void> _deleteNote() async {
    if (_currentNote != null) {
      final repository = await ref.read(noteRepositoryProvider.future);
      await repository.deleteNote(_currentNote!.id);
      if (mounted) {
        AppToast.show(context, 'Note moved to trash');
        context.pop();
      }
    } else {
      context.pop(); // Just exit if it was never saved
    }
  }

  Future<void> _toggleLock() async {
    if (_currentNote != null) {
      final repository = await ref.read(noteRepositoryProvider.future);
      await repository.toggleLock(_currentNote!.id);
      
      setState(() {
        _currentNote!.isLocked = !_currentNote!.isLocked;
      });
      
      if (mounted) {
        AppToast.show(context, _currentNote!.isLocked ? 'Note locked' : 'Note unlocked');
      }
    }
  }

  Future<void> _togglePin() async {
    if (_currentNote != null) {
      final repository = await ref.read(noteRepositoryProvider.future);
      await repository.togglePin(_currentNote!.id);
      
      setState(() {
        _currentNote!.isPinned = !_currentNote!.isPinned;
      });
      
      if (mounted) {
        AppToast.show(context, _currentNote!.isPinned ? 'Note pinned' : 'Note unpinned');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () async {
            await _saveNote();
            if (mounted) context.pop();
          },
        ),
        actions: [
          if (_isDirty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Saving...',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.warmGray),
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _deleteNote();
              if (value == 'lock') _toggleLock();
              if (value == 'pin') _togglePin();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pin',
                child: Row(
                  children: [
                    Icon(_currentNote?.isPinned == true ? LucideIcons.pinOff : LucideIcons.pin, size: 18, color: AppColors.deepCharcoal),
                    const SizedBox(width: 12),
                    Text(_currentNote?.isPinned == true ? 'Unpin' : 'Pin'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'lock',
                child: Row(
                  children: [
                    Icon(_currentNote?.isLocked == true ? LucideIcons.unlock : LucideIcons.lock, size: 18, color: AppColors.deepCharcoal),
                    const SizedBox(width: 12),
                    Text(_currentNote?.isLocked == true ? 'Unlock' : 'Lock'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'color',
                child: Row(
                  children: [
                    Icon(LucideIcons.palette, size: 18, color: AppColors.deepCharcoal),
                    const SizedBox(width: 12),
                    Text('Color'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: AppColors.terracotta),
                    const SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: AppColors.terracotta)),
                  ],
                ),
              ),
            ],
            icon: const Icon(LucideIcons.moreVertical),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: TextField(
                controller: _titleController,
                onChanged: (_) => _onTextChanged(),
                style: AppTypography.headingLarge,
                decoration: InputDecoration(
                  hintText: 'Untitled',
                  hintStyle: AppTypography.headingLarge.copyWith(
                    color: AppColors.warmGray.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _bodyController,
                  onChanged: (_) => _onTextChanged(),
                  style: AppTypography.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Start writing...',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.warmGray.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            _buildToolbar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.softCream : AppColors.deepCharcoal;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? MediaQuery.of(context).viewInsets.bottom + 8 : 24,
        top: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.warmGray.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ToolbarButton(
                icon: LucideIcons.image, 
                onPressed: () {
                  // TODO: Implement Image Picker
                  AppToast.show(context, 'Image picker coming soon');
                }
              ),
              _ToolbarButton(
                icon: LucideIcons.checkSquare, 
                onPressed: () => _insertMarkdown('- [ ] ')
              ),
              _ToolbarButton(
                icon: LucideIcons.bold, 
                onPressed: () => _insertMarkdown('**', '**')
              ),
              _ToolbarButton(
                icon: LucideIcons.italic, 
                onPressed: () => _insertMarkdown('*', '*')
              ),
              _ToolbarButton(
                icon: LucideIcons.heading, 
                onPressed: () => _insertMarkdown('# ')
              ),
              _ToolbarButton(
                icon: LucideIcons.list, 
                onPressed: () => _insertMarkdown('- ')
              ),
              _ToolbarButton(
                icon: LucideIcons.quote, 
                onPressed: () => _insertMarkdown('> ')
              ),
              _ToolbarButton(
                icon: LucideIcons.code, 
                onPressed: () => _insertMarkdown('`', '`')
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               Text(
                '$_wordCount words · $_charCount chars',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.warmGray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 20, color: AppColors.warmGray),
      ),
    );
  }
}
