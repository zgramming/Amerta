import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../service/export_service.dart';

class ExportRepository {
  final ExportService exportService;
  ExportRepository({
    required this.exportService,
  });
  Future<Either<Failure, File>> export() async {
    try {
      final result = await exportService.export();
      return Right(result);
    } catch (e) {
      return Left(CommonFailure(e.toString()));
    }
  }
}
