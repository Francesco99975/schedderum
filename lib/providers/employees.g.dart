// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employees.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeesHash() => r'db5aff284a0f23d7973ec5069513b75694e810ef';

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
