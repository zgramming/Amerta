import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart';
import '../../model/model/person_model.dart';
import '../../utils/fonts.dart';
import '../../utils/functions.dart';
import '../../utils/routers.dart';
import '../../utils/styles.dart';
import 'widgets/modal_action_person.dart';
import 'widgets/modal_print_transaction_person.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PersonHeader(),
          PersonList(),
        ],
      ),
    );
  }
}

class PersonList extends ConsumerWidget {
  const PersonList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(personNotifier);
            },
            child: Builder(
              builder: (_) {
                final futurePerson = ref.watch(personNotifier);
                return futurePerson.asyncItems.when(
                  data: (persons) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 60.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      itemCount: persons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemBuilder: (context, index) {
                        final person = persons[index];
                        return PersonListItem(person: person);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  formPersonRoute,
                  pathParameters: {
                    "id": "0",
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Orang"),
            ),
          )
        ],
      ),
    );
  }
}

class PersonListItem extends StatelessWidget {
  const PersonListItem({
    Key? key,
    required this.person,
  }) : super(key: key);

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    final initialName = FunctionUtils.getFirstLetters(person.name);

    return Stack(
      fit: StackFit.expand,
      children: [
        Card(
          margin: const EdgeInsets.only(),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              context.pushNamed(personDetailRoute, pathParameters: {
                "id": "${person.id}",
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(initialName),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      person.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: lato.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return ModalActionPerson(person: person);
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        )
      ],
    );
  }
}

class _PersonHeader extends StatelessWidget {
  const _PersonHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: inputDecorationRounded().copyWith(
                hintText: "Cari sesuatu",
                contentPadding: const EdgeInsets.all(10.0),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
            ),
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ModalPrintTransactionPerson());
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
    );
  }
}
