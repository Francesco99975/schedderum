// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeesByDepartmentHash() =>
    r'44df38e0f93b7492ba73f37d57bceb38caed1794';

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

/// See also [employeesByDepartment].
@ProviderFor(employeesByDepartment)
const employeesByDepartmentProvider = EmployeesByDepartmentFamily();

/// See also [employeesByDepartment].
class EmployeesByDepartmentFamily
    extends Family<AsyncValue<Either<Failure, List<model.Employee>>>> {
  /// See also [employeesByDepartment].
  const EmployeesByDepartmentFamily();

  /// See also [employeesByDepartment].
  EmployeesByDepartmentProvider call(String departmentId) {
    return EmployeesByDepartmentProvider(departmentId);
  }

  @override
  EmployeesByDepartmentProvider getProviderOverride(
    covariant EmployeesByDepartmentProvider provider,
  ) {
    return call(provider.departmentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'employeesByDepartmentProvider';
}

/// See also [employeesByDepartment].
class EmployeesByDepartmentProvider
    extends AutoDisposeFutureProvider<Either<Failure, List<model.Employee>>> {
  /// See also [employeesByDepartment].
  EmployeesByDepartmentProvider(String departmentId)
    : this._internal(
        (ref) => employeesByDepartment(
          ref as EmployeesByDepartmentRef,
          departmentId,
        ),
        from: employeesByDepartmentProvider,
        name: r'employeesByDepartmentProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$employeesByDepartmentHash,
        dependencies: EmployeesByDepartmentFamily._dependencies,
        allTransitiveDependencies:
            EmployeesByDepartmentFamily._allTransitiveDependencies,
        departmentId: departmentId,
      );

  EmployeesByDepartmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.departmentId,
  }) : super.internal();

  final String departmentId;

  @override
  Override overrideWith(
    FutureOr<Either<Failure, List<model.Employee>>> Function(
      EmployeesByDepartmentRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeesByDepartmentProvider._internal(
        (ref) => create(ref as EmployeesByDepartmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        departmentId: departmentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Either<Failure, List<model.Employee>>>
  createElement() {
    return _EmployeesByDepartmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeesByDepartmentProvider &&
        other.departmentId == departmentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, departmentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EmployeesByDepartmentRef
    on AutoDisposeFutureProviderRef<Either<Failure, List<model.Employee>>> {
  /// The parameter `departmentId` of this provider.
  String get departmentId;
}

class _EmployeesByDepartmentProviderElement
    extends
        AutoDisposeFutureProviderElement<Either<Failure, List<model.Employee>>>
    with EmployeesByDepartmentRef {
  _EmployeesByDepartmentProviderElement(super.provider);

  @override
  String get departmentId =>
      (origin as EmployeesByDepartmentProvider).departmentId;
}

String _$employeesHash() => r'1282c8592d21413f077a1e0511105998e7e4df4d';

/// See also [Employees].
@ProviderFor(Employees)
final employeesProvider = AutoDisposeAsyncNotifierProvider<
  Employees,
  Either<Failure, List<model.Employee>>
>.internal(
  Employees.new,
  name: r'employeesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$employeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Employees =
    AutoDisposeAsyncNotifier<Either<Failure, List<model.Employee>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
