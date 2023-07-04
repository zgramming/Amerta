// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class TransactionModel extends Equatable {
  final int id;
  final int personId;
  final String title;
  final double amount;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final TypeTransaction typeTransaction;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String personName;
  final double paymentAmount;
  final bool isPaid;

  const TransactionModel({
    required this.id,
    required this.personId,
    required this.title,
    required this.amount,
    this.description,
    required this.startDate,
    required this.endDate,
    this.typeTransaction = TypeTransaction.hutang,
    required this.createdAt,
    required this.updatedAt,
    required this.personName,
    required this.paymentAmount,
    required this.isPaid,
  });

  @override
  List<Object?> get props {
    return [
      id,
      personId,
      title,
      amount,
      description,
      startDate,
      endDate,
      typeTransaction,
      createdAt,
      updatedAt,
      personName,
      paymentAmount,
      isPaid,
    ];
  }

  @override
  bool get stringify => true;

  TransactionModel copyWith({
    int? id,
    int? personId,
    String? title,
    double? amount,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TypeTransaction? typeTransaction,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? personName,
    double? paymentAmount,
    bool? isPaid,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      typeTransaction: typeTransaction ?? this.typeTransaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      personName: personName ?? this.personName,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
