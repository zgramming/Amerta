import 'dart:developer';

import 'package:drift/drift.dart';

import '../../utils/enums.dart';
import '../model/form_payment_model.dart';
import '../model/form_transaction_model.dart';
import '../model/payment_model.dart';
import '../model/pdf_report_filter_model.dart';
import '../model/pdf_report_model.dart';
import '../model/person_model.dart';
import '../model/person_summary_transaction_model.dart';
import '../model/transaction_detail_model.dart';
import '../model/transaction_filter_model.dart';
import '../model/transaction_model.dart';
import '../model/transaction_summary_model.dart';
import 'database.dart';

class DatabaseHelper {
  final MyDatabase database;

  const DatabaseHelper({
    required this.database,
  });

  // PDF Report Section

  Future<List<PDFReportModel>> getAllReportPDF({
    required PDFReportFilterModel filter,
  }) async {
    String filterQuery = "";

    if (filter.type == PrintTrxType.hutang) {
      filterQuery = "AND t.type = 'hutang'";
    } else if (filter.type == PrintTrxType.piutang) {
      filterQuery = "AND t.type = 'piutang'";
    }

    final query = database.customSelect(
      """
      SELECT 
        t.id,
        t.title,
        t.type,
        t.amount,
        t.description,
        t.start_date,
        t.end_date,
        t.created_at,
        t.updated_at,
        p.id as person_id,
        p.name as person_name,
        (SELECT COALESCE(SUM(amount), 0) FROM payment WHERE transaction_id = t.id) as payment_amount
      FROM "transaction" t
      INNER JOIN person p ON p.id = t.person_id
      WHERE t.id IS NOT NULL
      $filterQuery
""",
      readsFrom: {
        database.transactionTable,
        database.personTable,
        database.paymentTable,
      },
    );

    final result = await query.get();

    final mapping = result
        .map(
          (e) => PDFReportModel(
            title: e.read<String>("title"),
            personName: e.read<String>("person_name"),
            amount: e.read<double>("amount"),
            startDate: e.read<DateTime>("start_date"),
            endDate: e.read<DateTime>("end_date"),
            type: e.read<String>("type") == "hutang"
                ? TypeTransaction.hutang
                : TypeTransaction.piutang,
            paid: e.read<double?>("payment_amount") ?? 0,
          ),
        )
        .toList();
    return mapping;
  }

  Future<List<PDFReportModel>> getReportPDFByPerson(
    int personId, {
    required PDFReportFilterModel filter,
  }) async {
    String filterQuery = "";

    if (filter.type == PrintTrxType.hutang) {
      filterQuery = "AND t.type = 'hutang'";
    } else if (filter.type == PrintTrxType.piutang) {
      filterQuery = "AND t.type = 'piutang'";
    }

    final query = database.customSelect(
      """
      SELECT 
        t.id,
        t.title,
        t.type,
        t.amount,
        t.description,
        t.start_date,
        t.end_date,
        t.created_at,
        t.updated_at,
        p.id as person_id,
        p.name as person_name,
        (SELECT COALESCE(SUM(amount), 0) FROM payment WHERE transaction_id = t.id) as payment_amount
      FROM "transaction" t
      INNER JOIN person p ON p.id = t.person_id
      WHERE p.id = ? 
      $filterQuery
""",
      variables: [
        Variable.withInt(personId),
      ],
      readsFrom: {
        database.transactionTable,
        database.personTable,
        database.paymentTable,
      },
    );

    final result = await query.get();

    final mapping = result.map(
      (e) {
        return PDFReportModel(
          amount: e.read<double>("amount"),
          endDate: e.read<DateTime>("end_date"),
          personName: e.read<String>("person_name"),
          startDate: e.read<DateTime>("start_date"),
          title: e.read<String>("title"),
          type: e.read<String>("type") == "hutang"
              ? TypeTransaction.hutang
              : TypeTransaction.piutang,
          paid: e.read<double?>("payment_amount") ?? 0,
        );
      },
    ).toList();

    return mapping;
  }

