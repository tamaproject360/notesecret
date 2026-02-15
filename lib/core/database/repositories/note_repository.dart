import 'package:isar/isar.dart';
import 'package:notesecret/core/database/models/note.dart';

class NoteRepository {
  final Isar _isar;

  NoteRepository(this._isar);

  Future<void> saveNote(Note note) async {
    await _isar.writeTxn(() async {
      note.updatedAt = DateTime.now();
      if (note.id == Isar.autoIncrement) {
        note.createdAt = DateTime.now();
      }
      await _isar.notes.put(note);
    });
  }

  Future<void> deleteNote(int id) async {
    await _isar.writeTxn(() async {
      final note = await _isar.notes.get(id);
      if (note != null) {
        note.deletedAt = DateTime.now();
        await _isar.notes.put(note);
      }
    });
  }

  Future<void> restoreNote(int id) async {
    await _isar.writeTxn(() async {
      final note = await _isar.notes.get(id);
      if (note != null) {
        note.deletedAt = null;
        await _isar.notes.put(note);
      }
    });
  }

  Future<void> permanentDeleteNote(int id) async {
    await _isar.writeTxn(() async {
      await _isar.notes.delete(id);
    });
  }

  Future<Note?> getNote(int id) async {
    return await _isar.notes.get(id);
  }

  Stream<List<Note>> watchAllNotes({bool includeDeleted = false}) {
    if (includeDeleted) {
      return _isar.notes
          .where()
          .sortByUpdatedAtDesc()
          .watch(fireImmediately: true);
    } else {
      return _isar.notes
          .filter()
          .deletedAtIsNull()
          .sortByUpdatedAtDesc()
          .watch(fireImmediately: true);
    }
  }

  Stream<List<Note>> watchPinnedNotes() {
    return _isar.notes
        .filter()
        .deletedAtIsNull()
        .isPinnedEqualTo(true)
        .isLockedEqualTo(false)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }
  
  Stream<List<Note>> watchNormalNotes() {
    return _isar.notes
        .filter()
        .deletedAtIsNull()
        .isPinnedEqualTo(false)
        .isLockedEqualTo(false)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<Note>> watchLockedNotes() {
    return _isar.notes
        .filter()
        .deletedAtIsNull()
        .isLockedEqualTo(true)
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) return [];
    
    return await _isar.notes
        .filter()
        .deletedAtIsNull()
        .and()
        .group((q) => q
            .titleContains(query, caseSensitive: false)
            .or()
            .bodyContains(query, caseSensitive: false))
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Future<void> togglePin(int id) async {
    await _isar.writeTxn(() async {
      final note = await _isar.notes.get(id);
      if (note != null) {
        note.isPinned = !note.isPinned;
        await _isar.notes.put(note);
      }
    });
  }

  Future<void> toggleLock(int id) async {
    await _isar.writeTxn(() async {
      final note = await _isar.notes.get(id);
      if (note != null) {
        note.isLocked = !note.isLocked;
        await _isar.notes.put(note);
      }
    });
  }
}
