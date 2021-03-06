import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/model/database/query/payment_query.dart';
import 'src/model/database/query/people_query.dart';
import 'src/model/database/query/transaction_query.dart';
import 'src/model/repository/payment_repository.dart';
import 'src/model/repository/people_repository.dart';
import 'src/model/repository/transaction_repository.dart';
import 'src/model/service/local/payment_local_service.dart';
import 'src/model/service/local/people_local_service.dart';
import 'src/model/service/local/transaction_local_service.dart';
import 'src/view_model/payment/payment_action_notifier.dart';
import 'src/view_model/people/people_action_notifier.dart';
import 'src/view_model/transaction/print_transaction_notifier.dart';
import 'src/view_model/transaction/transaction_action_notifier.dart';

///* [Payment Section]

final paymentLocalService = Provider(
  (ref) => PaymentLocalService(query: ref.watch(paymentTableQuery)),
);

final paymentRepository = Provider(
  (ref) => PaymentRepository(localService: ref.watch(paymentLocalService)),
);

final paymentActionNotifier =
    StateNotifierProvider.autoDispose<PaymentActionNotifier, PaymentActionState>(
  (ref) => PaymentActionNotifier(repository: ref.watch(paymentRepository)),
);

///* [Transaction Section]

final transactionLocalService = Provider(
  (ref) => TransactionLocalService(
    query: ref.watch(transactionTableQuery),
    paymentQuery: ref.watch(paymentTableQuery),
    peopleQuery: ref.watch(peopleTableQuery),
  ),
);

final transactionRepository = Provider(
    (ref) => TransactionRepository(transactionLocalService: ref.watch(transactionLocalService)));

final transactionActionNotifier =
    StateNotifierProvider.autoDispose<TransactionActionNotifier, TransactionActionState>((ref) {
  return TransactionActionNotifier(repository: ref.watch(transactionRepository));
});

///* [Print Transaction Section]

final printTransactionNotifier =
    StateNotifierProvider.autoDispose<PrintTransactionNotifier, PrintTransactionState>(
  (ref) => PrintTransactionNotifier(repository: ref.watch(transactionRepository)),
);

///* [People Section]

final peopleLocalService = Provider<PeopleLocalService>(
  (ref) => PeopleLocalService(query: ref.watch(peopleTableQuery)),
);

final peopleRepository = Provider(
  (ref) => PeopleRepository(peopleLocalService: ref.watch(peopleLocalService)),
);

final peopleActionNotifier =
    StateNotifierProvider.autoDispose<PeopleActionNotifier, PeopleActionState>((ref) {
  return PeopleActionNotifier(ref.watch(peopleRepository));
});

///* [TABLE LOCAL DATABASE Section]

final peopleTableQuery = Provider<PeopleTableQuery>((ref) => PeopleTableQuery());
final transactionTableQuery = Provider<TransactionTableQuery>(
  (ref) => TransactionTableQuery(peopleQuery: ref.watch(peopleTableQuery)),
);
final paymentTableQuery = Provider<PaymentTableQuery>((ref) => PaymentTableQuery());
