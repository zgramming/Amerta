import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class FormTransactionModel extends Equatable {
  final int? id;
  final int personId;
  final String title;
  final String? description;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final TypeTransaction typeTransaction;
  const FormTransactionModel({
    required this.id,
    required this.personId,
    required this.title,
    this.description,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.typeTransaction = TypeTransaction.hutang,
  });

  @override
  List<Object?> get props {
    return [
      id,
      personId,
      title,
      description,
      amount,
      startDate,
      endDate,
      typeTransaction,
    ];
  }

  @override
  bool get stringify => true;

  FormTransactionModel copyWith({
    int? id,
    int? personId,
    String? title,
    String? description,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    TypeTransaction? typeTransaction,
  }) {
    return FormTransactionModel(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      typeTransaction: typeTransaction ?? this.typeTransaction,
    );
  }
}
