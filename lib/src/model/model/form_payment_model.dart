import 'package:equatable/equatable.dart';

class FormPaymentModel extends Equatable {
  final int? id;
  final int transactionId;
  final double amount;
  final String? description;
  const FormPaymentModel({
    this.id,
    required this.transactionId,
    required this.amount,
    this.description,
  });

  @override
  List<Object?> get props => [id, transactionId, amount, description];

  @override
  bool get stringify => true;

  FormPaymentModel copyWith({
    int? id,
    int? transactionId,
    double? amount,
    String? description,
  }) {
    return FormPaymentModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }
}
