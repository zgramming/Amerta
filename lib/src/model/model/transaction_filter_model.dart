// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TransactionFilterModel extends Equatable {
  const TransactionFilterModel({
    required this.startDate,
    required this.endDate,
    required this.searchQuery,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String searchQuery;

  @override
  List<Object> get props => [startDate, endDate, searchQuery];

  @override
  bool get stringify => true;

  TransactionFilterModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return TransactionFilterModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
