// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PersonFilterModel extends Equatable {
  final String searchQuery;
  const PersonFilterModel({
    required this.searchQuery,
  });

  @override
  List<Object> get props => [searchQuery];

  PersonFilterModel copyWith({
    String? searchQuery,
  }) {
    return PersonFilterModel(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool get stringify => true;
}
