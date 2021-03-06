import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../database/query/payment_query.dart';
import '../../model/payment/form_payment_parameter.dart';
import '../../model/payment/payment_insertorupdate_response.dart';
import '../../model/payment/payment_model.dart';
import '../../model/payment/payment_summary_model.dart';
import '../../model/payment/payments_parameter.dart';

class PaymentLocalService {
  const PaymentLocalService({
    required this.query,
  });

  final PaymentTableQuery query;

  Future<PaymentModel?> getById(String? id) async {
    final result = await query.getById(id);
    return result;
  }

  Future<PaymentSummaryModel?> getPaymentSummary({
    required String peopleId,
    required String transactionId,
  }) async {
    final result = await query.getPaymentSummary(
      peopleId: peopleId,
      transactionId: transactionId,
    );
    return result;
  }

  Future<Map<DateTime, List<PaymentModel>>> getPayments(
    PaymentsParameter param,
  ) async {
    final result = await query.getPayments(param);
    final groupedList = groupBy<PaymentModel, DateTime>(
      result,
      (trx) {
        final date = trx.date!;
        return DateTime(date.year, date.month, date.day);
      },
    );

    return groupedList;
  }

  Future<PaymentInsertOrUpdateResponse> insertOrUpdatePayment(FormPaymentParameter form) async {
    await Future.delayed(kThemeAnimationDuration);
    final result = await query.insertOrUpdatePayment(form);
    return result;
  }

  Future<int> deletePayment(String id) async {
    await Future.delayed(kThemeAnimationDuration);
    final result = await query.deletePayment(id);
    return result;
  }
}
