# firebase_basic

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_basic/domain/user.dart';
// このimport文を追加する
import 'package:riverpod_annotation/riverpod_annotation.dart';
// ファイル名と同じ名前の後に、.g.dartとつける。
// part '[ファイル名].g.dart';
part 'firebase_provider.g.dart';

// @riverpodアノテーションをつける。自動で、autoDisposeされる。
// Stateを破棄したくないときは、@Riverpod(keepAlive: true)を使う。
@riverpod
FirebaseFirestore firebase(FirebaseRef ref) {
  return FirebaseFirestore.instance;
}

// 状態を破棄しないプロバイダーを生成する。
@Riverpod(keepAlive: true)
FirebaseFirestore firebase(FirebaseRef ref) {
  return FirebaseFirestore.instance;
}

// withConverterをriverpod generatorで使うときはこのように書く。
// これでデータを型安全に扱える。documentIDを今回は、使いたいので、使ってみた。
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

// StreamProviderが関数になった感じ。.toListまで書くとListViewのところで書くコードが短くなる。
@riverpod
Stream<List<User>> user(UserRef ref) {
  return ref.watch(converterProvider).snapshots().map((snapshot) {
    final users = snapshot.docs.map((doc) => doc.data()).toList();
    return users;
  });
}
```

## generatorを使わない例
以前はこのように作成していた。なんとかProviderが複数ある。最近だと自動生成してくれて、書く必要がなくなった。
```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/post/post.dart';

// Firebaseを利用するためのProvider
final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

// メソッドで使用するWithConverter
final postReferenceWithConverter = Provider.autoDispose((ref) {
  return ref.watch(firebaseProvider).collection('post').withConverter(
        fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
        toFirestore: (post, _) => post.toJson(),
      );
});


final poseRefStreamProvider = Provider.autoDispose((ref) {
  return ref.watch(firebaseProvider).collection('post').withConverter<Post?>(// Post? とすることでデータがない場合はnullを返す
      fromFirestore: (ds, _) {
        final data = ds.data();// sanpshot.data()! と同じ
        final id = ds.id;// sanpshot.id と同じ

        if (data == null) {// データがない場合はnullを返す
          return null;
        }
        data['id'] = id;// idを追加
        return Post.fromJson(data);
      },
      toFirestore: (value, _) {
        return value?.toJson() ?? {};// valueがnullの場合は空のMapを返す
      });
});

// 作成した順に取得するためのStreamProvider
final postRefStream = StreamProvider.autoDispose((ref) {
  return ref.watch(poseRefStreamProvider).orderBy('createdAt').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList();
  });
});
```


デメリットがあるとしたら、どこのプロバイダーか、ジャンプしたときに、特定できない？
普通のプロバイダーなら、command + クリックで、ジャンプして、userProviderだとか、定義されているプロバイダーのファイルに移動できる。
generatorだと、自動生成されたファイルにジャンプするので、特定しにくい。でも同じディレクトリにプロバイダーのファイルがあるので問題ない気がする？
