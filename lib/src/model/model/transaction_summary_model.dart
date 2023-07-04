// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TransactionSummaryModel extends Equatable {
  final double totalHutang;
  final double totalPiutang;
  final double totalTransaction;
  final double totalHutangWithPayment;
  final double totalPiutangWithPayment;
  final int countTransaction;

  const TransactionSummaryModel({
    required this.totalHutang,
    required this.totalPiutang,
    required this.totalTransaction,
    required this.totalHutangWithPayment,
    required this.totalPiutangWithPayment,
    required this.countTransaction,
  });

  @override
  List<Object> get props {
    return [
      totalHutang,
      totalPiutang,
      totalTransaction,
      totalHutangWithPayment,
      totalPiutangWithPayment,
      countTransaction,
    ];
  }

  @override
  bool get stringify => true;

  TransactionSummaryModel copyWith({
    double? totalHutang,
    double? totalPiutang,
    double? totalTransaction,
    double? totalHutangWithPayment,
    double? totalPiutangWithPayment,
    int? countTransaction,
  }) {
    return TransactionSummaryModel(
      totalHutang: totalHutang ?? this.totalHutang,
      totalPiutang: totalPiutang ?? this.totalPiutang,
      totalTransaction: totalTransaction ?? this.totalTransaction,
      totalHutangWithPayment:
          totalHutangWithPayment ?? this.totalHutangWithPayment,
      totalPiutangWithPayment:
          totalPiutangWithPayment ?? this.totalPiutangWithPayment,
      countTransaction: countTransaction ?? this.countTransaction,
    );
  }
}
