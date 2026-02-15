import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesecret/core/backup/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService();
});
