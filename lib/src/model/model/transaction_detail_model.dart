// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class TransactionDetailModel extends Equatable {
  final int id;
  final String title;
  final TypeTransaction typeTransaction;
  final double amount;
  final double paid;
  final double remaining;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final String? description;
  final int personId;
  final String personName;

  const TransactionDetailModel({
    required this.id,
    required this.title,
    required this.typeTransaction,
    required this.amount,
    required this.paid,
    required this.remaining,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.description,
    required this.personId,
    required this.personName,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      typeTransaction,
      amount,
      paid,
      remaining,
      startDate,
      endDate,
      createdAt,
      description,
      personId,
      personName,
    ];
  }

  @override
  bool get stringify => true;

  TransactionDetailModel copyWith({
    int? id,
    String? title,
    TypeTransaction? typeTransaction,
    double? amount,
    double? paid,
    double? remaining,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    String? description,
    int? personId,
    String? personName,
  }) {
    return TransactionDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      typeTransaction: typeTransaction ?? this.typeTransaction,
      amount: amount ?? this.amount,
      paid: paid ?? this.paid,
      remaining: remaining ?? this.remaining,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
    );
  }
}
