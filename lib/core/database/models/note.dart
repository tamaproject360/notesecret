import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String title;

  @Index(type: IndexType.value, caseSensitive: false)
  late String body;

  late String color; // Hex string

  bool isPinned = false;

  bool isLocked = false;

  int? folderId;

  final tags = IsarLinks<Tag>();

  List<String>? attachments; // Paths to local files

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt; // For soft delete

  DateTime? reminderAt; // For notifications
}

@collection
class Tag {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String name;

  late String color; // Hex string

  late DateTime createdAt;
}
