import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_basic/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firebase_provider.g.dart';

@riverpod
FirebaseFirestore firebase(FirebaseRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
CollectionReference<User> converter(ConverterRef ref) {
  return ref.watch(firebaseProvider).collection('users').withConverter(fromFirestore: (snapshot, _) {
    final data = snapshot.data()!;
    final id = snapshot.id;
    // データがない場合は、空のUserをidだけセットして返す
    if (data.isEmpty) return const User(id: '');
    data['id'] = id;
    return User.fromJson(data);
  }, toFirestore: (user, _) {
    return user.toJson();
  });
}

@riverpod
Stream<List<User>> user(UserRef ref) {
  return ref.watch(converterProvider).snapshots().map((snapshot) {
    final users = snapshot.docs.map((doc) => doc.data()).toList();
    return users;
  });
}
