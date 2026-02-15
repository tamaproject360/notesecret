import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/core/database/models/folder.dart';

class BackupService {
  // Generate AES-256 encrypted backup
  Future<File> createEncryptedBackup({
    required List<Note> notes,
    required List<Folder> folders,
    required String password,
  }) async {
    // Prepare backup data
    final backupData = {
      'version': '1.0.0',
      'timestamp': DateTime.now().toIso8601String(),
      'notes': notes.map((note) => {
        'id': note.id,
        'title': note.title,
        'body': note.body,
        'color': note.color,
        'isPinned': note.isPinned,
        'isLocked': note.isLocked,
        'createdAt': note.createdAt.toIso8601String(),
        'updatedAt': note.updatedAt.toIso8601String(),
        'deletedAt': note.deletedAt?.toIso8601String(),
      }).toList(),
      'folders': folders.map((folder) => {
        'id': folder.id,
        'name': folder.name,
        'emoji': folder.emoji,
        'sortOrder': folder.sortOrder,
        'createdAt': folder.createdAt.toIso8601String(),
      }).toList(),
    };

    final jsonData = jsonEncode(backupData);

    // Encrypt with AES-256
    final key = encrypt.Key.fromUtf8(password.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    final encrypted = encrypter.encrypt(jsonData, iv: iv);
    final encryptedData = '${iv.base64}:${encrypted.base64}';

    // Save to file
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/notesecret_backup_$timestamp.notesecret');
    await file.writeAsString(encryptedData);

    return file;
  }

  // Share backup file
  Future<void> shareBackup(File backupFile) async {
    await Share.shareXFiles(
      [XFile(backupFile.path)],
      subject: 'NoteSecret Backup - ${DateTime.now().toString().split(' ')[0]}',
      text: 'Encrypted backup created by NoteSecret. Keep this file safe and remember your password!',
    );
  }

  // Restore from encrypted backup
  Future<Map<String, dynamic>> restoreFromBackup({
    required String encryptedData,
    required String password,
  }) async {
    try {
      // Parse IV and encrypted data
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid backup file format');
      }

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

      // Decrypt
      final key = encrypt.Key.fromUtf8(password.padRight(32, '0').substring(0, 32));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      final backupData = jsonDecode(decrypted) as Map<String, dynamic>;

      return backupData;
    } catch (e) {
      throw Exception('Failed to restore backup. Wrong password or corrupted file.');
    }
  }

  // Convert backup data to Note objects
  List<Note> parseNotes(List<dynamic> notesData) {
    return notesData.map((data) {
      final note = Note()
        ..title = data['title'] ?? ''
        ..body = data['body'] ?? ''
        ..color = data['color'] ?? ''
        ..isPinned = data['isPinned'] ?? false
        ..isLocked = data['isLocked'] ?? false
        ..createdAt = DateTime.parse(data['createdAt'])
        ..updatedAt = DateTime.parse(data['updatedAt']);
      
      if (data['deletedAt'] != null) {
        note.deletedAt = DateTime.parse(data['deletedAt']);
      }
      
      return note;
    }).toList();
  }

  // Convert backup data to Folder objects
  List<Folder> parseFolders(List<dynamic> foldersData) {
    return foldersData.map((data) {
      return Folder()
        ..name = data['name']
        ..emoji = data['emoji']
        ..sortOrder = data['sortOrder'] ?? 0
        ..createdAt = DateTime.parse(data['createdAt']);
    }).toList();
  }
}
