// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final int id;
  final int transactionId;
  final int personId;
  final double amount;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    required this.transactionId,
    required this.personId,
    required this.amount,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      transactionId,
      personId,
      amount,
      description,
      createdAt,
      updatedAt,
    ];
  }

  @override
  bool get stringify => true;

  PaymentModel copyWith({
    int? id,
    int? transactionId,
    int? personId,
    double? amount,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      personId: personId ?? this.personId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
