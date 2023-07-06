// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils/enums.dart';

part 'export_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExportedPersonModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  ExportedPersonModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExportedPersonModel.fromJson(Map<String, dynamic> data) =>
      _$ExportedPersonModelFromJson(data);

  Map<String, dynamic> toJson() => _$ExportedPersonModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExportedTransactionModel {
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
  ExportedTransactionModel({
    required this.id,
    required this.personId,
    required this.title,
    required this.amount,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.typeTransaction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExportedTransactionModel.fromJson(Map<String, dynamic> data) =>
      _$ExportedTransactionModelFromJson(data);

  Map<String, dynamic> toJson() => _$ExportedTransactionModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExportedPaymentModel {
  final int id;
  final int transactionId;
  final int personId;
  final double amount;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExportedPaymentModel({
    required this.id,
    required this.transactionId,
    required this.personId,
    required this.amount,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExportedPaymentModel.fromJson(Map<String, dynamic> data) =>
      _$ExportedPaymentModelFromJson(data);

  Map<String, dynamic> toJson() => _$ExportedPaymentModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ExportDataModel extends Equatable {
  final List<ExportedPersonModel> persons;
  final List<ExportedTransactionModel> transactions;
  final List<ExportedPaymentModel> payments;

  const ExportDataModel({
    required this.persons,
    required this.transactions,
    required this.payments,
  });

  factory ExportDataModel.fromJson(Map<String, dynamic> data) =>
      _$ExportDataModelFromJson(data);

  Map<String, dynamic> toJson() => _$ExportDataModelToJson(this);

  @override
  List<Object> get props => [persons, transactions, payments];

  @override
  bool get stringify => true;

  ExportDataModel copyWith({
    List<ExportedPersonModel>? persons,
    List<ExportedTransactionModel>? transactions,
    List<ExportedPaymentModel>? payments,
  }) {
    return ExportDataModel(
      persons: persons ?? this.persons,
      transactions: transactions ?? this.transactions,
      payments: payments ?? this.payments,
    );
  }
}
