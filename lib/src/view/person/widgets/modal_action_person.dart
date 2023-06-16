import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../../../model/model/person_model.dart';
import '../../../utils/routers.dart';

class ModalActionPerson extends ConsumerWidget {
  const ModalActionPerson({
    super.key,
    required this.person,
  });

  final PersonModel person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(personNotifier.select((value) => value.onDelete),
        (previous, next) {
      if (next is AsyncData) {
        context.pop();
      }
    });
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.only(),
            child: ListTile(
              onTap: () {
                context.pop();
                context.pushNamed(
                  formPersonRoute,
                  pathParameters: {"id": "${person.id}"},
                );
              },
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Edit"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 10.0),
          Card(
            margin: const EdgeInsets.only(),
            child: ListTile(
              onTap: () {
                ref.read(personNotifier.notifier).delete(person.id);
              },
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Hapus"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
