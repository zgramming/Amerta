import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/failure.dart';
import '../../utils/functions.dart';
import '../database/helper.dart';
import '../model/pdf_report_filter_model.dart';

class PDFReportService {
  final DatabaseHelper databaseHelper;
  const PDFReportService({
    required this.databaseHelper,
  });

  Future<File> generateReportDetailTransaction(int transactionId) async {
    final reports = await databaseHelper.getReportPDFDetailTransaction(
      transactionId: transactionId,
    );
    final pdf =
        await FunctionUtils.generatePDFTransaction(transactions: reports);
    return pdf;
  }

  Future<File> generateReportByPerson(
    int personId, {
    required PDFReportFilterModel filter,
  }) async {
    final reports = await databaseHelper.getReportPDFByPerson(
      personId,
      filter: filter,
    );
    final pdf =
        await FunctionUtils.generatePDFTransaction(transactions: reports);
    return pdf;
  }
}

class PDFReportRepository {
  final PDFReportService pdfReportService;
  const PDFReportRepository({
    required this.pdfReportService,
  });

  Future<Either<Failure, File>> generateReportDetailTransaction(
    int transactionId,
  ) async {
    try {
      final pdf =
          await pdfReportService.generateReportDetailTransaction(transactionId);
      return Right(pdf);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

  Future<Either<Failure, File>> generateReportByPerson(
    int personId, {
    required PDFReportFilterModel filter,
  }) async {
    try {
      final pdf = await pdfReportService.generateReportByPerson(
        personId,
        filter: filter,
      );
      return Right(pdf);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}

class PDFReportNotifier extends StateNotifier<File?> {
  final PDFReportRepository repository;
  PDFReportNotifier({
    required this.repository,
  }) : super(null);

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
