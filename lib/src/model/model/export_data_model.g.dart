// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportedPersonModel _$ExportedPersonModelFromJson(Map<String, dynamic> json) =>
    ExportedPersonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExportedPersonModelToJson(
        ExportedPersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ExportedTransactionModel _$ExportedTransactionModelFromJson(
        Map<String, dynamic> json) =>
    ExportedTransactionModel(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      typeTransaction:
          $enumDecode(_$TypeTransactionEnumMap, json['type_transaction']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExportedTransactionModelToJson(
        ExportedTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'person_id': instance.personId,
      'title': instance.title,
      'amount': instance.amount,
      'description': instance.description,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'type_transaction': _$TypeTransactionEnumMap[instance.typeTransaction]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TypeTransactionEnumMap = {
  TypeTransaction.hutang: 'hutang',
  TypeTransaction.piutang: 'piutang',
};

ExportedPaymentModel _$ExportedPaymentModelFromJson(
        Map<String, dynamic> json) =>
    ExportedPaymentModel(
      id: json['id'] as int,
      transactionId: json['transaction_id'] as int,
      personId: json['person_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ExportedPaymentModelToJson(
        ExportedPaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transactionId,
      'person_id': instance.personId,
      'amount': instance.amount,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

ExportDataModel _$ExportDataModelFromJson(Map<String, dynamic> json) =>
    ExportDataModel(
      persons: (json['persons'] as List<dynamic>)
          .map((e) => ExportedPersonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) =>
              ExportedTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => ExportedPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExportDataModelToJson(ExportDataModel instance) =>
    <String, dynamic>{
      'persons': instance.persons,
      'transactions': instance.transactions,
      'payments': instance.payments,
    };
