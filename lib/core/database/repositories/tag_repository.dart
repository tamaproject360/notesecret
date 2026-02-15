import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/models/note.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider).valueOrNull;
  if (isar == null) throw UnimplementedError('Database not initialized');
  return TagRepository(isar);
});

class TagRepository {
  final Isar _isar;

  TagRepository(this._isar);

  Future<Tag> createTag(String name, String color) async {
    final tag = Tag()
      ..name = name
      ..color = color
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.tags.put(tag);
    });
    
    return tag;
  }

  Future<List<Tag>> getAllTags() async {
    return await _isar.tags.where().sortByName().findAll();
  }

  Future<void> deleteTag(int id) async {
    await _isar.writeTxn(() async {
      await _isar.tags.delete(id);
    });
  }
  
  Stream<List<Tag>> watchTags() {
    return _isar.tags.where().sortByName().watch(fireImmediately: true);
  }
}
