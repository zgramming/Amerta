// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:amerta/src/utils/enums.dart';

class TransactionFilterModel extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final TypeTransaction? typeTransaction;
  const TransactionFilterModel({
    required this.startDate,
    required this.endDate,
    this.typeTransaction,
  });

  @override
  List<Object?> get props => [startDate, endDate, typeTransaction];

  @override
  bool get stringify => true;

  TransactionFilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TypeTransaction? typeTransaction,
  }) {
    return TransactionFilterModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      typeTransaction: typeTransaction ?? this.typeTransaction,
    );
  }
}
