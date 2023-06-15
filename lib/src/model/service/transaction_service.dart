import '../../utils/enums.dart';
import '../database/helper.dart';
import '../model/form_transaction_model.dart';
import '../model/transaction_detail_model.dart';
import '../model/transaction_filter_model.dart';
import '../model/transaction_model.dart';
import '../model/transaction_summary_model.dart';

class TransactionService {
  final DatabaseHelper databaseHelper;
  const TransactionService({
    required this.databaseHelper,
  });

  Future<List<TransactionModel>> getAll({
    required TransactionFilterModel filter,
  }) async {
    return await databaseHelper.getAllTransaction(filter);
  }

  Future<TransactionDetailModel?> getById({
    required int id,
  }) async {
    return await databaseHelper.getTransactionById(id);
  }

  Future<List<TransactionModel>> getRecentTransaction() async {
    return await databaseHelper.getRecentTransaction();
  }

  Future<List<TransactionModel>> getTransactionByPersonAndType(
    int personId, {
    required TypeTransaction type,
  }) async {
    return await databaseHelper.getTransactionByPersonAndType(personId,
        type: type);
  }

  Future<TransactionSummaryModel> getSummaryTransaction(
    TransactionFilterModel filter,
  ) async {
    return await databaseHelper.getSummaryTransaction();
  }

  Future<String> insert({
    required FormTransactionModel transaction,
  }) async {
    final result = await databaseHelper.saveTransaction(transaction);
    return "Transaction has been saved with id: $result";
  }

  Future<String> update({
    required FormTransactionModel transaction,
  }) async {
    final result = await databaseHelper.updateTransaction(transaction);
    return "Transaction has been updated with id: $result";
  }
}
