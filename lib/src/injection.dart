import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/database/database.dart';
import 'model/database/helper.dart';
import 'model/model/payment_model.dart';
import 'model/model/person_model.dart';
import 'model/model/person_summary_transaction.dart';
import 'model/model/transaction_detail_model.dart';
import 'model/model/transaction_model.dart';
import 'model/model/transaction_summary_model.dart';
import 'model/service/payment_service.dart';
import 'model/service/pdf_report_service.dart';
import 'model/service/person_service.dart';
import 'model/service/transaction_service.dart';
import 'utils/enums.dart';
import 'view_model/shared/shared_provider.dart';

// Future Provider
// Section 1: Transaction

final getTransactionById =
    AutoDisposeFutureProviderFamily<TransactionDetailModel?, int>(
        (ref, id) async {
  final repo = ref.watch(_transactionRepository);
  final result = await repo.getById(id: id);
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

final getRecentTransaction =
    AutoDisposeFutureProvider<List<TransactionModel>>((ref) async {
  final repo = ref.watch(_transactionRepository);
  final result = await repo.getRecentTransaction();
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

final getTransactionByType =
    AutoDisposeFutureProviderFamily<List<TransactionModel>, TypeTransaction>(
        (ref, type) async {
  final repo = ref.watch(_transactionRepository);
  final result = await repo.getTransactionByType(type: type);
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

final getSummaryTransaction =
    AutoDisposeFutureProvider<TransactionSummaryModel>((ref) async {
  final repo = ref.watch(_transactionRepository);
  final result = await repo.getSummaryTransaction(
    filter: ref.watch(transactionFilterProvider),
  );
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

// Section 2: Person

final getPersonSummaryTransaction =
    AutoDisposeFutureProviderFamily<PersonSummaryTransaction, int>(
        (ref, personId) async {
  final repo = ref.watch(_personRepository);
  final result = await repo.getSummaryTransaction(personId);
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

final getPersonById =
    AutoDisposeFutureProviderFamily<PersonModel?, int>((ref, id) async {
  final repo = ref.watch(_personRepository);
  final result = await repo.getById(id);
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

// Section 3: Payment

final getPaymentById =
    AutoDisposeFutureProviderFamily<PaymentModel?, int>((ref, id) async {
  final repo = ref.watch(_paymentRepository);
  final result = await repo.getById(id);
  return result.fold(
    (l) => throw l.message,
    (r) => r,
  );
});

// FINISH FUTURE PROVIDER SECTION

final pdfReportNotifier = StateNotifierProvider<PDFReportNotifier, File?>(
  (ref) => PDFReportNotifier(
    repository: ref.watch(_pdfReportRepository),
  ),
);
final paymentNotifier =
    StateNotifierProviderFamily<PaymentNotifier, PaymentState, int>(
  (ref, transactionId) => PaymentNotifier(
    repository: ref.watch(_paymentRepository),
    transactionId: transactionId,
  ),
);
final transactionNotifier =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(
    repository: ref.watch(_transactionRepository),
    filter: ref.watch(transactionFilterProvider),
  ),
);
final personNotifier = StateNotifierProvider<PersonNotifier, PersonState>(
  (ref) => PersonNotifier(repository: ref.watch(_personRepository)),
);

final _pdfReportRepository = Provider(
  (ref) => PDFReportRepository(
    pdfReportService: ref.watch(_pdfReportServiceProvider),
  ),
);
final _paymentRepository = Provider(
  (ref) =>
      PaymentRepository(paymentService: ref.watch(_paymentServiceProvider)),
);
final _transactionRepository = Provider(
  (ref) =>
      TransactionRepository(service: ref.watch(_transactionServiceProvider)),
);
final _personRepository = Provider(
  (ref) => PersonRepository(service: ref.watch(_personServiceProvider)),
);

final _pdfReportServiceProvider = Provider((ref) => PDFReportService(
      databaseHelper: ref.watch(_databaseHelper),
    ));
final _paymentServiceProvider = Provider(
  (ref) => PaymentService(databaseHelper: ref.watch(_databaseHelper)),
);
final _transactionServiceProvider = Provider(
  (ref) => TransactionService(databaseHelper: ref.watch(_databaseHelper)),
);
final _personServiceProvider = Provider(
  (ref) => PersonService(databaseHelper: ref.watch(_databaseHelper)),
);

final _databaseHelper = Provider(
  (ref) => DatabaseHelper(database: ref.watch(myDatabaseProvider)),
);

final myDatabaseProvider =
    Provider<MyDatabase>((ref) => throw UnimplementedError());
