import 'package:isar/isar.dart';
import 'package:notesecret/core/database/models/folder.dart';

class FolderRepository {
  final Isar _isar;

  FolderRepository(this._isar);

  // Create or Update Folder
  Future<void> saveFolder(Folder folder) async {
    await _isar.writeTxn(() async {
      if (folder.id == Isar.autoIncrement) {
        folder.createdAt = DateTime.now();
      }
      await _isar.folders.put(folder);
    });
  }

  // Delete Folder
  Future<void> deleteFolder(int id) async {
    await _isar.writeTxn(() async {
      await _isar.folders.delete(id);
    });
  }

  // Get Single Folder
  Future<Folder?> getFolder(int id) async {
    return await _isar.folders.get(id);
  }

  // Watch All Folders
  Stream<List<Folder>> watchAllFolders() {
    return _isar.folders
        .where()
        .sortBySortOrder()
        .watch(fireImmediately: true);
  }

  // Get All Folders (for one-time fetch)
  Future<List<Folder>> getAllFolders() async {
    return await _isar.folders
        .where()
        .sortBySortOrder()
        .findAll();
  }

  // Update Folder Order (for drag-and-drop)
  Future<void> updateFolderOrder(List<Folder> folders) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < folders.length; i++) {
        folders[i].sortOrder = i;
        await _isar.folders.put(folders[i]);
      }
    });
  }
}
