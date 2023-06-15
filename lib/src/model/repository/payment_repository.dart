import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../model/form_payment_model.dart';
import '../model/payment_model.dart';
import '../service/payment_service.dart';

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
