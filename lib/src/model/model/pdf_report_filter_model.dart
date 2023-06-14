// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:amerta/src/utils/enums.dart';

class PDFReportFilterModel extends Equatable {
  final PrintTrxType type;
  const PDFReportFilterModel({
    this.type = PrintTrxType.all,
  });

  @override
  List<Object> get props => [type];

  @override
  bool get stringify => true;

  PDFReportFilterModel copyWith({
    PrintTrxType? type,
  }) {
    return PDFReportFilterModel(
      type: type ?? this.type,
    );
  }
}
