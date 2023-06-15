import 'package:dartz/dartz.dart';

import '../../utils/enums.dart';
import '../../utils/failure.dart';
import '../model/form_transaction_model.dart';
import '../model/transaction_detail_model.dart';
import '../model/transaction_filter_model.dart';
import '../model/transaction_model.dart';
import '../model/transaction_summary_model.dart';
import '../service/transaction_service.dart';

class TransactionRepository {
  final TransactionService service;
  const TransactionRepository({
    required this.service,
  });

  Future<Either<Failure, List<TransactionModel>>> getAll({
    required TransactionFilterModel filter,
  }) async {
    try {
      final result = await service.getAll(filter: filter);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<TransactionModel>>> getRecentTransaction() async {
    try {
      final result = await service.getRecentTransaction();
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<TransactionModel>>> getTransactionByPersonAndType(
    int personId, {
    required TypeTransaction type,
  }) async {
    try {
      final result =
          await service.getTransactionByPersonAndType(personId, type: type);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, TransactionSummaryModel>> getSummaryTransaction({
    required TransactionFilterModel filter,
  }) async {
    try {
      final result = await service.getSummaryTransaction(filter);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, TransactionDetailModel?>> getById({
    required int id,
  }) async {
    try {
      final result = await service.getById(id: id);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> insert({
    required FormTransactionModel transaction,
  }) async {
    try {
      final result = await service.insert(transaction: transaction);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> update({
    required FormTransactionModel transaction,
  }) async {
    try {
      final result = await service.update(transaction: transaction);
      return right(result);
    } catch (e) {
      return left(CommonFailure(e.toString()));
    }
  }
}
