// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteRepositoryHash() => r'313bb20903fdc082824d79d3eb3fa2c74b1e8253';

/// See also [noteRepository].
@ProviderFor(noteRepository)
final noteRepositoryProvider = FutureProvider<NoteRepository>.internal(
  noteRepository,
  name: r'noteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteRepositoryRef = FutureProviderRef<NoteRepository>;
String _$allNotesHash() => r'f6a152d6b50cb73821f03c05664409a3a1f63ed5';

/// See also [allNotes].
@ProviderFor(allNotes)
final allNotesProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  allNotes,
  name: r'allNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllNotesRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$pinnedNotesHash() => r'4ad4ac5d3a21c6351b807e5a8e2e94c678040edb';

/// See also [pinnedNotes].
@ProviderFor(pinnedNotes)
final pinnedNotesProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  pinnedNotes,
  name: r'pinnedNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pinnedNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PinnedNotesRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$normalNotesHash() => r'6113f248f0686e056030ebd7bcfaf433014108ec';

/// See also [normalNotes].
@ProviderFor(normalNotes)
final normalNotesProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  normalNotes,
  name: r'normalNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$normalNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NormalNotesRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$noteHash() => r'986748b0b77022644dafba9020d3f48950ebe10c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [note].
@ProviderFor(note)
const noteProvider = NoteFamily();

/// See also [note].
class NoteFamily extends Family<AsyncValue<Note?>> {
  /// See also [note].
  const NoteFamily();

  /// See also [note].
  NoteProvider call(
    int id,
  ) {
    return NoteProvider(
      id,
    );
  }

  @override
  NoteProvider getProviderOverride(
    covariant NoteProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'noteProvider';
}

/// See also [note].
class NoteProvider extends AutoDisposeFutureProvider<Note?> {
  /// See also [note].
  NoteProvider(
    int id,
  ) : this._internal(
          (ref) => note(
            ref as NoteRef,
            id,
          ),
          from: noteProvider,
          name: r'noteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$noteHash,
          dependencies: NoteFamily._dependencies,
          allTransitiveDependencies: NoteFamily._allTransitiveDependencies,
          id: id,
        );

  NoteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Note?> Function(NoteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoteProvider._internal(
        (ref) => create(ref as NoteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Note?> createElement() {
    return _NoteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteRef on AutoDisposeFutureProviderRef<Note?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _NoteProviderElement extends AutoDisposeFutureProviderElement<Note?>
    with NoteRef {
  _NoteProviderElement(super.provider);

  @override
  int get id => (origin as NoteProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
