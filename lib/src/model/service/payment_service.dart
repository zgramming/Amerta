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
