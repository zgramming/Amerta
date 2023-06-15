import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../model/pdf_report_filter_model.dart';
import '../service/pdf_report_service.dart';

class PDFReportRepository {
  final PDFReportService pdfReportService;
  const PDFReportRepository({
    required this.pdfReportService,
  });

  Future<Either<Failure, File>> generateAllReport({
    required PDFReportFilterModel filter,
  }) async {
    try {
      final pdf = await pdfReportService.generateAllReport(filter: filter);
      return Right(pdf);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }

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
