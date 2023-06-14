import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/model/transaction_filter_model.dart';

final transactionFilterProvider = StateProvider<TransactionFilterModel>(
  (ref) {
    final now = DateTime.now();
    final fixedNow = DateTime(now.year, now.month, now.day);
    return TransactionFilterModel(
      startDate: fixedNow.subtract(const Duration(days: 90)),
      endDate: fixedNow.add(const Duration(days: 90)),
    );
  },
);
