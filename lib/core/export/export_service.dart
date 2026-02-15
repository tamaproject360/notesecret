import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:notesecret/core/database/models/note.dart';

class ExportService {
  // Export single note to Markdown
  Future<String> exportToMarkdown(Note note) async {
    final buffer = StringBuffer();
    
    buffer.writeln('# ${note.title.isEmpty ? "Untitled" : note.title}');
    buffer.writeln('');
    buffer.writeln('---');
    buffer.writeln('');
    buffer.writeln(note.body);
    buffer.writeln('');
    buffer.writeln('---');
    buffer.writeln('');
    buffer.writeln('*Created: ${note.createdAt.toLocal()}*');
    buffer.writeln('*Updated: ${note.updatedAt.toLocal()}*');
    
    return buffer.toString();
  }

  // Export single note to Plain Text
  Future<String> exportToPlainText(Note note) async {
    final buffer = StringBuffer();
    
    buffer.writeln(note.title.isEmpty ? "Untitled" : note.title);
    buffer.writeln('=' * (note.title.isEmpty ? 8 : note.title.length));
    buffer.writeln('');
    buffer.writeln(note.body);
    buffer.writeln('');
    buffer.writeln('---');
    buffer.writeln('Created: ${note.createdAt.toLocal()}');
    buffer.writeln('Updated: ${note.updatedAt.toLocal()}');
    
    return buffer.toString();
  }

  // Save and share note
  Future<void> shareNote(Note note, String format) async {
    String content;
    String fileName;
    String mimeType;

    switch (format) {
      case 'markdown':
        content = await exportToMarkdown(note);
        fileName = '${_sanitizeFileName(note.title)}.md';
        mimeType = 'text/markdown';
        break;
      case 'txt':
      default:
        content = await exportToPlainText(note);
        fileName = '${_sanitizeFileName(note.title)}.txt';
        mimeType = 'text/plain';
        break;
    }

    // Save to temporary directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(content);

    // Share file
    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      subject: note.title.isEmpty ? 'Untitled Note' : note.title,
    );
  }

  // Export multiple notes
  Future<void> exportMultipleNotes(List<Note> notes, String format) async {
    final buffer = StringBuffer();

    for (var i = 0; i < notes.length; i++) {
      final note = notes[i];
      
      if (format == 'markdown') {
        buffer.writeln(await exportToMarkdown(note));
      } else {
        buffer.writeln(await exportToPlainText(note));
      }

      if (i < notes.length - 1) {
        buffer.writeln('');
        buffer.writeln('━' * 50);
        buffer.writeln('');
      }
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = format == 'markdown' 
        ? 'notes_export.md' 
        : 'notes_export.txt';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles(
      [XFile(file.path, mimeType: format == 'markdown' ? 'text/markdown' : 'text/plain')],
      subject: 'NoteSecret Export - ${notes.length} notes',
    );
  }

  String _sanitizeFileName(String title) {
    if (title.isEmpty) return 'untitled';
    
    // Remove invalid filename characters
    return title
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase()
        .substring(0, title.length > 50 ? 50 : title.length);
  }
}
