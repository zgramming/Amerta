// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:amerta/src/utils/enums.dart';

class ParameterTransactionByPersonTypeModel extends Equatable {
  final int personId;
  final TypeTransaction type;
  const ParameterTransactionByPersonTypeModel({
    required this.personId,
    required this.type,
  });

  @override
  List<Object> get props => [personId, type];

  @override
  bool get stringify => true;
}
