import 'package:firebase_basic/applicatoin/provider/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserView extends ConsumerWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Basic'),
      ),
      body: const UserData(),
    );
  }
}

class UserData extends ConsumerWidget {
  const UserData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return switch (user) {
      AsyncError(:final error) => Text('Error: $error'),
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final data = value[index];
            return ListTile(
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await ref.read(converterProvider).doc(data.id).delete();
                },
              ),
              title: Text(data.name),
              subtitle: Text(data.email),
            );
          },
        ),
      _ => const CircularProgressIndicator(),
    };
  }
}
