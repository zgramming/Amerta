// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TransactionSummaryModel extends Equatable {
  final double totalHutang;
  final double totalPiutang;
  final double totalTransaction;
  final int countTransaction;

  const TransactionSummaryModel({
    required this.totalHutang,
    required this.totalPiutang,
    required this.totalTransaction,
    required this.countTransaction,
  });

  @override
  List<Object> get props =>
      [totalHutang, totalPiutang, totalTransaction, countTransaction];

  @override
  bool get stringify => true;

  TransactionSummaryModel copyWith({
    double? totalHutang,
    double? totalPiutang,
    double? totalTransaction,
    int? countTransaction,
  }) {
    return TransactionSummaryModel(
      totalHutang: totalHutang ?? this.totalHutang,
      totalPiutang: totalPiutang ?? this.totalPiutang,
      totalTransaction: totalTransaction ?? this.totalTransaction,
      countTransaction: countTransaction ?? this.countTransaction,
    );
  }
}
