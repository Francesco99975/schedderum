// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentDepartmentHash() => r'9aab44f024d95107057132566faa23fe3500a1b9';

/// See also [CurrentDepartment].
@ProviderFor(CurrentDepartment)
final currentDepartmentProvider = AutoDisposeAsyncNotifierProvider<
  CurrentDepartment,
  Option<model.Department>
>.internal(
  CurrentDepartment.new,
  name: r'currentDepartmentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentDepartmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentDepartment =
    AutoDisposeAsyncNotifier<Option<model.Department>>;
String _$departmentsHash() => r'ea946cfae0720fa798056a180b20929a80f7afdd';

/// See also [Departments].
@ProviderFor(Departments)
final departmentsProvider = AutoDisposeAsyncNotifierProvider<
  Departments,
  Either<Failure, List<model.Department>>
>.internal(
  Departments.new,
  name: r'departmentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$departmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Departments =
    AutoDisposeAsyncNotifier<Either<Failure, List<model.Department>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
