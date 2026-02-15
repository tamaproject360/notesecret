import 'package:isar/isar.dart';

part 'folder.g.dart';

@collection
class Folder {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String name;

  String? emoji;

  int sortOrder = 0;

  late DateTime createdAt;
}
