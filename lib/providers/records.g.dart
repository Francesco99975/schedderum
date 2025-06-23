// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'records.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recordsHash() => r'364bce5e5b3c659193ebddd07af5341a1ce8838d';

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

abstract class _$Records
    extends
        BuildlessAutoDisposeAsyncNotifier<
          Either<Failure, List<DisplayRecord>>
        > {
  late final String departmentId;
  late final DateTime weekStart;
  late final DateTime weekEnd;

  FutureOr<Either<Failure, List<DisplayRecord>>> build(
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  );
}

/// See also [Records].
@ProviderFor(Records)
const recordsProvider = RecordsFamily();

/// See also [Records].
class RecordsFamily
    extends Family<AsyncValue<Either<Failure, List<DisplayRecord>>>> {
  /// See also [Records].
  const RecordsFamily();

  /// See also [Records].
  RecordsProvider call(
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    return RecordsProvider(departmentId, weekStart, weekEnd);
  }

  @override
  RecordsProvider getProviderOverride(covariant RecordsProvider provider) {
    return call(provider.departmentId, provider.weekStart, provider.weekEnd);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordsProvider';
}

/// See also [Records].
class RecordsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          Records,
          Either<Failure, List<DisplayRecord>>
        > {
  /// See also [Records].
  RecordsProvider(String departmentId, DateTime weekStart, DateTime weekEnd)
    : this._internal(
        () =>
            Records()
              ..departmentId = departmentId
              ..weekStart = weekStart
              ..weekEnd = weekEnd,
        from: recordsProvider,
        name: r'recordsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$recordsHash,
        dependencies: RecordsFamily._dependencies,
        allTransitiveDependencies: RecordsFamily._allTransitiveDependencies,
        departmentId: departmentId,
        weekStart: weekStart,
        weekEnd: weekEnd,
      );

  RecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.departmentId,
    required this.weekStart,
    required this.weekEnd,
  }) : super.internal();

  final String departmentId;
  final DateTime weekStart;
  final DateTime weekEnd;

  @override
  FutureOr<Either<Failure, List<DisplayRecord>>> runNotifierBuild(
    covariant Records notifier,
  ) {
    return notifier.build(departmentId, weekStart, weekEnd);
  }

  @override
  Override overrideWith(Records Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecordsProvider._internal(
        () =>
            create()
              ..departmentId = departmentId
              ..weekStart = weekStart
              ..weekEnd = weekEnd,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        departmentId: departmentId,
        weekStart: weekStart,
        weekEnd: weekEnd,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    Records,
    Either<Failure, List<DisplayRecord>>
  >
  createElement() {
    return _RecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordsProvider &&
        other.departmentId == departmentId &&
        other.weekStart == weekStart &&
        other.weekEnd == weekEnd;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, departmentId.hashCode);
    hash = _SystemHash.combine(hash, weekStart.hashCode);
    hash = _SystemHash.combine(hash, weekEnd.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecordsRef
    on
        AutoDisposeAsyncNotifierProviderRef<
          Either<Failure, List<DisplayRecord>>
        > {
  /// The parameter `departmentId` of this provider.
  String get departmentId;

  /// The parameter `weekStart` of this provider.
  DateTime get weekStart;

  /// The parameter `weekEnd` of this provider.
  DateTime get weekEnd;
}

class _RecordsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          Records,
          Either<Failure, List<DisplayRecord>>
        >
    with RecordsRef {
  _RecordsProviderElement(super.provider);

  @override
  String get departmentId => (origin as RecordsProvider).departmentId;
  @override
  DateTime get weekStart => (origin as RecordsProvider).weekStart;
  @override
  DateTime get weekEnd => (origin as RecordsProvider).weekEnd;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
