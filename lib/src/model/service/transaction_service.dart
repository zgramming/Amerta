import 'package:amerta/src/model/model/form_transaction_model.dart';
import 'package:amerta/src/model/model/transaction_summary_model.dart';
import 'package:amerta/src/utils/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amerta/src/model/database/helper.dart';
import 'package:amerta/src/model/model/transaction_detail_model.dart';
import 'package:amerta/src/model/model/transaction_model.dart';
import 'package:amerta/src/utils/failure.dart';

import '../model/transaction_filter_model.dart';

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

  Future<List<TransactionModel>> getTransactionByType(
    TypeTransaction type,
  ) async {
    return await databaseHelper.getTransactionByType(type);
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

  Future<Either<Failure, List<TransactionModel>>> getTransactionByType({
    required TypeTransaction type,
  }) async {
    try {
      final result = await service.getTransactionByType(type);
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

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository repository;
  final TransactionFilterModel filter;
  TransactionNotifier({
    required this.repository,
    required this.filter,
  }) : super(const TransactionState()) {
    getAll(filter: filter);
  }

  Future<void> getAll({
    required TransactionFilterModel filter,
  }) async {
    state = state.copyWith(items: const AsyncLoading());
    final result = await repository.getAll(filter: filter);
    result.fold(
      (l) => state =
          state.copyWith(items: AsyncError(l.message, StackTrace.current)),
      (r) => state = state.copyWith(items: AsyncData(r)),
    );
  }

  Future<void> save(
    FormTransactionModel transaction,
  ) async {
    state = state.copyWith(
      onSave: const AsyncLoading(),
    );

    await Future.delayed(const Duration(seconds: 1));

    final result = await repository.insert(transaction: transaction);
    result.fold(
      (l) => state =
          state.copyWith(onSave: AsyncError(l.message, StackTrace.current)),
      (r) async {
        await getAll(filter: filter);
        return state = state.copyWith(onSave: AsyncData(r));
      },
    );
  }

  Future<void> update(
    FormTransactionModel transaction,
  ) async {
    state = state.copyWith(onUpdate: const AsyncLoading());
    final result = await repository.update(transaction: transaction);
    result.fold(
      (l) => state =
          state.copyWith(onUpdate: AsyncError(l.message, StackTrace.current)),
      (r) async {
        await getAll(filter: filter);
        return state = state.copyWith(onUpdate: AsyncData(r));
      },
    );
  }
}

class TransactionState extends Equatable {
  final AsyncValue<List<TransactionModel>> items;
  final AsyncValue<String?> onSave;
  final AsyncValue<String?> onUpdate;
  const TransactionState({
    this.items = const AsyncData([]),
    this.onSave = const AsyncData(null),
    this.onUpdate = const AsyncData(null),
  });

  @override
  List<Object> get props => [items, onSave, onUpdate];

  @override
  bool get stringify => true;

  TransactionState copyWith({
    AsyncValue<List<TransactionModel>>? items,
    AsyncValue<String?>? onSave,
    AsyncValue<String?>? onUpdate,
  }) {
    return TransactionState(
      items: items ?? this.items,
      onSave: onSave ?? this.onSave,
      onUpdate: onUpdate ?? this.onUpdate,
    );
  }
}
