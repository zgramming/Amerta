import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model/pdf_report_filter_model.dart';
import '../model/repository/pdf_report_repository.dart';

class PDFReportNotifier extends StateNotifier<File?> {
  final PDFReportRepository repository;
  PDFReportNotifier({
    required this.repository,
  }) : super(null);

  Future<void> generateAllReport({
    required PDFReportFilterModel filter,
    required void Function(File file) onSuccess,
    required void Function(String message) onError,
    required void Function() onLoading,
  }) async {
    onLoading();
    final result = await repository.generateAllReport(filter: filter);

    return result.fold((l) => onError(l.message), (r) => onSuccess(r));
  }

  Future<void> generateReportDetailTransaction(
    int transactionId, {
    required void Function(File file) onSuccess,
    required void Function(String message) onError,
    required void Function() onLoading,
  }) async {
    onLoading();
    final result = await repository.generateReportDetailTransaction(
      transactionId,
    );

    return result.fold((l) => onError(l.message), (r) => onSuccess(r));
  }

  Future<void> generateReportByPerson(
    int personId, {
    required PDFReportFilterModel filter,
    required void Function(String message) onError,
    required void Function() onLoading,
    required void Function(File file) onSuccess,
  }) async {
    onLoading();
    final result = await repository.generateReportByPerson(
      personId,
      filter: filter,
    );

    result.fold((l) => onError(l.message), (r) => onSuccess(r));
  }
}
