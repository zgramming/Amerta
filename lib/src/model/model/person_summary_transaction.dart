// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PersonSummaryTransaction extends Equatable {
  final int personId;
  final String personName;
  final double totalAmountHutang;
  final double totalAmountPiutang;
  final int totalCountHutang;
  final int totalCountPiutang;

  const PersonSummaryTransaction({
    required this.totalAmountHutang,
    required this.totalAmountPiutang,
    required this.totalCountHutang,
    required this.totalCountPiutang,
    required this.personId,
    required this.personName,
  });

  @override
  List<Object> get props {
    return [
      totalAmountHutang,
      totalAmountPiutang,
      totalCountHutang,
      totalCountPiutang,
      personId,
      personName,
    ];
  }

  @override
  bool get stringify => true;

  PersonSummaryTransaction copyWith({
    double? totalAmountHutang,
    double? totalAmountPiutang,
    int? totalCountHutang,
    int? totalCountPiutang,
    int? personId,
    String? personName,
  }) {
    return PersonSummaryTransaction(
      totalAmountHutang: totalAmountHutang ?? this.totalAmountHutang,
      totalAmountPiutang: totalAmountPiutang ?? this.totalAmountPiutang,
      totalCountHutang: totalCountHutang ?? this.totalCountHutang,
      totalCountPiutang: totalCountPiutang ?? this.totalCountPiutang,
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
    );
  }
}