  Future<List<PDFReportModel>> getReportPDFDetailTransaction({
    required int transactionId,
  }) async {
    final tempList = <PDFReportModel>[];

    final query = database.customSelect(
      """
      SELECT 
        t.id,
        t.title,
        t.type,
        t.amount,
        t.description,
        t.start_date,
        t.end_date,
        t.created_at,
        t.updated_at,
        p.id as person_id,
        p.name as person_name,
        (SELECT COALESCE(SUM(amount), 0) FROM payment WHERE transaction_id = t.id) as payment_amount
      FROM "transaction" t
      INNER JOIN person p ON p.id = t.person_id
      WHERE t.id = ?
""",
      variables: [
        Variable.withInt(transactionId),
      ],
      readsFrom: {
        database.transactionTable,
        database.personTable,
        database.paymentTable,
      },
    );

    final result = await query.getSingleOrNull();

    if (result == null) return tempList;

    final mapping = PDFReportModel(
      title: result.read<String>("title"),
      type: result.read<String>("type") == "hutang"
          ? TypeTransaction.hutang
          : TypeTransaction.piutang,
      amount: result.read<double>("amount"),
      startDate: result.read<DateTime>("start_date"),
      endDate: result.read<DateTime>("end_date"),
      personName: result.read<String>("person_name"),
      paid: result.read<double?>("payment_amount") ?? 0,
    );

    tempList.add(mapping);

    return tempList;
  }

