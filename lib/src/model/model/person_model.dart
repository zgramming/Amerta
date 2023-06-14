// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PersonModel extends Equatable {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PersonModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, name, createdAt, updatedAt];

  @override
  bool get stringify => true;

  PersonModel copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
