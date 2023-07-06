import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/database/database.dart';
import 'model/database/helper.dart';
import 'model/model/parameter_transaction_by_person_type_model.dart';
import 'model/model/payment_model.dart';
import 'model/model/person_model.dart';
import 'model/model/person_summary_transaction_model.dart';
import 'model/model/transaction_detail_model.dart';
import 'model/model/transaction_model.dart';
import 'model/model/transaction_summary_model.dart';
import 'model/repository/export_repository.dart';
import 'model/repository/import_repository.dart';
import 'model/repository/payment_repository.dart';
import 'model/repository/pdf_report_repository.dart';
import 'model/repository/person_repository.dart';
import 'model/repository/transaction_repository.dart';
import 'model/service/export_service.dart';
import 'model/service/import_service.dart';
import 'model/service/payment_service.dart';
import 'model/service/pdf_report_service.dart';
import 'model/service/person_service.dart';
import 'model/service/transaction_service.dart';
import 'view_model/export_notifier.dart';
import 'view_model/import_notifier.dart';
import 'view_model/payment_notifier.dart';
import 'view_model/pdf_report_notifier.dart';
import 'view_model/person_notifier.dart';
import 'view_model/shared/shared_provider.dart';
import 'view_model/transaction_notifier.dart';

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

final getTransactionByType = AutoDisposeFutureProviderFamily<
    List<TransactionModel>,
    ParameterTransactionByPersonTypeModel>((ref, param) async {
  final repo = ref.watch(_transactionRepository);
  final result = await repo.getTransactionByPersonAndType(
    param.personId,
    type: param.type,
  );
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
    AutoDisposeFutureProviderFamily<PersonSummaryTransactionModel, int>(
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

final importNotifier = StateNotifierProvider<ImportNotifier, ImportState>(
  (ref) => ImportNotifier(
    repository: ref.watch(_importRepository),
  ),
);
final exportNotifier = StateNotifierProvider<ExportNotifier, ExportState>(
  (ref) => ExportNotifier(
    repository: ref.watch(_exportRepository),
  ),
);
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
  (ref) => PersonNotifier(
    repository: ref.watch(_personRepository),
    filter: ref.watch(personFilterProvider),
  ),
);

final _importRepository = Provider(
  (ref) => ImportRepository(
    service: ref.watch(_importServiceProvider),
  ),
);
final _exportRepository = Provider(
  (ref) => ExportRepository(
    exportService: ref.watch(_exportServiceProvider),
  ),
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

final _importServiceProvider = Provider(
  (ref) => ImportService(databaseHelper: ref.watch(_databaseHelper)),
);
final _exportServiceProvider = Provider(
  (ref) => ExportService(databaseHelper: ref.watch(_databaseHelper)),
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
