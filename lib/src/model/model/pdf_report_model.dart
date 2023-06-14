// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../utils/enums.dart';

class PDFReportModel extends Equatable {
  final String title;
  final String personName;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final TypeTransaction type;
  final double paid;

  const PDFReportModel({
    required this.title,
    required this.personName,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.paid,
  });

  @override
  List<Object> get props {
    return [
      title,
      personName,
      amount,
      startDate,
      endDate,
      type,
      paid,
    ];
  }

  @override
  bool get stringify => true;

  PDFReportModel copyWith({
    String? title,
    String? personName,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    TypeTransaction? type,
    double? paid,
  }) {
    return PDFReportModel(
      title: title ?? this.title,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      paid: paid ?? this.paid,
    );
  }
}
