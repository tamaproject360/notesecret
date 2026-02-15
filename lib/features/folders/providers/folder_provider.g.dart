// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$folderRepositoryHash() => r'46a98a3b20eeff284a487454e051a496b7236fdf';

/// See also [folderRepository].
@ProviderFor(folderRepository)
final folderRepositoryProvider = FutureProvider<FolderRepository>.internal(
  folderRepository,
  name: r'folderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$folderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FolderRepositoryRef = FutureProviderRef<FolderRepository>;
String _$allFoldersHash() => r'2dcae44e7c8fdcbdf38a7a465c5f755d64f1e681';

/// See also [allFolders].
@ProviderFor(allFolders)
final allFoldersProvider = AutoDisposeStreamProvider<List<Folder>>.internal(
  allFolders,
  name: r'allFoldersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allFoldersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllFoldersRef = AutoDisposeStreamProviderRef<List<Folder>>;
String _$folderHash() => r'5f1f85927ea043608b4e867177185262a85658fa';

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

/// See also [folder].
@ProviderFor(folder)
const folderProvider = FolderFamily();

/// See also [folder].
class FolderFamily extends Family<AsyncValue<Folder?>> {
  /// See also [folder].
  const FolderFamily();

  /// See also [folder].
  FolderProvider call(
    int id,
  ) {
    return FolderProvider(
      id,
    );
  }

  @override
  FolderProvider getProviderOverride(
    covariant FolderProvider provider,
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
  String? get name => r'folderProvider';
}

/// See also [folder].
class FolderProvider extends AutoDisposeFutureProvider<Folder?> {
  /// See also [folder].
  FolderProvider(
    int id,
  ) : this._internal(
          (ref) => folder(
            ref as FolderRef,
            id,
          ),
          from: folderProvider,
          name: r'folderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$folderHash,
          dependencies: FolderFamily._dependencies,
          allTransitiveDependencies: FolderFamily._allTransitiveDependencies,
          id: id,
        );

  FolderProvider._internal(
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
    FutureOr<Folder?> Function(FolderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FolderProvider._internal(
        (ref) => create(ref as FolderRef),
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
  AutoDisposeFutureProviderElement<Folder?> createElement() {
    return _FolderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FolderProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FolderRef on AutoDisposeFutureProviderRef<Folder?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FolderProviderElement extends AutoDisposeFutureProviderElement<Folder?>
    with FolderRef {
  _FolderProviderElement(super.provider);

  @override
  int get id => (origin as FolderProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
