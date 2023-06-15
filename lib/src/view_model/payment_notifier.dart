import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model/form_payment_model.dart';
import '../model/model/payment_model.dart';
import '../model/repository/payment_repository.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository repository;
  final int transactionId;
  PaymentNotifier({
    required this.repository,
    required this.transactionId,
  }) : super(const PaymentState()) {
    getAll(transactionId);
  }

  Future<void> getAll(int transactionId) async {
    state = state.copyWith(asyncItems: const AsyncLoading());
    final result = await repository.getAll(transactionId);
    result.fold(
      (l) => state =
          state.copyWith(asyncItems: AsyncError(l.message, StackTrace.current)),
      (r) => state = state.copyWith(asyncItems: AsyncData(r)),
    );
  }

  Future<void> save(FormPaymentModel payment) async {
    state = state.copyWith(onSave: const AsyncLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await repository.save(payment);
    result.fold(
      (l) => state = state.copyWith(
        onSave: AsyncError(l.message, StackTrace.current),
      ),
      (r) => state = state.copyWith(
        onSave: const AsyncData("Success save payment"),
        asyncItems: AsyncData(r),
      ),
    );
  }

  Future<void> update(FormPaymentModel payment) async {
    state = state.copyWith(onUpdate: const AsyncLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await repository.update(payment);
    result.fold(
      (l) => state = state.copyWith(
        onUpdate: AsyncError(l.message, StackTrace.current),
      ),
      (r) => state = state.copyWith(
        onUpdate: const AsyncData("Success update payment"),
        asyncItems: AsyncData(r),
      ),
    );
  }

  Future<void> delete({
    required int paymentId,
    required int transactionId,
  }) async {
    state = state.copyWith(onDelete: const AsyncLoading());
    await Future.delayed(const Duration(seconds: 1));
    final result = await repository.delete(
      paymentId: paymentId,
      transactionId: transactionId,
    );
    result.fold(
      (l) => state = state.copyWith(
        onDelete: AsyncError(l.message, StackTrace.current),
      ),
      (r) => state = state.copyWith(
        onDelete: const AsyncData("Success delete payment"),
        asyncItems: AsyncData(r),
      ),
    );
  }
}

class PaymentState extends Equatable {
  final AsyncValue<List<PaymentModel>> asyncItems;
  final AsyncValue<String?> onSave;
  final AsyncValue<String?> onUpdate;
  final AsyncValue<String?> onDelete;
  const PaymentState({
    this.asyncItems = const AsyncData([]),
    this.onSave = const AsyncData(null),
    this.onUpdate = const AsyncData(null),
    this.onDelete = const AsyncData(null),
  });

  @override
  List<Object> get props => [asyncItems, onSave, onUpdate, onDelete];

  @override
  bool get stringify => true;

  PaymentState copyWith({
    AsyncValue<List<PaymentModel>>? asyncItems,
    AsyncValue<String?>? onSave,
    AsyncValue<String?>? onUpdate,
    AsyncValue<String?>? onDelete,
  }) {
    return PaymentState(
      asyncItems: asyncItems ?? this.asyncItems,
      onSave: onSave ?? this.onSave,
      onUpdate: onUpdate ?? this.onUpdate,
      onDelete: onDelete ?? this.onDelete,
    );
  }
}
