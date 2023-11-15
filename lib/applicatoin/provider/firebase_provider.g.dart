// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseHash() => r'e1893b3bd86714f94db5eb4bb54d1731e5e6a6fa';

/// See also [firebase].
@ProviderFor(firebase)
final firebaseProvider = AutoDisposeProvider<FirebaseFirestore>.internal(
  firebase,
  name: r'firebaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$converterHash() => r'2b434316d5bca77607baad87582c0f28bb878ffb';

/// See also [converter].
@ProviderFor(converter)
final converterProvider =
    AutoDisposeProvider<CollectionReference<User>>.internal(
  converter,
  name: r'converterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$converterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConverterRef = AutoDisposeProviderRef<CollectionReference<User>>;
String _$userHash() => r'a0659ef785c22fb5459747b871e5782b63c0862d';

/// See also [user].
@ProviderFor(user)
final userProvider = AutoDisposeStreamProvider<List<User>>.internal(
  user,
  name: r'userProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRef = AutoDisposeStreamProviderRef<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