  // Payment Section
  Future<List<PaymentModel>> getAllPayment(int transactionId) async {
    final query = database.select(database.paymentTable)
      ..where((payment) => payment.transactionId.equals(transactionId))
      ..orderBy([
        (payment) => OrderingTerm.desc(payment.updatedAt),
      ]);

    final result = await query.get();
    final mapping = result
        .map(
          (e) => PaymentModel(
            id: e.id,
            transactionId: e.transactionId,
            personId: e.personId,
            amount: e.amount,
            description: e.description,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
    return mapping;
  }

  Future<PaymentModel?> getPaymentById(int paymentId) async {
    final query = database.select(database.paymentTable)
      ..where((payment) => payment.id.equals(paymentId));

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    final mapping = PaymentModel(
      id: result.id,
      transactionId: result.transactionId,
      personId: result.personId,
      amount: result.amount,
      description: result.description,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );

    return mapping;
  }

  Future<int> savePayment(FormPaymentModel payment) async {
    final summaryPaymentQuery = (await database.customSelect(
        "SELECT SUM(amount) as amount FROM payment WHERE transaction_id = ?",
        variables: [Variable.withInt(payment.transactionId)],
        readsFrom: {database.paymentTable}).getSingle());

    final transactionDetail = await getTransactionById(payment.transactionId);

    if (transactionDetail == null) {
      throw Exception("Transaksi tidak ditemukan");
    }

    final currentPaymentAmount =
        summaryPaymentQuery.read<double?>("amount") ?? 0;
    final estimateTotalPaymentAmount = currentPaymentAmount + payment.amount;

    final isExceed = estimateTotalPaymentAmount > transactionDetail.amount;

    if (isExceed) {
      throw Exception("Pembayaran melebihi total transaksi");
    }

    final now = DateTime.now();
    final query = database.into(database.paymentTable).insert(
          PaymentTableCompanion(
            transactionId: Value(payment.transactionId),
            amount: Value(payment.amount),
            description: Value(payment.description),
            createdAt: Value(now),
            updatedAt: Value(now),
            personId: Value(transactionDetail.personId),
          ),
        );

    final result = await query;
    return result;
  }

  Future<int> updatePayment(FormPaymentModel payment) async {
    if (payment.id == null) throw Exception("Id tidak boleh kosong");

    final query = database.update(database.paymentTable)
      ..where((p) => p.id.equals(payment.id!));

    final now = DateTime.now();
    final result = await query.write(
      PaymentTableCompanion(
        amount: Value(payment.amount),
        description: Value(payment.description),
        updatedAt: Value(now),
      ),
    );
    return result;
  }

  Future<int> deletePayment(int id) async {
    final query = database.delete(database.paymentTable)
      ..where((p) => p.id.equals(id));

    final result = await query.go();
    return result;
  }

  // Transaction Section

  Future<List<TransactionModel>> getAllTransaction(
    TransactionFilterModel filter,
  ) async {
    final isBiggerThanStartDate = database.transactionTable.startDate
        .isBiggerOrEqualValue(filter.startDate);
    final isSmallerThanEndDate =
        database.transactionTable.endDate.isSmallerOrEqualValue(filter.endDate);

    var query = database.select(database.transactionTable).join([
      innerJoin(
        database.personTable,
        database.personTable.id.equalsExp(
          database.transactionTable.personId,
        ),
      )
    ])
      ..orderBy([OrderingTerm.desc(database.transactionTable.updatedAt)])
      ..where(isBiggerThanStartDate & isSmallerThanEndDate);

    log("Filter Type: ${filter.startDate} - ${filter.endDate}");
    if (filter.typeTransaction != null) {
      query.where(
        database.transactionTable.type.equals(
          filter.typeTransaction == TypeTransaction.hutang
              ? "hutang"
              : "piutang",
        ),
      );
    }

    final result = await query.get();

    final mapping = result.map(
      (e) {
        final transaction = e.readTable(database.transactionTable);
        final person = e.readTable(database.personTable);
        return TransactionModel(
          id: transaction.id,
          personId: transaction.personId,
          title: transaction.title,
          amount: transaction.amount,
          description: transaction.description,
          startDate: transaction.startDate,
          endDate: transaction.endDate,
          typeTransaction: transaction.type == "hutang"
              ? TypeTransaction.hutang
              : TypeTransaction.piutang,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
          personName: person.name,
        );
      },
    ).toList();

    return mapping;
  }

  Future<List<TransactionModel>> getTransactionByPersonAndType(
    int personId, {
    required TypeTransaction type,
  }) async {
    final isHutang = type == TypeTransaction.hutang;
    final query = database.select(database.transactionTable).join([
      innerJoin(
        database.personTable,
        database.personTable.id.equalsExp(
          database.transactionTable.personId,
        ),
      )
    ])
      ..where(database.transactionTable.type
          .equals(isHutang ? "hutang" : "piutang"))
      ..where(database.transactionTable.personId.equals(personId))
      ..orderBy(
        [
          OrderingTerm.desc(database.transactionTable.updatedAt),
        ],
      );

    final result = await query.get();
    final mapping = result.map(
      (e) {
        final transaction = e.readTable(database.transactionTable);
        final person = e.readTable(database.personTable);
        return TransactionModel(
          id: transaction.id,
          personId: transaction.personId,
          title: transaction.title,
          amount: transaction.amount,
          description: transaction.description,
          startDate: transaction.startDate,
          endDate: transaction.endDate,
          typeTransaction: transaction.type == "hutang"
              ? TypeTransaction.hutang
              : TypeTransaction.piutang,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
          personName: person.name,
        );
      },
    ).toList();

    return mapping;
  }

  Future<List<TransactionModel>> getRecentTransaction() async {
    final query = database.select(database.transactionTable).join([
      innerJoin(
        database.personTable,
        database.personTable.id.equalsExp(
          database.transactionTable.personId,
        ),
      )
    ])
      ..orderBy(
        [
          OrderingTerm.desc(database.transactionTable.updatedAt),
        ],
      )
      ..limit(5);

    final result = await query.get();
    final mapping = result.map(
      (e) {
        final transaction = e.readTable(database.transactionTable);
        final person = e.readTable(database.personTable);
        return TransactionModel(
          id: transaction.id,
          personId: transaction.personId,
          title: transaction.title,
          amount: transaction.amount,
          description: transaction.description,
          startDate: transaction.startDate,
          endDate: transaction.endDate,
          typeTransaction: transaction.type == "hutang"
              ? TypeTransaction.hutang
              : TypeTransaction.piutang,
          createdAt: transaction.createdAt,
          updatedAt: transaction.updatedAt,
          personName: person.name,
        );
      },
    ).toList();

    return mapping;
  }

  Future<TransactionSummaryModel> getSummaryTransaction() async {
    final query = database.customSelect(
      """
    SELECT
      SUM(CASE WHEN t.type = 'hutang' THEN t.amount ELSE 0 END) as total_amount_hutang,
      SUM(CASE WHEN t.type = 'piutang' THEN t.amount ELSE 0 END) as total_amount_piutang,
      SUM(t.amount) as total_transaction,
      COUNT(t.id) as count_transaction,
      (SELECT SUM(p.amount) FROM payment p INNER JOIN "transaction" trx ON (p.transaction_id = trx.id) WHERE trx.type = 'hutang') as payment_hutang,
      (SELECT SUM(p.amount) FROM payment p INNER JOIN "transaction" trx ON (p.transaction_id = trx.id) WHERE trx.type = 'piutang') as payment_piutang
    FROM "transaction" t
""",
      readsFrom: {
        database.transactionTable,
      },
    );

    final result = await query.getSingle();

    final totalHutang = result.read<double?>("total_amount_hutang") ?? 0;
    final totalPiutang = result.read<double?>("total_amount_piutang") ?? 0;
    final totalTransaction = result.read<double?>("total_transaction") ?? 0;
    final countTransaction = result.read<int>("count_transaction");
    final paymentHutang = result.read<double?>("payment_hutang") ?? 0;
    final paymentPiutang = result.read<double?>("payment_piutang") ?? 0;

    final totalHutangWithPayment = totalHutang - paymentHutang;
    final totalPiutangWithPayment = totalPiutang - paymentPiutang;

    final mapping = TransactionSummaryModel(
      totalHutang: totalHutang,
      totalPiutang: totalPiutang,
      totalTransaction: totalTransaction,
      countTransaction: countTransaction,
      totalHutangWithPayment: totalHutangWithPayment,
      totalPiutangWithPayment: totalPiutangWithPayment,
    );

    return mapping;
  }

  Future<TransactionDetailModel?> getTransactionById(int transactionId) async {
    final query = database.customSelect(
      """
      SELECT 
        t.id,
        t.title,
        t.type,
        t.amount,
        t.description,
        t.start_date,
        t.end_date,
        t.created_at,
        t.updated_at,
        p.id as person_id,
        p.name as person_name,
        (SELECT SUM(amount) FROM payment WHERE transaction_id = t.id) as payment_amount
      FROM "transaction" t
      INNER JOIN person p ON p.id = t.person_id
      WHERE t.id = ?
""",
      variables: [
        Variable.withInt(transactionId),
      ],
      readsFrom: {
        database.transactionTable,
        database.personTable,
        database.paymentTable,
      },
    );

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    final id = result.read<int>("id");
    final title = result.read<String>("title");
    final typeTransaction = result.read<String>("type") == "hutang"
        ? TypeTransaction.hutang
        : TypeTransaction.piutang;
    final amount = result.read<double>("amount");
    final description = result.read<String?>("description");
    final startDate = result.read<DateTime>("start_date");
    final endDate = result.read<DateTime>("end_date");
    final createdAt = result.read<DateTime>("created_at");
    final personId = result.read<int>("person_id");
    final personName = result.read<String>("person_name");
    final paymentAmount = result.read<double?>("payment_amount") ?? 0;

    final mapping = TransactionDetailModel(
      id: id,
      title: title,
      typeTransaction: typeTransaction,
      amount: amount,
      description: description,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      personId: personId,
      personName: personName,
      paid: paymentAmount,
      remaining: amount - paymentAmount,
    );

    return mapping;
  }

  Future<int> saveTransaction(FormTransactionModel form) async {
    final now = DateTime.now();
    final fixedNow = DateTime(now.year, now.month, now.day);
    final query = database.into(database.transactionTable).insert(
          TransactionTableCompanion(
            personId: Value(form.personId),
            title: Value(form.title),
            amount: Value(form.amount),
            description: Value(form.description),
            startDate: Value(form.startDate),
            endDate: Value(form.endDate),
            type: Value(
              form.typeTransaction == TypeTransaction.hutang
                  ? "hutang"
                  : "piutang",
            ),
            createdAt: Value(fixedNow),
            updatedAt: Value(fixedNow),
          ),
        );

    final result = await query;
    return result;
  }

  Future<int> updateTransaction(FormTransactionModel form) async {
    if (form.id == null) throw Exception("Id tidak boleh kosong");

    final now = DateTime.now();
    final fixedNow = DateTime(now.year, now.month, now.day);
    final query = database.update(database.transactionTable)
      ..where((trx) => trx.id.equals(form.id!));

    final result = await query.write(
      TransactionTableCompanion(
        personId: Value(form.personId),
        title: Value(form.title),
        amount: Value(form.amount),
        description: Value(form.description),
        startDate: Value(form.startDate),
        endDate: Value(form.endDate),
        type: Value(
          form.typeTransaction == TypeTransaction.hutang ? "hutang" : "piutang",
        ),
        updatedAt: Value(fixedNow),
      ),
    );
    return result;
  }

  // Person Section
  Future<List<PersonModel>> getAllPerson() async {
    final result = await database.select(database.personTable).get();
    final mapping = result
        .map(
          (e) => PersonModel(
            id: e.id,
            name: e.name,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
    return mapping;
  }

  Future<PersonModel?> getPersonById(int id) async {
    final query = database.select(database.personTable)
      ..where((person) => person.id.equals(id));

    final result = await query.getSingleOrNull();

    if (result == null) return null;

    final mapping = PersonModel(
      id: result.id,
      name: result.name,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
    );

    return mapping;
  }

  Future<PersonSummaryTransactionModel> getPersonSummaryTransaction(
    int personId,
  ) async {
    final query = database.customSelect(
      """
    SELECT
      p.id as person_id,
      p.name as person_name,
      SUM(CASE WHEN t.type = 'hutang' THEN t.amount ELSE 0 END) as total_amount_hutang,
      SUM(CASE WHEN t.type = 'piutang' THEN t.amount ELSE 0 END) as total_amount_piutang,
      COUNT(CASE WHEN t.type = 'hutang' THEN t.id ELSE NULL END) as total_count_hutang,
      COUNT(CASE WHEN t.type = 'piutang' THEN t.id ELSE NULL END) as total_count_piutang
    FROM person p
    LEFT JOIN "transaction" t ON t.person_id = p.id
    WHERE p.id = ?
    GROUP BY p.id, p.name
""",
      variables: [
        Variable(personId),
      ],
      readsFrom: {
        database.personTable,
        database.transactionTable,
      },
    );

    final result = await query.getSingle();

    final personId0 = result.read<int>("person_id");
    final personName = result.read<String>("person_name");
    final totalAmountHutang = result.read<double>("total_amount_hutang");
    final totalAmountPiutang = result.read<double>("total_amount_piutang");
    final totalCountHutang = result.read<int?>("total_count_hutang") ?? 0;
    final totalCountPiutang = result.read<int?>("total_count_piutang") ?? 0;

    final mapping = PersonSummaryTransactionModel(
      personId: personId0,
      personName: personName,
      totalAmountHutang: totalAmountHutang,
      totalAmountPiutang: totalAmountPiutang,
      totalCountHutang: totalCountHutang,
      totalCountPiutang: totalCountPiutang,
    );

    return mapping;
  }

  Future<int> savePerson(PersonModel person) async {
    final query = database.into(database.personTable).insert(
          PersonTableCompanion(
            name: Value(person.name.trim()),
            createdAt: Value(person.createdAt),
            updatedAt: Value(person.updatedAt),
          ),
        );

    final result = await query;
    return result;
  }

  Future<int> updatePerson(PersonModel person) async {
    final query = database.update(database.personTable)
      ..where((p) => p.id.equals(person.id));

    final result = await query.write(
      PersonTableCompanion(
        name: Value(person.name.trim()),
        updatedAt: Value(person.updatedAt),
      ),
    );
    return result;
  }

  Future<int> deletePerson(int id) async {
    final query = database.delete(database.personTable)
      ..where((p) => p.id.equals(id));

    final result = await query.go();
    return result;
  }
}
