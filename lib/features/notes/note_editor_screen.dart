import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notesecret/app/theme/color_scheme.dart';
import 'package:notesecret/app/theme/typography.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/core/database/repositories/tag_repository.dart';
import 'package:notesecret/core/notifications/notification_service.dart';
import 'package:notesecret/features/folders/providers/folder_provider.dart';
import 'package:notesecret/features/notes/providers/note_provider.dart';
import 'package:notesecret/shared/utils/file_helper.dart';
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
  List<String> _attachments = [];
  DateTime? _reminderDate;
  List<Tag> _selectedTags = [];
  String _noteColor = '';
  int? _selectedFolderId;
  String? _selectedFolderName;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      final note = await ref.read(noteProvider(widget.noteId!).future);
      if (note != null) {
        // Load tags
        await note.tags.load();
        
        if (mounted) {
          setState(() {
            _currentNote = note;
            _titleController.text = note.title;
            _bodyController.text = note.body;
            _attachments = List.from(note.attachments ?? []);
            _reminderDate = note.reminderAt;
            _selectedTags = note.tags.toList();
            _noteColor = note.color;
            _selectedFolderId = note.folderId;
            _updateCounts();
            _isLoading = false;
          });
          // Load folder name if exists
          if (_selectedFolderId != null) {
            _loadFolderName();
          }
        }
      } else {
         if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFolderName() async {
    if (_selectedFolderId != null) {
      final folder = await ref.read(folderProvider(_selectedFolderId!).future);
      if (folder != null && mounted) {
        setState(() {
          _selectedFolderName = folder.name;
        });
      }
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

  Future<void> _pickImage() async {
    try {
      final String? path = await FileHelper.pickImage();
      if (path != null) {
        setState(() {
          _attachments.add(path);
          _isDirty = true;
        });
        _saveNote();
      }
    } catch (e) {
      if (mounted) AppToast.show(context, 'Failed to pick image');
    }
  }

  Future<void> _removeAttachment(int index) async {
    setState(() {
      _attachments.removeAt(index);
      _isDirty = true;
    });
    _saveNote();
  }

  Future<void> _manageTags() async {
    final tagRepo = ref.read(tagRepositoryProvider);
    final allTags = await tagRepo.getAllTags();
    
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manage Tags', style: AppTypography.headingMedium),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: allTags.map((tag) {
                            final isSelected = _selectedTags.any((t) => t.id == tag.id);
                            return FilterChip(
                              label: Text(tag.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.removeWhere((t) => t.id == tag.id);
                                  }
                                });
                                setState(() => _isDirty = true);
                              },
                              backgroundColor: AppColors.sageGreen.withOpacity(0.1),
                              selectedColor: AppColors.sageGreen.withOpacity(0.3),
                              checkmarkColor: AppColors.sageGreen,
                              labelStyle: TextStyle(
                                color: isSelected ? AppColors.sageGreen : AppColors.deepCharcoal,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(LucideIcons.plus),
                    title: const Text('Create New Tag'),
                    onTap: () async {
                      Navigator.pop(context); // Close sheet first
                      _showCreateTagDialog(tagRepo);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    _saveNote();
  }

  Future<void> _showCreateTagDialog(TagRepository repo) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Tag Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await repo.createTag(controller.text.trim(), '#6B7F5E'); // Default color
                if (mounted) Navigator.pop(context);
                _manageTags(); // Re-open tag manager
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFolder() async {
    final foldersAsync = ref.read(allFoldersProvider);
    
    await foldersAsync.when(
      data: (folders) async {
        if (!mounted) return;
        
        await showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Folder', style: AppTypography.headingMedium),
                  const SizedBox(height: 16),
                  if (_selectedFolderId != null)
                    ListTile(
                      leading: const Icon(LucideIcons.folderX, color: AppColors.terracotta),
                      title: const Text('Remove from folder'),
                      onTap: () {
                        setState(() {
                          _selectedFolderId = null;
                          _selectedFolderName = null;
                          _isDirty = true;
                        });
                        Navigator.pop(context);
                        _saveNote();
                      },
                    ),
                  const Divider(),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final isSelected = _selectedFolderId == folder.id;
                        return ListTile(
                          leading: Text(
                            folder.emoji ?? '📁',
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(folder.name),
                          trailing: isSelected 
                              ? const Icon(LucideIcons.check, color: AppColors.sageGreen)
                              : null,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedFolderId = folder.id;
                              _selectedFolderName = folder.name;
                              _isDirty = true;
                            });
                            Navigator.pop(context);
                            _saveNote();
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
      loading: () {},
      error: (e, st) {
        if (mounted) AppToast.show(context, 'Failed to load folders');
      },
    );
  }

  Future<void> _selectColor() async {
    final colors = [
      {'name': 'None', 'hex': ''},
      {'name': 'Red', 'hex': '#EF4444'},
      {'name': 'Orange', 'hex': '#F97316'},
      {'name': 'Yellow', 'hex': '#F59E0B'},
      {'name': 'Green', 'hex': '#10B981'},
      {'name': 'Blue', 'hex': '#3B82F6'},
      {'name': 'Purple', 'hex': '#8B5CF6'},
      {'name': 'Pink', 'hex': '#EC4899'},
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Color', style: AppTypography.headingMedium),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((colorData) {
                  final colorHex = colorData['hex'] as String;
                  final colorName = colorData['name'] as String;
                  final isSelected = _noteColor == colorHex;
                  
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _noteColor = colorHex;
                        _isDirty = true;
                      });
                      Navigator.pop(context);
                      _saveNote();
                    },
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorHex.isEmpty 
                            ? Colors.grey.withOpacity(0.2)
                            : Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.sageGreen : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          colorName,
                          style: TextStyle(
                            color: colorHex.isEmpty || colorHex == '#F59E0B' 
                                ? AppColors.deepCharcoal 
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setReminder() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderDate ?? now.add(const Duration(minutes: 10))),
      );

      if (time != null) {
        final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          _reminderDate = dateTime;
          _isDirty = true;
        });
        
        if (_currentNote != null) {
          // Schedule notification
          await NotificationService().scheduleNotification(
            id: _currentNote!.id,
            title: _titleController.text.isNotEmpty ? _titleController.text : 'Note Reminder',
            body: _bodyController.text.isNotEmpty 
                ? (_bodyController.text.length > 50 ? '${_bodyController.text.substring(0, 50)}...' : _bodyController.text) 
                : 'Tap to view note',
            scheduledDate: dateTime,
          );
          AppToast.show(context, 'Reminder set for ${DateFormat('MMM d, h:mm a').format(dateTime)}');
        }
        _saveNote();
      }
    }
  }

  Future<void> _saveNote() async {
    if (!_isDirty && _currentNote != null) return;
    if (_titleController.text.isEmpty && _bodyController.text.isEmpty && _attachments.isEmpty) return;

    final repository = await ref.read(noteRepositoryProvider.future);
    
    final note = _currentNote ?? Note()
      ..title = _titleController.text
      ..body = _bodyController.text
      ..color = _currentNote?.color ?? '' // Default no color
      ..createdAt = DateTime.now();

    // Update fields
    note.title = _titleController.text;
    note.body = _bodyController.text;
    note.attachments = _attachments;
    note.reminderAt = _reminderDate;
    note.color = _noteColor;
    note.folderId = _selectedFolderId;
    note.updatedAt = DateTime.now();
    
    // Update tags
    note.tags.clear();
    note.tags.addAll(_selectedTags);

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
      // Cancel reminder if exists
      if (_currentNote!.reminderAt != null) {
        await NotificationService().cancelNotification(_currentNote!.id);
      }
      
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
          IconButton(
            icon: Icon(
              _reminderDate != null ? LucideIcons.bellRing : LucideIcons.bell,
              color: _reminderDate != null ? AppColors.sageGreen : null,
            ),
            onPressed: _setReminder,
            tooltip: 'Set Reminder',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _deleteNote();
              if (value == 'lock') _toggleLock();
              if (value == 'pin') _togglePin();
              if (value == 'tags') _manageTags();
              if (value == 'folder') _selectFolder();
              if (value == 'color') _selectColor();
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
                value: 'folder',
                child: Row(
                  children: [
                    const Icon(LucideIcons.folder, size: 18, color: AppColors.deepCharcoal),
                    const SizedBox(width: 12),
                    Text(_selectedFolderName != null ? 'Folder: $_selectedFolderName' : 'Move to Folder'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'tags',
                child: Row(
                  children: [
                    const Icon(LucideIcons.tag, size: 18, color: AppColors.deepCharcoal),
                    const SizedBox(width: 12),
                    Text('Tags (${_selectedTags.length})'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'color',
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.palette, 
                      size: 18, 
                      color: _noteColor.isNotEmpty 
                          ? Color(int.parse(_noteColor.substring(1), radix: 16) + 0xFF000000)
                          : AppColors.deepCharcoal,
                    ),
                    const SizedBox(width: 12),
                    const Text('Color'),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
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
                    
                    // Tags Display
                    if (_selectedTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _selectedTags.map((tag) => Chip(
                            label: Text(tag.name, style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppColors.sageGreen.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ),
                      
                    // Reminder Display
                    if (_reminderDate != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: InkWell(
                          onTap: _setReminder,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.sageGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.clock, size: 14, color: AppColors.sageGreen),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('MMM d, h:mm a').format(_reminderDate!),
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.sageGreen),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _reminderDate = null;
                                      _isDirty = true;
                                    });
                                    if (_currentNote != null) {
                                      NotificationService().cancelNotification(_currentNote!.id);
                                    }
                                  },
                                  child: const Icon(LucideIcons.x, size: 14, color: AppColors.sageGreen),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Attachments Display
                    if (_attachments.isNotEmpty)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: _attachments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_attachments[index]),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () => _removeAttachment(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(LucideIcons.x, size: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    // Body Input
                    Padding(
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
                      ),
                    ),
                    const SizedBox(height: 100), // Bottom padding for toolbar
                  ],
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
                onPressed: _pickImage,
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
