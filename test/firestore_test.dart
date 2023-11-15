import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firestore_test.g.dart';

final firebaseProvider =
    Provider<FakeFirebaseFirestore>((ref) => FakeFirebaseFirestore());

@riverpod
FakeFirebaseFirestore fakeFirebaseFirestore(FakeFirebaseFirestoreRef ref) {
  return FakeFirebaseFirestore();
}

void main() {
  group('Firestore Test', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore instance;

    setUp(() {
      container = ProviderContainer();
      instance = container.read(firebaseProvider);
      instance.collection('users').doc('test').delete();
    });

    tearDown(() {
      container.dispose();
    });

    test('データを追加したらテストが通る', () async {
      await instance.collection('users').doc('test').set({'name': 'test'});
      var snapshot = await instance.collection('users').doc('test').get();
      expect(snapshot.data(), isNotNull);
      expect(snapshot.data()!['name'], 'test');
    });

    test('例外処理が発生したらテストが通る', () async {
      try {
        await instance.collection('users').doc('nonexistent').get();
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
