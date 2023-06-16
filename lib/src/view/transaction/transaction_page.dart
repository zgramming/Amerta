import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart';
import '../../utils/routers.dart';
import '../../utils/styles.dart';
import '../widgets/transaction_list_item.dart';
import 'widgets/modal_transaction_filter.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TransactionHeader(),
          TransactionList(),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final futureTransaction = ref.watch(transactionNotifier).items;
              return futureTransaction.when(
                data: (transactions) {
                  return ListView.builder(
                    itemCount: transactions.length,
                    padding: const EdgeInsets.only(
                      bottom: 60.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionListItem(
                        id: transaction.id,
                        title: transaction.title,
                        amount: transaction.amount,
                        startDate: transaction.startDate,
                        endDate: transaction.endDate,
                        personName: transaction.personName,
                        type: transaction.typeTransaction,
                        createdAt: transaction.createdAt,
                      );
                    },
                  );
                },
                error: (e, s) => Center(child: Text(e.toString())),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(formTransactionRoute, pathParameters: {
                  'id': '0',
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Transaksi"),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({
    super.key,
  });

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
          const SizedBox(height: 10.0),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const ModalFilterTransaction(),
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
    );
  }
}
