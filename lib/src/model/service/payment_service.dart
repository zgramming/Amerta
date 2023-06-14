// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/failure.dart';
import '../database/helper.dart';
import '../model/form_payment_model.dart';
import '../model/payment_model.dart';

class PaymentService {
  final DatabaseHelper databaseHelper;
  const PaymentService({
    required this.databaseHelper,
  });

  Future<List<PaymentModel>> getAll(int transactionId) async {
    final result = await databaseHelper.getAllPayment(transactionId);
    return result;
  }

  Future<PaymentModel?> getById(int paymentId) async {
    final result = await databaseHelper.getPaymentById(paymentId);
    return result;
  }

  Future<List<PaymentModel>> save(FormPaymentModel payment) async {
    await databaseHelper.savePayment(payment);
    return getAll(payment.transactionId);
  }

  Future<List<PaymentModel>> update(FormPaymentModel payment) async {
    await databaseHelper.updatePayment(payment);
    return getAll(payment.transactionId);
  }

  Future<List<PaymentModel>> delete({
    required int paymentId,
    required int transactionId,
  }) async {
    await databaseHelper.deletePayment(paymentId);
    return getAll(transactionId);
  }
}

class PaymentRepository {
  final PaymentService paymentService;
  const PaymentRepository({
    required this.paymentService,
  });

  Future<Either<Failure, List<PaymentModel>>> getAll(int transactionId) async {
    try {
      final result = await paymentService.getAll(transactionId);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaymentModel?>> getById(int paymentId) async {
    try {
      final result = await paymentService.getById(paymentId);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PaymentModel>>> save(
    FormPaymentModel payment,
  ) async {
    try {
      final result = await paymentService.save(payment);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PaymentModel>>> update(
    FormPaymentModel payment,
  ) async {
    try {
      final result = await paymentService.update(payment);
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PaymentModel>>> delete({
    required int paymentId,
    required int transactionId,
  }) async {
    try {
      final result = await paymentService.delete(
        paymentId: paymentId,
        transactionId: transactionId,
      );
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}

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
