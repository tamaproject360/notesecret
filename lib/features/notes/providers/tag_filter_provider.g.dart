// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredNotesByTagHash() =>
    r'2b9d82e6ef1bc1d6ce511e93d143dd83d97d8e40';

/// See also [filteredNotesByTag].
@ProviderFor(filteredNotesByTag)
final filteredNotesByTagProvider =
    AutoDisposeFutureProvider<List<Note>>.internal(
  filteredNotesByTag,
  name: r'filteredNotesByTagProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredNotesByTagHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredNotesByTagRef = AutoDisposeFutureProviderRef<List<Note>>;
String _$selectedTagFilterHash() => r'59db5ede19c815d77239ef6dbb5f7cc5a43039a3';

/// See also [SelectedTagFilter].
@ProviderFor(SelectedTagFilter)
final selectedTagFilterProvider =
    AutoDisposeNotifierProvider<SelectedTagFilter, Tag?>.internal(
  SelectedTagFilter.new,
  name: r'selectedTagFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTagFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTagFilter = AutoDisposeNotifier<Tag?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
