import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model/form_transaction_model.dart';
import '../model/model/transaction_filter_model.dart';
import '../model/model/transaction_model.dart';
import '../model/repository/transaction_repository.dart';

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
