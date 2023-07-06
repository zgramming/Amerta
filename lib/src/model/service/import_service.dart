// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import '../database/helper.dart';
import '../model/export_data_model.dart';

class ImportService {
  final DatabaseHelper databaseHelper;
  ImportService({
    required this.databaseHelper,
  });

  Future<String> import(File file) async {
    final readFile = await file.readAsString();
    final decodedFile = Map<String, dynamic>.from(jsonDecode(readFile));

    // Check if map have key persons||transactions||payments
    final isHavePersons = decodedFile.containsKey('persons');
    final isHaveTransactions = decodedFile.containsKey('transactions');
    final isHavePayments = decodedFile.containsKey('payments');

    if (!isHavePersons && !isHaveTransactions && !isHavePayments) {
      throw Exception('File tidak valid');
    }

    final decodePerson = jsonDecode(decodedFile['persons']);
    final decodeTransaction = jsonDecode(decodedFile['transactions']);
    final decodePayment = jsonDecode(decodedFile['payments']);

    if (decodePerson is! List ||
        decodeTransaction is! List ||
        decodePayment is! List) {
      throw Exception('Tipe data tidak valid');
    }

    final persons =
        decodePerson.map((e) => ExportedPersonModel.fromJson(e)).toList();
    final transactions = decodeTransaction
        .map((e) => ExportedTransactionModel.fromJson(e))
        .toList();
    final payments =
        decodePayment.map((e) => ExportedPaymentModel.fromJson(e)).toList();

    final model = ExportDataModel(
      persons: persons,
      transactions: transactions,
      payments: payments,
    );

    final result = await databaseHelper.importData(model);

    return result;
  }
}
