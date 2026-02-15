import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notesecret/core/database/database_provider.dart';
import 'package:notesecret/core/database/models/note.dart';
import 'package:notesecret/core/database/repositories/note_repository.dart';

part 'search_provider.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
Stream<List<Note>> searchResults(SearchResultsRef ref) async* {
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) {
    yield [];
    return;
  }

  final repository = await ref.watch(noteRepositoryProvider.future);
  yield* repository.searchNotes(query);
}
