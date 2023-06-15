import 'dart:io';

import '../../utils/functions.dart';
import '../database/helper.dart';
import '../model/pdf_report_filter_model.dart';

class PDFReportService {
  final DatabaseHelper databaseHelper;
  const PDFReportService({
    required this.databaseHelper,
  });

  Future<File> generateAllReport({required PDFReportFilterModel filter}) async {
    final reports = await databaseHelper.getAllReportPDF(filter: filter);
    final pdf =
        await FunctionUtils.generatePDFTransaction(transactions: reports);
    return pdf;
  }

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
